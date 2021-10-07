`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/25 16:11:10
// Design Name: 
// Module Name: Crossbar_4x4_4bit_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Crossbar_4x4_4bit_t;


reg [3:0] in1 = 4'b0000;
reg [3:0] in2 = 4'b0010;
reg [3:0] in3 = 4'b0100;
reg [3:0] in4 = 4'b1000;
reg [4:0] control = 5'b00000;
wire [3:0] out1, out2, out3, out4;

Crossbar_4x4_4bit c1(
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .control(control),
    .out1(out1),
    .out2(out2),
    .out3(out3),
    .out4(out4)
);

//brute force
initial begin
    repeat (31) begin
        #1 control = control + 5'b00001;
    end
    #1 $finish;
end

endmodule
