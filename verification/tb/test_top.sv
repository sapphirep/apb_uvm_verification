module test_top;
  timeunit 1ns/1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  logic pclk;
  logic preset_n;
  logic hw_ctl;

  apb_interface apb_if (
    .pclk(pclk), 
    .preset_n(preset_n)
  );

  apb_slave apb_slave (
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

  initial begin
    pclk <= 0;
    #10ns;
    forever #5ns pclk = ~pclk;
  end

  initial begin
    preset_n <= 1;
    repeat (2) @ (negedge pclk);
    preset_n <= 0;
    @ (negedge pclk);
    preset_n <= 1;
    #100ns $finish;
  end

  initial begin
    $fsdbDumpfile("waves.fsdb");
    $fsdbDumpvars("+fsdbfile+waves.fsdb");
    $fsdbDumpSVA("+fsdbfile+waves.fsdb"); // Dump SVA
    $fsdbDumpMDA("+fsdbfile+waves.fsdb"); // Dump multi-dimensional array
  end

endmodule