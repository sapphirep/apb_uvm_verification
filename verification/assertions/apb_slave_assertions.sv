module apb_slave_assertions
#(
  parameter  ADDR_WIDTH = 16,
  parameter  DATA_WIDTH = 32,
  localparam STRB_WIDTH = DATA_WIDTH / 8
) (
  input logic                  pclk,
  input logic                  preset_n,
  input logic [ADDR_WIDTH-1:0] paddr,
  input logic                  psel,
  input logic                  penable,
  input logic                  pwrite,
  input logic [DATA_WIDTH-1:0] pwdata,
  input logic [STRB_WIDTH-1:0] pstrb,
  input logic                  pready,
  input logic [DATA_WIDTH-1:0] prdata,
  input logic                  pslverr 
);

  property valid_signal(signal);
    @ (posedge pclk) disable iff (!preset_n) !$isunknown(signal);
  endproperty

  property valid_control_signal(condition, signal);
    @ (posedge pclk) disable iff (!preset_n) 
      condition |-> !$isunknown(signal);
  endproperty

  // ============== See APB Signal Validity Rules (Spec A.1) ==============

  // PSEL should always be valid
  aPSelVld:  assert property(valid_signal(psel)) else $error("PSEL is X/Z!");

  // PADDR, PENABLE, PWRITE, PSTRB, PWDATA (for active write data lanes) should be valid when PSEL = 1
  aPAddrVld:   assert property(valid_control_signal(psel, paddr))  else $error("PADDR contains X/Z when PSEL=1!");
  aPEnableVld: assert property(valid_control_signal(psel, penable))  else $error("PENABLE is X/Z when PSEL=1!");
  aPWriteVld:  assert property(valid_control_signal(psel, pwrite)) else $error("PWRITE is X/Z when PSEL=1!");
  aPStrbVld:   assert property(valid_control_signal((psel && pwrite), pstrb)) else $error("PSTRB contains X/Z when PSEL=1!");

  genvar i;
  generate
    for (i = 0; i < STRB_WIDTH; i++) begin: gen_pwrite_valid
      pWrdataVld: assert property(valid_control_signal((psel && pwrite && pstrb[i]), pwdata[i*8 +: 8])) else $error("PWDATA byte lane %0d contains X/Z when PSEL=1!", i);
    end
  endgenerate

  // PREADY should be valid when PSEL = 1 and PENABLE = 1
  aPReadyVld: assert property(valid_control_signal((psel && psenable), pready) else $error("PREADY is X/Z when PSEL=1 and PENABLE=1!");
endmodule: apb_slave_assertions