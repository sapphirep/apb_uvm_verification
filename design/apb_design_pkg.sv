package apb_design_pkg;

  // --------------- Parameters ---------------
  parameter  int APB_DATA_WIDTH  = 32;
  parameter  int APB_ADDR_WIDTH  = 16;
  localparam int APB_STRB_WIDTH  = APB_DATA_WIDTH / 8;
  parameter int FIFO_DEPTH  = 8;

endpackage