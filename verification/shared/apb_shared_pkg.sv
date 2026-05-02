package apb_shared_pkg;
  `define APB_DATA_WIDTH 32
  `define APB_ADDR_WIDTH 16
  `define APB_STRB_WIDTH 4

  typedef enum bit [1:0] { IDLE, READ, WRITE } apb_op_e;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "apb_master_transaction.sv"
endpackage: apb_shared_pkg