`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, sum, cin, cout);
input [3:0] a, b;
input cin;
output [3:0] sum;
output cout;

wire rs0_neg;
wire [2:0] c;

Full_Adder m2(.a(a[0]), .b(1'b0), .cin(cin), .cout(c[0]), .sum(sum[0]));
Full_Adder m3(.a(a[1]), .b(b[1]), .cin(c[0]), .cout(c[1]), .sum(sum[1]));
Full_Adder m4(.a(a[2]), .b(b[2]), .cin(c[1]), .cout(c[2]), .sum(sum[2]));
Full_Adder m5(.a(a[3]), .b(b[3]), .cin(c[2]), .cout(cout), .sum(sum[3]));

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

module AND(a, b, f);
input a,b;
output f;

wire w0;

nand nand1(w0, a, b);
nand nand2(f, w0, w0);

endmodule

module OR(a, b, f);
input a,b;
output f;

wire w0, w1;

NOT n0(a, w0);
NOT n1(b, w1);
nand n2(f, w0, w1);

endmodule

module NOT(a, f);
input a;
output f;

nand n0(f, a, a);

endmodule

module NOR(a, b, f);
input a, b;
output f;

wire w0;

OR m0(a, b, w0);
NOT m1(w0, f);

endmodule

module XOR(a, b, f);
input a,b;
output f;

wire a_neg, b_neg, w0, w1;

NOT m0(a, a_neg);
NOT m1(b, b_neg);
AND m2(a, b_neg, w0);
AND m3(a_neg, b, w1);
OR m4(w0, w1, f);

endmodule

module XNOR(a, b, f);
input a,b;
output f;

wire a_neg, b_neg, w0, w1;

NOT m0(a, a_neg);
NOT m1(b, b_neg);
AND m2(a_neg, b_neg, w0);
AND m3(a, b, w1);
OR m4(w0, w1, f);

endmodule
