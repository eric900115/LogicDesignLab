`timescale 1ns/1ps

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;

XOR sum_ab(sum, a, b);
AND cout_ab(cout, a, b);

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire w0, w1, w2, w3, w4, c_neg;

NOT not_cin(c_neg, cin);

Majority majority_a_b_cin(a, b, cin, w0);
Majority majority_a_b_negc(a, b, c_neg, w1);

NOT not_w0(w2, w0);
NOT not_w2(cout, w2);

Majority majority_w2_cin_w1(w2, cin, w1, sum);

endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;

wire w0, w1, w2, w3;

AND and_a_b(w0, a, b);
AND and_a_c(w1, a, c);
AND and_b_c(w2, b, c);
OR or_w0_w1(w3, w0, w1);
OR or_w2_w3(out, w2, w3);

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
nand nand_nega_negb(f, w0, w1);

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
