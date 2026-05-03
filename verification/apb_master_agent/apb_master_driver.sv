class apb_master_driver extends uvm_driver #(apb_master_transaction);
  `uvm_component_utils(apb_master_driver)

  virtual apb_interface apb_vif;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task          run_phase  (uvm_phase phase);
  extern virtual task          drive_idle ();
  extern virtual task          drive_dut  (apb_master_transaction tr);
  extern virtual task          drive_read (apb_master_transaction tr);
  extern virtual task          drive_write(apb_master_transaction tr);
endclass: apb_master_driver

function void apb_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get interface handle
  if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_master_if", apb_vif))
    `uvm_fatal("apb_master_driver::build_phase", "Failed to get apb apb_master_if handle from cfg DB!")
endfunction: build_phase

task apb_master_driver::run_phase(uvm_phase phase);
  bit transaction_active = 0;

  // Drive idle and wait for initial reset to complete
  drive_idle();
  repeat (2) @ (posedge apb_vif.preset_n);

  forever begin
    fork
      forever begin
        @ (negedge apb_vif.preset_n);
        `uvm_info("run_phase", "Async reset detected!", UVM_LOW)
        break;
      end
      forever begin
        apb_master_transaction tr;
        seq_item_port.get_next_item(tr);
        transaction_active = 1;
        drive_dut(tr);
        seq_item_port.item_done();
        transaction_active = 0;
      end
    join_any
    disable fork;
    if (transaction_active) seq_item_port.item_done();
    drive_idle();
    @ (posedge apb_vif.preset_n);
    `uvm_info("run_phase", "Async reset completed!", UVM_LOW)
  end
endtask: run_phase

task apb_master_driver::drive_idle();
  apb_vif.pwrite  <= 0;
  apb_vif.psel    <= 0;
  apb_vif.penable <= 0;
  apb_vif.pwdata  <= '0;
  apb_vif.pstrb   <= '0;
endtask: drive_idle

task apb_master_driver::drive_dut(apb_master_transaction tr);
  case (tr.op) 
    IDLE:  drive_idle();
    READ:  drive_read(tr);
    WRITE: drive_write(tr);
  endcase
endtask: drive_dut

task apb_master_driver::drive_read(apb_master_transaction tr);
  // Setup phase
  @ (apb_vif.master_driver_cb);
  apb_vif.master_driver_cb.psel    <= 1'b1;
  apb_vif.master_driver_cb.penable <= 1'b0;
  apb_vif.master_driver_cb.pwrite  <= 1'b0;
  apb_vif.master_driver_cb.paddr   <= tr.paddr;
  apb_vif.master_driver_cb.pstrb   <= '0;

  // Access phase
  @ (apb_vif.master_driver_cb);
  apb_vif.master_driver_cb.penable <= 1'b1;

  @ (apb_vif.master_driver_cb iff apb_vif.master_driver_cb.pready);
  apb_vif.master_driver_cb.psel  <= 1'b0;
endtask

task apb_master_driver::drive_write(apb_master_transaction tr);
  // Setup phase
  @ (apb_vif.master_driver_cb);
  apb_vif.master_driver_cb.psel    <= 1'b1;
  apb_vif.master_driver_cb.penable <= 1'b0;
  apb_vif.master_driver_cb.pwrite  <= 1'b1;
  apb_vif.master_driver_cb.pwdata  <= tr.data;
  apb_vif.master_driver_cb.paddr   <= tr.paddr;
  apb_vif.master_driver_cb.pstrb   <= tr.pstrb;

  // Access phase
  @ (apb_vif.master_driver_cb);
  apb_vif.master_driver_cb.penable <= 1'b1;

  @ (apb_vif.master_driver_cb iff apb_vif.master_driver_cb.pready);
  apb_vif.master_driver_cb.psel    <= 1'b0;
  apb_vif.master_driver_cb.pwdata  <= '0;
endtask