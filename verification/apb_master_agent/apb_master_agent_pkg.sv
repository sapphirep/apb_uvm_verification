package apb_master_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import apb_shared_pkg::*;

  `include "apb_master_transaction.sv"
  typedef uvm_sequencer #(apb_master_transaction) apb_master_sequencer;

  `include "apb_master_driver.sv"
  `include "apb_master_monitor.sv"
  `include "apb_master_agent.sv"
endpackage: apb_master_agent_pkg