`timescale 1ns/1ps

module Mux_4x1_4bit(a, b, c, d, sel, f);
input [3:0] a, b, c, d;
input [1:0] sel;
output [3:0] f;

wire [3:0]tmp_x,tmp_y;

Mux mux0[3:0](a, b, sel[0], tmp_x);
Mux mux1[3:0](c, d, sel[0], tmp_y);
Mux mux2[3:0](tmp_x, tmp_y, sel[1], f);

endmodule

module Mux(x, y, sel, f);
input x, y;
input sel;
output f;

wire neg_sel;
wire tmp_x, tmp_y;

not n0(neg_sel, sel);

and and0(tmp_x, x, neg_sel);
and and1(tmp_y, y, sel);

or or0(f, tmp_x, tmp_y);

endmodule
