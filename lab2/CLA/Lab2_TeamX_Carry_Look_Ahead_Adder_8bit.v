`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;

wire c;

CLA cla0(a[3:0], b[3:0], c0, c, s[3:0]);
CLA cla1(a[4:7], b[4:7], c, c8, s[4:7]);



endmodule

module CLA(a, b, cin, cout, sum);

parameter SIZE = 4;
input [SIZE-1:0] a, b;
input cin;
output [SIZE-1:0]sum;
output cout;

wire [SIZE-1:0] p, g;
wire [SIZE-1-1:0] c;

Full_Adder fa0(sum[0], p[0], g[0], a[0], b[0], cin);
Full_Adder fa1(sum[1], p[1], g[1], a[1], b[1], c[0]);
Full_Adder fa2(sum[2], p[2], g[2], a[2], b[2], c[1]);
Full_Adder fa3(sum[3], p[3], g[3], a[3], b[3], c[2]);

CLA_4bits cla2({cout, c[2:0]}, p, g, cin);

endmodule

module CLA_2bits(cout, p, g, cin);
parameter SIZE = 2;

input [SIZE-1:0] p, g;
input cin;
output [SIZE-1:0] cout;

wire [5:0] w;
wire [SIZE-1:0] gbar;

NOT ng[SIZE-1:0](g, gbar);

// c4 = g3 + (p3 * c3)

endmodule

module CLA_4bits(cout, p, g, cin);
parameter SIZE = 4;

input [SIZE-1:0] p, g;
input cin;
output [SIZE-1:0] cout;

wire [9:0] w;
wire [SIZE-1:0] gbar;

NOT ng[SIZE-1:0](g, gbar);

// c1 = g0 + (p0 * c0)
AND pANDc0(p[0], cin, w[0]);
OR gorw0(g[0], w[0], cout[0]);

// c2 = g1 + (p1 * c1)
//    = g1 + (g0 * p1) + (c0 * p0 * p1)
//    = !(!g1 * !(g0 * p1) * !(c0 * p0 * p1))
nand c2_0 (w[1], g[0], p[1]);
nand c2_1 (w[2], cin, p[0], p[1]);
nand c2_3 (cout[1], gbar[1], w[1], w[2]);

// c3 = g2 + (p2 * c2)
//    = g2 + (g1 * p2) + (g0 * p1 * p2) + (c0 * p0 * p1 * p2)
//    = !(!g2 * !(g1 * p2) * !(g0 * p1 * p2) * !(c0 * p0 * p1 * p2))
nand c3_0 (w[3], g[1], p[2]);
nand c3_1 (w[4], g[0], p[2], p[1]);
nand c3_2 (w[5], cin, p[2], p[1], p[0]);
nand c3_3 (cout[1], gbar[2], w[3], w[4], w[5]);

// c4 = g3 + (p3 * c3)
//    = g3 + (g2 * p3) + (g1 * p3 * p2) + (g0 * p3 * p2 * p1) + (cin * p3 * p2 * p1 * p0)
//    = !(!g3 * !(g2 * p3) * !(g1 * p3 * p2) * !(g0 * p3 * p2 * p1) * !(cin * p3 * p2 * p1 * p0))
nand c4_0 (w[6], g[2], p[3]);
nand c4_1 (w[7], g[1], p[3], p[2]);
nand c4_2 (w[8], g[0], p[3], p[2], p[1]);
nand c4_3 (w[9], cin, p[3], p[2], p[1], p[0]);
nand c4_4 (cout[3], gbar[3], w[6], w[7], w[8], w[9]);

endmodule

module Full_Adder (sum, p, g, a, b, cin);
input a, b, cin;
output p, g, sum;

wire an, bn, cn;
wire abc, a_bn_cn, an_b_cn, an_bn_c;
 
OR aORb(a, b, p);
AND aANDb(a, b, g);

NOT na(a, an), nb(b, bn), nc(c, cn);

nand nabc(abc, a, b, cin);
nand abncn(a_bn_cn, a, bn, cn), anbcn(an_b_cn, an, b, cn), anbnc(an_bn_c, an, bn, cin);
nand sumcal(sum, abc, a_bn_cn, an_b_cn, an_bn_c);


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

module XNOR(a, b, f);
input a, b;
output f;
wire w0, w1, w2, w3;
nand nand0(w0, a, a), nand1(w1, b, b);
nand nand2(w2, w0, w1), nand3(w3, a, b);
nand nand4(f, w2, w3);
endmodule