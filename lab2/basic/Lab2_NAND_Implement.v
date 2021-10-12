`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [2:0] sel;
output out;

wire I0, I1, I2, I3, I4, I5, I6, I7;
wire w0, w1, w2, w3, w4, w5;

nand nand_a_b(I0, a, b);
AND and_a_b(I1, a, b);
OR or_a_b(I2, a, b);
NOR nor_a_b(I3, a, b);
XOR xor_a_b(I4, a, b);
XNOR xnor_a_b(I5, a, b);
NOT not_a(I6, a);
NOT not_a(I7, a);

//implement 8-to-1 mux by using 7 2-to-1 mux
Mux mux0(I0, I1, sel[0], w0);
Mux mux1(I2, I3, sel[0], w1);
Mux mux2(I4, I5, sel[0], w2);
Mux mux3(I6, I7, sel[0], w3);
Mux mux4(w0, w1, sel[1], w4);
Mux mux5(w2, w3, sel[1], w5);
Mux mux6(w4, w5, sel[2], out);

endmodule

module AND(f, a, b);
input a,b;
output f;

wire w0;

nand nand_a_b(w0, a, b);
nand not_w0(f, w0, w0);

endmodule

module OR(f, a, b);
input a,b;
output f;

wire w0, w1;

NOT not_a(w0, a);
NOT not_b(w1, b);
nand nand_w0_w1(f, w0, w1);

endmodule

module NOT(f, a);
input a;
output f;

nand not_a(f, a, a);

endmodule

module NOR(f, a, b);
input a, b;
output f;

wire w0;

OR or_a_b(w0, a, b);
NOT not_w0(f, w0);

endmodule

module XOR(f, a, b);
input a,b;
output f;

wire a_neg, b_neg, w0, w1;

NOT not_a(a_neg, a);
NOT not_b(b_neg, b);
AND and_a_negb(w0, a, b_neg);
AND and_nega_b(w1, a_neg, b);
OR or_w0_w1(f, w0, w1);

endmodule

module XNOR(f, a, b);
input a,b;
output f;

wire a_neg, b_neg, w0, w1;

NOT not_a(a_neg, a);
NOT not_b(b_neg, b);
AND and_nega_negb(w0, a_neg, b_neg);
AND and_a_b(w1, a, b);
OR or_w0_w1(f, w0, w1);

endmodule

module Mux(x, y, sel, f);
input x, y;
input sel;
output f;

wire neg_sel;
wire tmp_x, tmp_y;

NOT not_nel(neg_sel, sel);

AND and_x_negsel(tmp_x, x, neg_sel);
AND and_y_sel(tmp_y, y, sel);

OR or_tmpx_tmpy(f, tmp_x, tmp_y);

endmodule