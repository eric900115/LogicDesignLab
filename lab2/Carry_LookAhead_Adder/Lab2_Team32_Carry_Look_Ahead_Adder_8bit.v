`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, sum, c8);
input [7:0] a, b;
input c0;
output [7:0] sum;
output c8;

wire c4;
wire [1:0] pg, gg;

CLA_4 cla0(a[3:0], b[3:0], c0, c4, sum[3:0], pg[0], gg[0]);
CLA_4 cla1(a[7:4], b[7:4], c4, c8, sum[7:4], pg[1], gg[1]);

CLA_2bits cla_2bits({c8, c4}, pg, gg, c0);

endmodule

module CLA_4(a, b, cin, cout, sum, pg, gg);

input [3:0] a, b;
input cin;
output [3:0]sum;
output cout, pg, gg;

wire [3:0] p, g;
wire [2:0] c;

Full_Adder fa0(sum[0], a[0], b[0], cin);
Full_Adder fa1(sum[1], a[1], b[1], c[0]);
Full_Adder fa2(sum[2], a[2], b[2], c[1]);
Full_Adder fa3(sum[3], a[3], b[3], c[2]);

OR aORb[3:0](a, b, p);
AND aANDb[3:0](a, b, g);

CLA_4bits cla2({cout, c[2:0]}, p, g, cin, pg, gg);

endmodule

module CLA_4bits(cout, p, g, cin, pg, gg);
input [3:0] p, g;
input cin;
output [3:0] cout;
output pg, gg;

wire [18:0]w;

//c1
AND and_c1(p[0], cin, w[0]);
OR or_c1(g[0], w[0], cout[0]);

//c2
AND and_c2(p[1], g[0], w[2]);
AND_4bits and_c21(p[1], p[0], cin, 1'b1, w[3]);
OR_4bits or_c2(g[1], w[2], w[3], 1'b0, cout[1]);

//c3
AND and_c3(p[2], g[1], w[4]);
AND_4bits and_c4(p[2], p[1], g[0], 1'b1, w[5]);
AND_4bits and_c5(p[2], p[1], p[0], cin, w[6]);
OR_4bits or_c3(g[2], w[4], w[5], w[6], cout[2]);

//c4
AND and_c40(p[3], g[2], w[7]);
AND_4bits and_c41(p[3], p[2], g[1], 1'b1, w[8]);
AND_4bits and_c42(p[3], p[2], p[1], g[0], w[9]);
AND_4bits and_c43(p[3], p[2], p[1], p[0], w[10]);
AND and_c44(w[10], cin, w[11]);
OR_4bits or_c4(w[7], w[8], w[9], w[11], w[12]);
OR or_c41(w[12], g[3], cout[3]);

//pg
AND_4bits and_pg(p[0], p[1], p[2], p[3], pg);

//gg
AND_4bits and_gg(g[1], p[3], p[2], 1'b1, w[14]);
AND_4bits and_gg1(g[0], p[3], p[2], p[1], w[15]);
AND and_gg2(g[2], p[3], w[16]);
OR_4bits or_gg(g[3], w[14], w[15], w[16], gg);

endmodule

module Full_Adder(sum, a, b, cin);
input a, b, cin;
output sum;

wire a_xor_b, w1, w2, w3, w4;

XOR xor_a_b(a, b, a_xor_b);
XOR xor_a_b_cin(a_xor_b, cin, sum);

endmodule

module CLA_2bits(cout, pg, gg, cin);
input [1:0] pg, gg;
input cin;
//cout[0] == c4, cout[1] == c8
output [1:0] cout;
wire [5:0]w;

AND and_c1(cin, pg[0], w[0]);
OR or_c1(gg[0], w[0], cout[0]);

AND and_c2(pg[1], gg[0], w[1]);
AND_4bits and_c21(pg[1], pg[0], cin, 1'b1, w[2]);
OR_4bits or_c2(gg[1], w[1], w[2], 1'b0, cout[1]);

endmodule

module AND_4bits(a, b, c, d, out);
input a, b, c, d;
output out;

wire w0, w1;

AND and0(a, b, w0);
AND and1(c, d, w1);
AND and2(w0, w1, out);

endmodule

module OR_4bits(a, b, c, d, out);
input a, b, c, d;
output out;

wire w0, w1;

OR and0(a, b, w0);
OR and1(c, d, w1);
OR and2(w0, w1, out);

endmodule

module AND(a, b, out);
input a, b;
output out;

wire a_nand_b;

nand nand_a_b(a_nand_b, a, b);
NOT and_a_b(a_nand_b, out);

endmodule

module OR(a, b, f);
input a,b;
output f;

wire a_neg, b_neg;

NOT not_a(a, a_neg);
NOT not_b(b, b_neg);
nand nand_a_b(f, a_neg, b_neg);

endmodule

module NOT(in, out);
input in;
output out;

nand not_in(out, in, in);

endmodule

module XOR(a, b, out);
input a, b;
output out;

wire a_neg, b_neg, w0, w1;

NOT not_a(a, a_neg);
NOT not_b(b, b_neg);

AND and_a_negb(a, b_neg, w0);
AND and_nega_b(a_neg, b, w1);

OR xor_a_b(w0, w1, out);

endmodule