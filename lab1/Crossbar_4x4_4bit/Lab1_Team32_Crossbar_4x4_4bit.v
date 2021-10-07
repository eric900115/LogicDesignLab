`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [3:0] in1, in2, in3, in4;
input [4:0] control;
output [3:0] out1, out2, out3, out4;

wire [3:0]w1, w2, w3, w4, w5, w6;

Crossbar_2x2_4bit c1(.in1(in1), .in2(in2), .control(control[0]), .out1(w1), .out2(w2));
Crossbar_2x2_4bit c2(.in1(in3), .in2(in4), .control(control[1]), .out1(w3), .out2(w6));
Crossbar_2x2_4bit c3(.in1(w2), .in2(w3), .control(control[2]), .out1(w4), .out2(w5));
Crossbar_2x2_4bit c4(.in1(w1), .in2(w4), .control(control[3]), .out1(out1), .out2(out2));
Crossbar_2x2_4bit c5(.in1(w5), .in2(w6), .control(control[4]), .out1(out3), .out2(out4));

endmodule


module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2;

wire [3:0] tmp1, tmp2, tmp3, tmp4;
wire control_neg;

not not0(control_neg, control); 

Dmux_1x2_1bit Dmux0[3:0](.in(in1), .a(tmp1), .b(tmp2), .sel(control_neg));
Dmux_1x2_1bit Dmux1[3:0](.in(in2), .a(tmp3), .b(tmp4), .sel(control));

Mux mux0[3:0](.x(tmp1), .y(tmp3), .sel(control_neg), .f(out1));
Mux mux1[3:0](.x(tmp2), .y(tmp4), .sel(control), .f(out2));

endmodule

module Mux(x, y, sel, f);
input x, y;
input sel;
output f;

wire neg_sel;
wire tmp_x, tmp_y;

not n0(neg_sel, sel);

and and0(tmp_x, x, neg_sel);
and and1(tmp_y, y, sel);

or or0(f, tmp_x, tmp_y);

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

