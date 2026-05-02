class apb_master_monitor extends uvm_monitor;
  `uvm_component_utils(apb_master_monitor)

  virtual apb_interface apb_vif;
  uvm_analysis_port #(apb_master_transaction) analysis_port;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  extern virtual function void build_phase(uvm_phase phase);

endclass: apb_master_monitor

function void apb_master_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get interface handle
  if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_master_if", apb_vif))
    `uvm_fatal("apb_master_monitor::build_phase", "Failed to get apb apb_master_if handle from cfg DB!")
  // Create analysis port
  analysis_port = new("analysis_port", this);
endfunction: build_phase