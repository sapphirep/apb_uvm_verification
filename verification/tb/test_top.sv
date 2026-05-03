import uvm_pkg::*;
`include "uvm_macros.svh"

module test_top;
  timeunit 1ns/1ps;

  parameter APB_ADDR_WIDTH = 16;
  parameter APB_DATA_WIDTH = 32;

  logic pclk;
  logic preset_n;
  logic hw_ctl;

  apb_interface #(
    .ADDR_WIDTH(APB_ADDR_WIDTH), .DATA_WIDTH(APB_DATA_WIDTH)
  ) apb_if (
    .pclk(pclk), 
    .preset_n(preset_n)
  );

  apb_slave #(
    .ADDR_WIDTH(APB_ADDR_WIDTH), .DATA_WIDTH(APB_DATA_WIDTH)
  ) apb_slave_dut (
    .pclk      (apb_if.pclk    ),
    .preset_n  (apb_if.preset_n),
    .i_paddr   (apb_if.paddr   ),
    .i_psel    (apb_if.psel    ),
    .i_penable (apb_if.penable ),
    .i_pwrite  (apb_if.pwrite  ),
    .i_pwdata  (apb_if.pwdata  ),
    .i_pstrb   (apb_if.pstrb   ),
    .o_pready  (apb_if.pready  ),
    .o_prdata  (apb_if.prdata  ),
    .o_pslverr (apb_if.pslverr ),
    .o_hw_ctl  (hw_ctl         ),
    .i_hw_sts  (1'b1           )
  );

  bind apb_slave apb_slave_assertions u_apb_slave_assertions (
    .pclk    (pclk     ),
    .preset_n(preset_n ),
    .paddr   (i_paddr  ),
    .psel    (i_psel   ),
    .penable (i_penable),
    .pwrite  (i_pwrite ),
    .pwdata  (i_pwdata ),
    .pstrb   (i_pstrb  ),
    .pready  (o_pready ),
    .prdata  (o_prdata ),
    .pslverr (o_pslverr)
  );

  initial begin
    pclk <= 0;
    #10ns;
    forever #5ns pclk = ~pclk; // 100MHz clock
  end

  initial begin
    preset_n <= 1;
    repeat (2) @ (negedge pclk);
    preset_n = 0;
    @ (negedge pclk);
    preset_n = 1;

    repeat (6) @ (negedge pclk);
    preset_n = 0;
    repeat (2) @ (negedge pclk);
    preset_n = 1;
  end

initial begin
  $fsdbDumpfile("waves.fsdb");
  $fsdbDumpvars(0, test_top);  // depth 0 = all, scope = top
  $fsdbDumpSVA(0, test_top);   // dump SVA in this scope and below
  $fsdbDumpMDA(0, test_top);   // multi-dim arrays
end

  initial begin
    uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.*", "apb_master_if", apb_if);
    run_test();
  end

endmodule