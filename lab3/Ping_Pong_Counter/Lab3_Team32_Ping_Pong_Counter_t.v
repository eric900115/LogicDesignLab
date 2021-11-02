`timescale 1ns / 1ps

module Ping_Pong_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b0;
wire direction;
wire [3:0] out;

parameter cyc = 4;

always#(cyc/2)clk = !clk;

Ping_Pong_Counter ppc(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .direction(direction),
    .out(out)
);

initial begin 
    @ (negedge clk)
    rst_n = 1'b0;
    @ (negedge clk)
    rst_n = 1'b1;
    enable = 1'b1;
    @ (negedge clk)
    repeat(2 ** 4) begin
    #(cyc * 5) enable = enable + 1;
    end
    #1 $finish;
end    

endmodule
