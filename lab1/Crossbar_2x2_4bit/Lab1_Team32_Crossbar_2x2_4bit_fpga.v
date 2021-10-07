`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2, out3, out4);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2, out3, out4;

wire [3:0] w1, w2, w3, w4, w5, w6;
wire control_neg;

not not0(control_neg, control); 

Dmux_1x2_1bit Dmux0[3:0](.in(in1), .a(w1), .b(w2), .sel(control_neg));
Dmux_1x2_1bit Dmux1[3:0](.in(in2), .a(w3), .b(w4), .sel(control));

Mux mux0[3:0](.a(w1), .b(w3), .sel(control_neg), .f(out1));
Mux mux1[3:0](.a(w2), .b(w4), .sel(control), .f(out2));

not not1[3:0](w5, out1);
not not2[3:0](out3, w5);

not not3[3:0](w6, out2);
not not4[3:0](out4, w6);

endmodule

module Mux(a, b, sel, f);
input a, b;
input sel;
output f;

wire neg_sel;
wire w0, w1;

not n0(neg_sel, sel);

and and0(w0, a, neg_sel);
and and1(w1, b, sel);

or or0(f, w0, w1);

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

