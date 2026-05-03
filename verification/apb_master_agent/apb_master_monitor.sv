class apb_master_monitor extends uvm_monitor;
  `uvm_component_utils(apb_master_monitor)

  virtual apb_interface apb_vif;
  uvm_analysis_port #(apb_master_transaction) analysis_port;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task          run_phase  (uvm_phase phase);
  extern virtual task          monitor_dut(output apb_master_transaction tr);
endclass: apb_master_monitor

function void apb_master_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get interface handle
  if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_master_if", apb_vif))
    `uvm_fatal("apb_master_monitor::build_phase", "Failed to get apb apb_master_if handle from cfg DB!")
  // Create analysis port
  analysis_port = new("analysis_port", this);
endfunction: build_phase

task apb_master_monitor::run_phase(uvm_phase phase);
  apb_master_transaction tr;
  // Wait for initial reset to complete
  repeat (2) @(posedge apb_vif.preset_n);
  forever begin
    fork
      forever begin
        @ (negedge apb_vif.preset_n);
        `uvm_info("run_phase", "Async reset detected!", UVM_LOW)
        break;
      end
      forever begin
        monitor_dut(tr);
      end
    join_any
    disable fork;
    tr.aborted = 1;
    // Wait for reset to finish
    @ (posedge apb_vif.preset_n);
    `uvm_info("run_phase", "Async reset completed!", UVM_LOW)
  end
endtask: run_phase

task apb_master_monitor::monitor_dut(output apb_master_transaction tr);
  tr = apb_master_transaction::type_id::create("tr");
  
  // Wait for setup phase
  while (!((apb_vif.master_monitor_cb.psel === 1) && (apb_vif.master_monitor_cb.penable === 0))) begin
    @ (apb_vif.master_monitor_cb);
  end

  // Access phase started
  @ (apb_vif.master_monitor_cb iff apb_vif.master_monitor_cb.pready);
  tr.paddr = apb_vif.master_monitor_cb.paddr;
  tr.op = (apb_vif.master_monitor_cb.pwrite === 1) ? WRITE : READ;
  tr.data = (tr.op == WRITE) ? apb_vif.master_monitor_cb.pwdata : '0;
  tr.pstrb = apb_vif.master_monitor_cb.pstrb;
  tr.pslverr = apb_vif.master_monitor_cb.pslverr;

  `uvm_info("APB_MON", $sformatf("Transaction: %s", tr.convert2string()), UVM_LOW)

  @ (apb_vif.master_monitor_cb);
endtask