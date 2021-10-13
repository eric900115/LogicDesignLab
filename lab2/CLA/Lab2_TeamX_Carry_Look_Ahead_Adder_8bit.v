`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;

wire c4;
wire [1:0] pg, gg;

CLA_4 cla0(a[3:0], b[3:0], c0, c4, s[3:0], pg[0], gg[0]);
CLA_4 cla1(a[7:4], b[7:4], c4, c8, s[7:4], pg[1], gg[1]);

CLA_2bits cla_2bits({c8, c4}, pg, gg, c0);

endmodule

module CLA_4(a, b, cin, cout, sum, pg, gg);

parameter SIZE = 4;
input [SIZE-1:0] a, b;
input cin;
output [SIZE-1:0]sum;
output cout, pg, gg;

wire [SIZE-1:0] p, g;
wire [SIZE-1-1:0] c;

Full_Adder fa0(sum[0], a[0], b[0], cin);
Full_Adder fa1(sum[1], a[1], b[1], c[0]);
Full_Adder fa2(sum[2], a[2], b[2], c[1]);
Full_Adder fa3(sum[3], a[3], b[3], c[2]);

OR aORb[3:0](a, b, p);
AND aANDb[3:0](a, b, g);

CLA_4bits cla2({cout, c[2:0]}, p, g, cin, pg, gg);

endmodule

module CLA_2bits(cout, pg, gg, cin);
parameter SIZE = 2;

input [SIZE-1:0] pg, gg;
input cin;
//cout[0] == c4, cout[1] == c8
output [SIZE-1:0] cout;

// c4 = c0 * (pg[0,3] + gg[0,3])
wire pg_or_gg0, pg_or_gg1;
OR or_pg_gg0(pg[0], gg[0], pg_or_gg0);
AND and_c0_pggg(pg_or_gg0, cin, cout[0]);
// c8 = c4 * (pg[4,7] + gg[4,7])
OR or_pg_gg4(pg[1], gg[1], pg_or_gg1);
AND and_pg_gg4(pg_or_gg1, cout[0], cout[1]);

endmodule

module CLA_4bits(cout, p, g, cin, pg, gg);
parameter SIZE = 4;

input [SIZE-1:0] p, g;
input cin;
output [SIZE-1:0] cout;
output pg, gg;

wire [20:0] w;
wire [SIZE-1:0] gbar;

NOT ng[SIZE-1:0](g, gbar);

// c1 = g0 + (p0 * c0)
AND pANDc0(p[0], cin, w[0]);
OR gorw0(g[0], w[0], cout[0]);

// c2 = g1 + (p1 * c1)
//    = g1 + (g0 * p1) + (c0 * p0 * p1)
//    = !(!g1 * !(g0 * p1) * !(c0 * p0 * p1))
assign cout[2] = g[1] | (g[0] & p[1]) | (cin & p[0] & p[1]);

/*AND and_g0_p1(g[0], p[1], w[1]);
AND and1(cin, p[0], w[2]);
AND and2(w[2], p[1], w[3]);
OR or0(g[1], w[1], w[4]);
OR or1(w[4], w[3], cout[1]);*/
/*nand c2_0 (w[1], g[0], p[1]);
nand c2_1 (w[2], cin, p[0], p[1]);
nand c2_3 (cout[1], gbar[1], w[1], w[2]);
*/
// c3 = g2 + (p2 * c2)
//    = g2 + (g1 * p2) + (g0 * p1 * p2) + (c0 * p0 * p1 * p2)
//    = !(!g2 * !(g1 * p2) * !(g0 * p1 * p2) * !(c0 * p0 * p1 * p2))
assign cout[3] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (cin & p[0] & p[1] & p[2]);
/*AND and3(g[1], p[2], w[5]);//
AND and4(g[0], p[1], w[6]);
AND and5(w[6], p[2], w[7]);//
AND and6(cin, p[0], w[8]);
AND and7(w[8], p[1], w[9]);
AND and8(w[9], p[2], w[10]);//
OR or2(g[2], w[5], w[11]);
OR or3(w[11], w[7], w[12]);
OR or4(w[12], w[10], cout[2]);*/
/*nand c3_0 (w[3], g[1], p[2]);
nand c3_1 (w[4], g[0], p[1], p[2]);
nand c3_2 (w[5], cin, p[0], p[1], p[2]);
nand c3_3 (cout[2], gbar[2], w[3], w[4], w[5]);
*/
// c4 = g3 + (p3 * c3)
//    = g3 + (g2 * p3) + (g1 * p3 * p2) + (g0 * p3 * p2 * p1) + (cin * p3 * p2 * p1 * p0)
//    = !(!g3 * !(g2 * p3) * !(g1 * p3 * p2) * !(g0 * p3 * p2 * p1) * !(cin * p3 * p2 * p1 * p0))
assign cout[4] = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]) + (cin & p[3] & p[2] & p[1] & p[0]);
/*and and9(w[14], g[2], p[3]);
and and10(w[15], g[1], p[3], p[2]);
and and11(w[16], cin, p[3], p[2], p[1], p[0]);
or or5(cout[3], w[14], w[15], w[16]);*/
/*nand c4_0 (w[6], g[2], p[3]);
nand c4_1 (w[7], g[1], p[3], p[2]);
nand c4_2 (w[8], g[0], p[3], p[2], p[1]);
nand c4_3 (w[9], cin, p[3], p[2], p[1], p[0]);
nand c4_4 (cout[3], gbar[3], w[6], w[7], w[8], w[9]);
*/
// pg = p0 * p1 * p2 * p3
wire p0_and_p1, p2_and_p3;
AND and_p0_p1(p[0], p[1], p0_and_p1);
AND and_p2_p3(p[2], p[3], p2_and_p3);
AND and_p0p1_p2p3(p0_and_p1, p2_and_p3, pg);

wire [3:0] wgp;
// gg = g3 + g2 * p3 + g1 * p3 * p2 + g0 * p3 * p2 * p1
//    = !(!g3 * !(g2 * p3) * !(g1 *p3 * p2) * !(g0 * p3 *p2 * p1))
nand nand_gg_0(wgp[2], g[2], p[3]);
nand nand_gg_1(wgp[1], g[1], p[3], p[2]);
nand nand_gg_2(wgp[0], g[0], p[3], p[2], p[1]);
nand nand_gg(gg, gbar[3], wgp[2], wgp[1], wgp[0]);

endmodule

module Full_Adder (sum, a, b, cin);
input a, b, cin;
output sum;
 
wire w0, abnand, acnand, bcnand;
 
//OR aORb(a, b, p);
//AND aANDb(a, b, g);

XOR xor0(a, b, w0);
XOR xor1(w0, cin, sum);

/*nand nandab(abnand, a, b);
nand nandac(acnand, a, cin);
nand nandbc(bcnand, b, cin);
nand nandall(cout, abnand, acnand, bcnand);*/

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
