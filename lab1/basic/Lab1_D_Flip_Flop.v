`timescale 1ns/1ps

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;

wire neg_clk,tmp;

not n0(neg_clk, clk);

D_Latch D0(neg_clk, d, tmp);
D_Latch D1(clk, tmp, q);

endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;

wire neg_d,tmp1,tmp2,tmp3,tmp4,tmp5;

not n0(neg_d, d);

nand a0(tmp1, e, d);
nand a1(tmp2, e, neg_d);

nand o0(tmp3,tmp1,tmp4); 
nand o1(tmp4,tmp2,tmp3);

not n1(tmp5, tmp3);
not n2(q, tmp5);

endmodule