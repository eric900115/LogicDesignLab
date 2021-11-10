`timescale 1ns/1ps

module Multiplier_t;
reg [3:0] a = 4'b0000, b = 4'b0000;
wire [7:0] p;
reg [7:0] tmp;

Multiplier_4bit mul0(
    .a(a), 
    .b(b), 
    .p(p)
);

initial begin
    repeat (2 ** 8) begin
        #1 {a, b} = {a, b} + 4'b0001;
        #1 
        tmp = a * b;
        if(tmp !== p)
            $display("error occurs at sub a=%d b=%d p=%d a*b=%d", a, b, p, a*b);
    end
    #1 $finish;
end
endmodule
