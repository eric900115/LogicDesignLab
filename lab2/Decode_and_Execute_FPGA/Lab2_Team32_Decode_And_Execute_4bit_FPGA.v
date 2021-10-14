`timescale 1ns/1ps

module FPGA_Display (SW, control, seg);
input [10:0] SW;
output [3:0] control;
output [7:0] seg;

wire [3:0] rd;
reg [7:0] seg;

assign control = 4'b1110;

Decode_And_Execute d0(SW[6:3], SW[10:7], SW[2:0], rd);

always @(*) begin

    case (rd)
        4'h0: seg = 8'b00000011;
        4'h1: seg = 8'b10011111;
        4'h2: seg = 8'b00100101;
        4'h3: seg = 8'b00001101;
        4'h4: seg = 8'b10011001;
        4'h5: seg = 8'b01001001;
        4'h6: seg = 8'b01000001;
        4'h7: seg = 8'b00011111;
        4'h8: seg = 8'b00000001;
        4'h9: seg = 8'b00001001;
        4'hA: seg = 8'b00010001;
        4'hB: seg = 8'b11000001;
        4'hC: seg = 8'b01100011;
        4'hD: seg = 8'b10000101;
        4'hE: seg = 8'b01100001;
        default : seg = 8'b01110001;
    endcase

end

endmodule


module Decode_And_Execute(rs, rt, sel, rd);
input [3:0] rs, rt;
input [2:0] sel;
output [3:0] rd;

wire [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
wire [3:0] w0, w1, w2, w3, w4, w5;

ADD m0(rs, rt, I0);
SUB m1(rs, rt, I1);
Bitwise_AND m2(rs, rt, I2);
Bitwise_OR m3(rs, rt, I3);
rs_L_shift m4(rs, I4);
rt_R_shift m5(rt, I5);
Equality m6(rs, rt, I6);
Grater_than m7(rs, rt, I7);

Mux mux0[3:0](I0, I1, sel[0], w0);
Mux mux1[3:0](I2, I3, sel[0], w1);
Mux mux2[3:0](I4, I5, sel[0], w2);
Mux mux3[3:0](I6, I7, sel[0], w3);
Mux mux4[3:0](w0, w1, sel[1], w4);
Mux mux5[3:0](w2, w3, sel[1], w5);
Mux mux6[3:0](w4, w5, sel[2], rd);

endmodule


module ADD(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

Adder m0(.rs(rs), .rt(rt), .rd(rd));

endmodule

module SUB(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

Substractor m0(.rs(rs), .rt(rt), .rd(rd));

endmodule

module Bitwise_AND(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

AND bitwise_and[3:0](rs, rt, rd);

endmodule

module Bitwise_OR(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

OR bitwise_or[3:0](rs, rt, rd);

endmodule

module rs_L_shift(rs, rd);
input [3:0] rs;
output [3:0] rd;

wire [3:0] rs_neg;

NOT m0[3:0](rs, rs_neg);

NOT m1(rs_neg[2], rd[3]);
NOT m2(rs_neg[1], rd[2]);
NOT m3(rs_neg[0], rd[1]);
NOT m4(rs_neg[3], rd[0]);

endmodule

module rt_R_shift(rt, rd);
input [3:0] rt;
output [3:0] rd;

wire [3:0] rt_neg;

NOT m0[3:0](rt, rt_neg);

NOT m1(rt_neg[3], rd[3]);
NOT m2(rt_neg[3], rd[2]);
NOT m3(rt_neg[2], rd[1]);
NOT m4(rt_neg[1], rd[0]);


endmodule

module Equality(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire w0, w1, w2, w3, w4, w5;
wire rs0_neg;

XNOR m0(rs[0], rt[0], w0);
XNOR m1(rs[1], rt[1], w1);
XNOR m2(rs[2], rt[2], w2);
XNOR m3(rs[3], rt[3], w3);

AND m4(w0, w1, w4);
AND m5(w4, w2, w5);
AND m6(w5, w3, rd[0]);

NOT m7(rs[0], rs0_neg);
OR m8(rs[0], rs0_neg, rd[1]);
OR m9(rs[0], rs0_neg, rd[2]);
OR m10(rs[0], rs0_neg, rd[3]);

endmodule

module Equality_1bit(rs, rt, rd);
input rs, rt;
output rd;

XNOR m0(rs, rt, rd);

endmodule

module Grater_than(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire rs0_neg;
wire w0, w1, w2, w3, w4, w5, w6, w7;
wire w8, w9, w10, w11, w12, w13, w14, w15;
wire w16, w17, w18;
wire zero, one;

NOT m0(rs[0], rs0_neg);
AND m1(rs[0], rs0_neg, zero);
OR m2(rs[0], rs0_neg, one);

//rs[3] > rt[3]
Grater_than_1bit m5(rs[3], rt[3], w0);

//rs[3] == rt[3] rs[2] > rt[2]
Equality_1bit m7(rs[3], rt[3], w1);
Grater_than_1bit m8(rs[2], rt[2], w2);
AND m9(w1, w2, w3);

//rs[3] == rt[3] rs[2] == rt[2] rs[1] > rt[1]
Equality_1bit m10(rs[3], rt[3], w4);
Equality_1bit m11(rs[2], rt[2], w5);
Grater_than_1bit m12(rs[1], rt[1], w6);
AND m13(w4, w5, w7);
AND m14(w7, w6, w8);

//rs[3] == rt[3] rs[2] == rt[2] rs[1] > rt[1]
Equality_1bit m15(rs[3], rt[3], w9);
Equality_1bit m16(rs[2], rt[2], w10);
Equality_1bit m17(rs[1], rt[1], w11);
Grater_than_1bit m18(rs[0], rt[0], w12);
AND m19(w9, w10, w13);
AND m20(w11, w13, w14);
AND m21(w12, w14, w15);

OR OR0(w0, w3, w16);
OR OR1(w16, w8, w17);
OR OR2(w17, w15, rd[0]);

NOT NOT0(zero, rd[3]);
NOT NOT1(one, rd[2]);
NOT NOT2(zero, rd[1]);

endmodule

module Grater_than_1bit (a, b, out);
input a, b;
output out;

//out == 1 when a == 1 and b == 0
wire b_neg;

NOT m0(b, b_neg);
AND m1(a, b_neg, out);

endmodule

module Adder(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire zero, rs0_neg;

NOT m0(rs[0], rs0_neg);
AND m1(rs[0], rs0_neg, zero);

Ripple_Carry_Adder m3(.rs(rs), .rt(rt), .rd(rd), .cin(zero));

endmodule


module Substractor(rs, rt, rd);
input [3:0] rs, rt;
output [3:0] rd;

wire one, rs0_neg;
wire [3:0] rt_neg;

NOT m0(rs[0], rs0_neg);
OR m1(rs[0], rs0_neg, one);

//1's complement of rt
NOT m2[3:0](rt, rt_neg);

Ripple_Carry_Adder m3(.rs(rs), .rt(rt_neg), .rd(rd), .cin(one));

endmodule


module Ripple_Carry_Adder(rs, rt, rd, cin);
input [3:0] rs, rt;
input cin;
output [3:0] rd;

wire rs0_neg;
wire [3:0] c;

Full_Adder m2(.a(rs[0]), .b(rt[0]), .cin(cin), .cout(c[0]), .sum(rd[0]));
Full_Adder m3(.a(rs[1]), .b(rt[1]), .cin(c[0]), .cout(c[1]), .sum(rd[1]));
Full_Adder m4(.a(rs[2]), .b(rt[2]), .cin(c[1]), .cout(c[2]), .sum(rd[2]));
Full_Adder m5(.a(rs[3]), .b(rt[3]), .cin(c[2]), .cout(c[3]), .sum(rd[3]));

endmodule

module Full_Adder(a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire w0, w1, w2, w3, w4;

XOR m0(a, b, w0);
XOR m1(w0, cin, sum);

AND m2(a, b, w1);
AND m3(a, cin, w2);
AND m4(b, cin, w3);
OR m5(w1, w2, w4);
OR m6(w3, w4, cout);

endmodule

module Mux(a, b, sel, f);
input a, b;
input sel;
output f;

wire neg_sel;
wire tmp_a, tmp_b;

NOT n0(sel, neg_sel);

AND and0(a, neg_sel, tmp_a);
AND and1(b, sel, tmp_b);

OR or0(tmp_a, tmp_b, f);

endmodule

module AND(a, b, out);
input a, b;
output out;

wire b_neg;

NOT m0(b, b_neg);
Universal_Gate m1(a, b_neg, out);

endmodule


module OR(a, b, out);
input a, b;
output out;

wire a_neg, w0;

NOT m0(a, a_neg);
Universal_Gate m1(a_neg, b, w0);
NOT m2(w0, out);

endmodule

module XOR(a, b, out);
input a, b;
output out;

wire a_neg, b_neg, w0, w1;

NOT m0(a, a_neg);
NOT m1(b, b_neg);

AND m2(a, b_neg, w0);
AND m3(a_neg, b, w1);

OR m4(w0, w1, out);

endmodule

module NAND(a, b, out);
input a, b;
output out;

wire w0;

AND m0(a, b, w0);
NOT m1(w0, out);

endmodule

module NOR(a, b, out);
input a, b;
output out;

wire w0;

OR m0(a, b, w0);
NOT m1(w0, out);

endmodule

module XNOR(a, b, out);
input a, b;
output out;

wire a_neg, b_neg, w0, w1;

NOT m0(a, a_neg);
NOT m1(b, b_neg);

AND m2(a_neg, b_neg, w0);
AND m3(a, b, w1);

OR m4(w0, w1, out);

endmodule

module NOT(a, out);
input a;
output out;

Universal_Gate m0(1'b1, a, out);

endmodule
