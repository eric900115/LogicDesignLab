`timescale 1ns/1ps

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [3:0] in;
input [1:0] sel;
output [3:0] a, b, c, d;

//Dmux_1x4_1bit dmux0[3:0](in, a, b, c, d, sel);

wire [3:0] tmp_dmux0, tmp_dmux1;

Dmux_1x2_1bit dmux0[3:0](.in(in), .a(tmp_dmux0), .b(tmp_dmux1), .sel(sel[1])) ;
Dmux_1x2_1bit dmux1[3:0](.in(tmp_dmux0), .a(a), .b(b), .sel(sel[0])) ;
Dmux_1x2_1bit dmux2[3:0](.in(tmp_dmux1), .a(c), .b(d), .sel(sel[0])) ;

endmodule

module Dmux_1x2_1bit(in, a, b, sel);
input in;
input sel;
output a,b;

wire sel_neg;

not not0(sel_neg, sel);

and and0(a, sel_neg, in);
and and1(b, sel, in);

endmodule
/*
module Dmux_1x4_1bit(in, a, b, c, d, sel);
input in;
input [1:0]sel;
output a,b,c,d;

wire [1:0] sel_neg;

not not0(sel_neg[0], sel[0]);
not not1(sel_neg[1], sel[1]);

and and0(a, sel_neg[1], sel_neg[0], in);
and and1(b, sel_neg[1], sel[0], in);
and and2(c, sel[1], sel_neg[0], in);
and and3(d, sel[1], sel[0], in);

endmodule*/