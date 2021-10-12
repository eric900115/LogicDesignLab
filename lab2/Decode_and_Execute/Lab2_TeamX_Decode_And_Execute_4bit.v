`timescale 1ns/1ps


module Decode_And_Execute(rs, rt, sel, rd);
input [3:0] rs, rt;
input [2:0] sel;
output [3:0] rd;

wire [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
wire [3:0] w0, w1, w2, w3, w4, w5;

ADD add(rs, rt, I0);
SUB sub(rs, rt, I1);
Bitwise_AND bit_and(rs, rt, I2);
Bitwise_OR bit_or(rs, rt, I3);
rs_L_shift l_shift(rs, I4);
rt_R_shift r_shift(rt, I5);
Equality equality(rs, rt, I6);
Grater_than grater_than(rs, rt, I7);

Mux mux0[3:0](I0, I1, sel[0], w0);
Mux mux1[3:0](I2, I3, sel[0], w1);
Mux mux2[3:0](I4, I5, sel[0], w2);
Mux mux3[3:0](I6, I7, sel[0], w3);
Mux mux4[3:0](w0, w1, sel[1], w4);
Mux mux5[3:0](w2, w3, sel[1], w5);
Mux mux6[3:0](w4, w5, sel[2], rd);

endmodule


module ADD(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

Adder add_rs_rt(.rs(rs), .rt(rt), .rd(rd));

endmodule

module SUB(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

Substractor sub_rs_rt(.rs(rs), .rt(rt), .rd(rd));

endmodule

module Bitwise_AND(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

AND bitwise_and[3:0](rs, rt, rd);

endmodule

module Bitwise_OR(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

OR bitwise_or[3:0](rs, rt, rd);

endmodule

module rs_L_shift(rs, rd);
input [3:0] rs;
output [3:0] rd;

wire [3:0] rs_neg;

NOT not_rs[3:0](rs, rs_neg);

NOT not0(rs_neg[2], rd[3]);
NOT not1(rs_neg[1], rd[2]);
NOT not2(rs_neg[0], rd[1]);
NOT not3(rs_neg[3], rd[0]);

endmodule

module rt_R_shift(rt, rd);
input [3:0] rt;
output [3:0] rd;

wire [3:0] rt_neg;

NOT not_rg[3:0](rt, rt_neg);

NOT not0(rt_neg[3], rd[3]);
NOT not1(rt_neg[3], rd[2]);
NOT not2(rt_neg[2], rd[1]);
NOT not3(rt_neg[1], rd[0]);


endmodule

module Equality(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire w0, w1;
wire rs0_neg;
wire equal_rs0_rt0, equal_rs1_rt1, equal_rs2_rt2, equal_rs3_rt3;

XNOR rs0_equal_rt0(rs[0], rt[0], equal_rs0_rt0);
XNOR rs1_equal_rt1(rs[1], rt[1], equal_rs1_rt1);
XNOR rs2_equal_rt2(rs[2], rt[2], equal_rs2_rt2);
XNOR rs3_equal_rt3(rs[3], rt[3], equal_rs3_rt3);

//combine 4 bits equality
AND and0(equal_rs0_rt0, equal_rs1_rt1, w0);
AND and1(w0, equal_rs2_rt2, w1);
AND and2(w1, equal_rs3_rt3, rd[0]);

//let rd[1] rd[2] rd[3] be one
NOT not_rs0(rs[0], rs0_neg);
OR rd0_One(rs[0], rs0_neg, rd[1]);
OR rd2_One(rs[0], rs0_neg, rd[2]);
OR rd3_One(rs[0], rs0_neg, rd[3]);

endmodule

module Equality_1bit(rs, rt, rd);
input rs, rt;
output rd;

XNOR equality_rs_rt(rs, rt, rd);

endmodule

module Grater_than(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire rs0_neg;
wire w0, w1, w2, w3, w4, w5, w6, w7;
wire w8, w9, w10, w11, w12, w13, w14, w15;
wire w16, w17, w18;
wire zero, one;
/*
NOT m0(rs[0], rs0_neg);
OR m1(rs[0], rs0_neg, rd[1]);
AND m2(rs[0], rs0_neg, rd[2]);
OR m3(rs[0], rs0_neg, rd[3]);
*/

NOT not_rs0(rs[0], rs0_neg);
AND Zero(rs[0], rs0_neg, zero);
OR One(rs[0], rs0_neg, one);

//rs[3] > rt[3]
Grater_than_1bit rs3_grater_rt3(rs[3], rt[3], w0);

//rs[3] == rt[3] rs[2] > rt[2]
Equality_1bit rs3_equal_rt3(rs[3], rt[3], w1);
Grater_than_1bit rs2_grater_rt2(rs[2], rt[2], w2);
AND m9(w1, w2, w3);

//rs[3] == rt[3] rs[2] == rt[2] rs[1] > rt[1]
Equality_1bit rs3_equal_rt3_2(rs[3], rt[3], w4);
Equality_1bit rs2_equal_rt2(rs[2], rt[2], w5);
Grater_than_1bit rs1_grater_rt1(rs[1], rt[1], w6);
AND m13(w4, w5, w7);
AND m14(w7, w6, w8);

//rs[3] == rt[3] rs[2] == rt[2] rs[1] > rt[1]
Equality_1bit rs3_equal_rt3_3(rs[3], rt[3], w9);
Equality_1bit rs2_equal_rt2_2(rs[2], rt[2], w10);
Equality_1bit rs1_equal_rt1(rs[1], rt[1], w11);
Grater_than_1bit rs0_grater_rt0(rs[0], rt[0], w12);
AND m19(w9, w10, w13);
AND m20(w11, w13, w14);
AND m21(w12, w14, w15);

OR OR0(w0, w3, w16);
OR OR1(w16, w8, w17);
OR OR2(w17, w15, rd[0]);

NOT rd3_zero(zero, rd[3]);
NOT rd2_one(one, rd[2]);
NOT rd1_zero(zero, rd[1]);

endmodule

module Grater_than_1bit (a, b, out);
input a, b;
output out;

//out == 1 when a == 1 and b == 0
wire b_neg;

NOT not_b(b, b_neg);
AND and_a_negb(a, b_neg, out);

endmodule

module Adder(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire zero, rs0_neg;

NOT not_rs0(rs[0], rs0_neg);
AND Zero(rs[0], rs0_neg, zero);

Ripple_Carry_Adder r_adder0(.rs(rs), .rt(rt), .rd(rd), .cin(zero));

endmodule


module Substractor(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire one, rs0_neg;
wire [3:0] rt_neg;

NOT not_rs0(rs[0], rs0_neg);
OR One(rs[0], rs0_neg, one);

//1's complement of rt
NOT rt_1complement[3:0](rt, rt_neg);

Ripple_Carry_Adder r_adder0(.rs(rs), .rt(rt_neg), .rd(rd), .cin(one));

endmodule


module Ripple_Carry_Adder(rs, rt, rd, cin);
input [3:0] rs, rt;
input cin;
output [3:0] rd;

wire rs0_neg;
wire [3:0] c;

Full_Adder fadder0(.a(rs[0]), .b(rt[0]), .cin(cin), .cout(c[0]), .sum(rd[0]));
Full_Adder fadder1(.a(rs[1]), .b(rt[1]), .cin(c[0]), .cout(c[1]), .sum(rd[1]));
Full_Adder fadder2(.a(rs[2]), .b(rt[2]), .cin(c[1]), .cout(c[2]), .sum(rd[2]));
Full_Adder fadder3(.a(rs[3]), .b(rt[3]), .cin(c[2]), .cout(c[3]), .sum(rd[3]));

endmodule

module Full_Adder(a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire a_xor_b, w1, w2, w3, w4;

XOR xor_a_b(a, b, a_xor_b);
XOR xor_a_b_cin(a_xor_b, cin, sum);

AND and_a_b(a, b, w1);
AND and_a_cin(a, cin, w2);
AND and_b_cin(b, cin, w3);
OR or0(w1, w2, w4);
OR or1(w3, w4, cout);

endmodule

module Mux(a, b, sel, f);
input a, b;
input sel;
output f;

wire neg_sel;
wire tmp_a, tmp_b;

NOT not_sel(sel, neg_sel);

AND and_a_negsel(a, neg_sel, tmp_a);
AND and_b_sel(b, sel, tmp_b);

OR or0(tmp_a, tmp_b, f);

endmodule

module AND(a, b, out);
input a, b;
output out;

wire b_neg;

NOT not_b(b, b_neg);
Universal_Gate and_a_b(a, b_neg, out);

endmodule


module OR(a, b, out);
input a, b;
output out;

wire a_neg, a_nor_b;

NOT not_a(a, a_neg);
Universal_Gate nor_a_b(a_neg, b, a_nor_b);
NOT or_a_b(a_nor_b, out);

endmodule

module XOR(a, b, out);
input a, b;
output out;

wire a_neg, b_neg, a_and_negb, nega_and_b;

NOT not_a(a, a_neg);
NOT not_b(b, b_neg);

AND and_a_negb(a, b_neg, a_and_negb);
AND and_nega_b(a_neg, b, nega_and_b);

OR xor_a_b(a_and_negb, nega_and_b, out);

endmodule

module NAND(a, b, out);
input a, b;
output out;

wire a_and_b;

AND and_a_b(a, b, a_and_b);
NOT nand_a_b(a_and_b, out);

endmodule

module NOR(a, b, out);
input a, b;
output out;

wire a_or_b;

OR or_a_b(a, b, a_or_b);
NOT nor_a_b(a_or_b, out);

endmodule

module XNOR(a, b, out);
input a, b;
output out;

wire a_neg, b_neg;
wire nega_and_negb, a_and_b;

NOT not_a(a, a_neg);
NOT not_b(b, b_neg);

AND and_nega_negb(a_neg, b_neg, nega_and_negb);
AND and_a_b(a, b, a_and_b);

OR xnor_a_b(nega_and_negb, a_and_b, out);

endmodule

module NOT(a, out);
input a;
output out;

Universal_Gate not_a(1'b1, a, out);

endmodule
