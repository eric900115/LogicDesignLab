`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;

wire w1, w2, w3, w4, q_neg, t_neg;

not not0(q_neg, q);
not not1(t_neg, t);

and and0(w1, q, t_neg);
and and1(w2, t, q_neg);
or or0(w3, w1, w2);

and and2(w4, w3,rst_n);

D_Flip_Flop DFF(.clk(clk), .d(w4), .q(q));


endmodule

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;

wire neg_clk,w;

not n0(neg_clk, clk);

D_Latch D0(neg_clk, d, w);
D_Latch D1(clk, w, q);

endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;

wire neg_d, w1, w2, w3, w4, w5;

not n0(neg_d, d);

nand a0(w1, e, d);
nand a1(w2, e, neg_d);

nand o0(w3, w1, w4); 
nand o1(w4, w2, w3);

not n1(w5, w3);
not n2(q, w5);

endmodule