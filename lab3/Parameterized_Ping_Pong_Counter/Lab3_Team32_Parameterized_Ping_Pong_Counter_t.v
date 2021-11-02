`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter_t ();
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b1;
reg flip = 0;
reg [3:0] max = 4'd15;
reg [3:0] min = 4'd0;
wire direction;
wire [3:0] out;

parameter cyc = 4;

always #(cyc/2) clk = !clk;

Parameterized_Ping_Pong_Counter pppc (
    .clk(clk), 
    .rst_n(rst_n), 
    .enable(enable), 
    .flip(flip), 
    .max(max), 
    .min(min), 
    .direction(direction), 
    .out(out)
);

initial begin 
    @ (negedge clk)
    rst_n = 1'b0;
    @ (negedge clk)
    rst_n = 1'b1;
    #(cyc * 20) enable = 1'b1;
    repeat(2 ** 3) begin
    #(cyc * 1) flip = flip + 1;
    end
    
    @ (negedge clk)
    repeat(2 ** 3) begin
    #(cyc * 5) enable = enable + 1;
    end
    
    #(cyc * 3) max = 4'd3;
    #(cyc * 3) min = 4'd7;
    
    #(cyc * 3) max = 4'd15;
    #(cyc * 3) min = 4'd3;
    
    #(cyc * 3) max = 4'd3;
    #(cyc * 3) min = 4'd3;
    
    #1 $finish;
end    

endmodule