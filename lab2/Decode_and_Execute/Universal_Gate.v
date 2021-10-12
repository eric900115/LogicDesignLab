`timescale 1ns/1ps

module Universal_Gate(a, b, out);
input a, b;
output out;

wire b_neg;

not not0(b_neg, b);
and and0(out, a, b_neg);

endmodule

/*
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

endmodule*/