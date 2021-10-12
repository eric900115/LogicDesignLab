`timescale 1ns/1ps

module Majority(a, b, c, out);
input a, b, c;
output out;

wire w0, w1, w2, w3;

AND and_a_b(w0, a, b);
AND and_a_c(w1, a, c);
AND and_b_c(w2, b, c);
OR or_w0_w1(w3, w0, w1);
OR or_w2_w3(out, w2, w3);

endmodule


module AND(f, a, b);
input a,b;
output f;

wire w0;

nand nand_a_b(w0, a, b);
nand not_w0(f, w0, w0);

endmodule

module OR(f, a, b);
input a,b;
output f;

wire w0, w1;

NOT not_a(w0, a);
NOT not_b(w1, b);
nand nand_w0_w1(f, w0, w1);

endmodule

module NOT(f, a);
input a;
output f;

nand not_a(f, a, a);

endmodule
