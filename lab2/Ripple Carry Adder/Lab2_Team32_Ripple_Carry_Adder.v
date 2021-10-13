`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [7:0] a, b;
input cin;
output cout;
output [7:0] sum;

wire [6:0]c;

Full_Adder fa0(a[0], b[0], cin, c[0], sum[0]);
Full_Adder fa1(a[1], b[1], c[0], c[1], sum[1]);
Full_Adder fa2(a[2], b[2], c[1], c[2], sum[2]);
Full_Adder fa3(a[3], b[3], c[2], c[3], sum[3]);
Full_Adder fa4(a[4], b[4], c[3], c[4], sum[4]);
Full_Adder fa5(a[5], b[5], c[4], c[5], sum[5]);
Full_Adder fa6(a[6], b[6], c[5], c[6], sum[6]);
Full_Adder fa7(a[7], b[7], c[6], cout, sum[7]);

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire w0;
wire w1, w2, w3;
XOR xor0(a, b, w0);
XOR xor1(w0, cin, sum);
nand nand0(w1, a, b);
nand nand1(w2, a, cin);
nand nand2(w3, b, cin);
nand nand3(cout, w1, w2, w3);
 
endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;

wire w0, w1, w2, w3;

AND a0(a, b, w0), a1(a, c, w1), a2(b, c, w2);
OR o0(w0, w1, w3), o1(w3, w2, out);

endmodule

module AND(a, b, f);
input a, b;
output f;
wire w0;
nand nand0(w0, a, b), nand1(f, w0, w0);
endmodule

module OR(a, b, f);
input a, b;
output f;
wire w0, w1;
nand nand0(w0, a, a), nand1(w1, b, b), nand2(f, w0, w1);
endmodule

module NOT(a, f);
input a;
output f;
nand nand0(f, a, a);
endmodule

module XOR(a, b, f);
input a, b;
output f;
wire w0, w1, w2, w3;
nand nand0(w0, a, a), nand1(w1, b, b);
nand nand2(w2, w0, b), nand3(w3, a, w1);
nand nand4(f, w2, w3);
endmodule
