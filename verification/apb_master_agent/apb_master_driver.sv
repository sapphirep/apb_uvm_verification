class apb_master_driver extends uvm_driver #(apb_master_transaction);
  `uvm_component_utils(apb_master_driver)

  virtual apb_interface apb_vif;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task          run_phase  (uvm_phase phase);
endclass: apb_master_driver

function void apb_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get interface handle
  if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_master_if", apb_vif))
    `uvm_fatal("apb_master_driver::build_phase", "Failed to get apb apb_master_if handle from cfg DB!")
endfunction: build_phase

task apb_master_driver::run_phase(uvm_phase phase);
  forever begin
    apb_master_transaction tr;
    seq_item_port.get_next_item(tr);
    seq_item_port.item_done();
  end
endtask: run_phase