`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;

wire [1:0] p1;
wire [2:0] p2;
wire [3:0] p3;
wire [2:0] p4;
wire [1:0] p5;
wire p6;

//wire [3:0] c0, c1, c2, c3, c4, c5, c6, c7, c8;
wire [2:0] c0, c1;
wire [2:0] carry;

wire neg_p1, neg_p2;

AND and_a0_b0(a[0], b[0], p[0]);

AND and_a1_b0(a[1], b[0], p1[0]);
AND and_a0_b1(a[0], b[1], p1[1]);

AND and_a2_b0(a[2], b[0], p2[0]);
AND and_a1_b1(a[1], b[1], p2[1]);
AND and_a0_b2(a[0], b[2], p2[2]);

AND and_a3_b0(a[3], b[0], p3[0]);
AND and_a2_b1(a[2], b[1], p3[1]);
AND and_a1_b2(a[1], b[2], p3[2]);
AND and_a0_b3(a[0], b[3], p3[3]);

AND and_a3_b1(a[3], b[1], p4[0]);
AND and_a2_b2(a[2], b[2], p4[1]);
AND and_a1_b3(a[1], b[3], p4[2]);

AND and_a3_b2(a[3], b[2], p5[0]);
AND and_a2_b3(a[2], b[3], p5[1]);

AND and_a3_b3(a[3], b[3], p6);


Ripple_Carry_Adder adder0(.rs({p4[0], p3[1], p2[1], p1[1]}), 
                          .rt({1'b0, p3[0], p2[0], p1[0]}), 
                          .rd({c0, p[1]}), 
                          .cin(1'b0), .cout(carry[0]));

Ripple_Carry_Adder adder1(.rs({carry[0], c0[2], c0[1], c0[0]}), 
                          .rt({p5[0], p4[1], p3[2], p2[2]}), 
                          .rd({c1, p[2]}), 
                          .cin(1'b0), .cout(carry[1]));

Ripple_Carry_Adder adder2(.rs({carry[1], c1[2], c1[1], c1[0]}), 
                          .rt({p6, p5[1], p4[2], p3[3]}), 
                          .rd({p[6], p[5], p[4], p[3]}), 
                          .cin(1'b0), .cout(p[7]));

endmodule

module Ripple_Carry_Adder(rs, rt, rd, cin, cout);
input [3:0] rs, rt;
input cin;
output [3:0] rd;
output cout;

wire rs0_neg;
wire [2:0] c;

Full_Adder f_adder0(.a(rs[0]), .b(rt[0]), .cin(cin), .cout(c[0]), .sum(rd[0]));
Full_Adder f_adder1(.a(rs[1]), .b(rt[1]), .cin(c[0]), .cout(c[1]), .sum(rd[1]));
Full_Adder f_adder2(.a(rs[2]), .b(rt[2]), .cin(c[1]), .cout(c[2]), .sum(rd[2]));
Full_Adder f_adder3(.a(rs[3]), .b(rt[3]), .cin(c[2]), .cout(cout), .sum(rd[3]));

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