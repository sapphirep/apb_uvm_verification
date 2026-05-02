interface apb_interface
#(
  parameter  APB_ADDR_WIDTH = 16,
  parameter  APB_DATA_WIDTH = 32,
  localparam APB_STRB_WIDTH = APB_DATA_WIDTH / 8
) (
  input logic pclk,
  input logic preset_n
);
  logic [APB_ADDR_WIDTH-1:0] paddr;
  logic                      psel;
  logic                      penable;
  logic                      pwrite;
  logic [APB_DATA_WIDTH-1:0] pwdata;
  logic [APB_STRB_WIDTH-1:0] pstrb;
  logic                      pready;
  logic [APB_DATA_WIDTH-1:0] prdata;
  logic                      pslverr;

  clocking master_driver @(posedge pclk);
    default input #1step output #20ps;
    output paddr, psel, penable, pwrite, pwdata, pstrb;
    input  pready, prdata, pslverr;
  endclocking: master_driver

  clocking master_monitor @(posedge pclk);
    default input #1step output #20ps;
    input paddr, psel, penable, pwrite, pwdata, pstrb;
    input pready, prdata, pslverr;
  endclocking: master_monitor

  modport APB_MASTER_DRIVER (
    clocking master_driver,
    input preset_n
  );

  modport APB_MASTER_MONITOR (
    clocking master_monitor,
    input preset_n
  );

endinterface: apb_interface