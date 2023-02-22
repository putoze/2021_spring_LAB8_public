/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : N-2017.09-SP2
// Date      : Wed Dec 22 12:18:58 2021
/////////////////////////////////////////////////////////////


module GATED_OR ( CLOCK, SLEEP_CTRL, RST_N, CLOCK_GATED );
  input CLOCK, SLEEP_CTRL, RST_N;
  output CLOCK_GATED;
  wire   latch_or_sleep;

  TLATSRX1 latch_or_sleep_reg ( .G(CLOCK), .D(SLEEP_CTRL), .RN(RST_N), .SN(
        1'b1), .Q(latch_or_sleep) );
  OR2X1 U5 ( .A(latch_or_sleep), .B(CLOCK), .Y(CLOCK_GATED) );
endmodule

