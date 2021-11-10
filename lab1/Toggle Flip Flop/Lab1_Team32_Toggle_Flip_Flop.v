`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;

wire qbar, tbar, w1, w2, w3, w4;
not not0(qbar, q), not1(tbar, t);
and and0(w1, q, tbar), and1(w2, qbar, t);
or or0(w3, w1, w2);
and and2(w4, w3, rst_n);

DFF dff0(w4, clk, q);

endmodule

module DFF(d, clk, q);
input d, clk;
output q;
wire tmp, cbar;
not not0(cbar, clk);
DLatch dl0(d, cbar, tmp);
DLatch dl1(tmp, clk, q);
endmodule

module DLatch(d, e, q);
input d, e;
output q;

wire w1, w2, w3, w4, dbar;
wire w5;
not not0(dbar, d);
nand nand0(w1, d, e);
nand nand1(w2, dbar, e);
nand nand2(w3, w4, w1);
nand nand3(w4, w2, w3);

not not1(w5, w3);
not not2(q, w5);
endmodule