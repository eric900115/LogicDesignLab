`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/24 23:15:39
// Design Name: 
// Module Name: crossbar_t
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


module crossbar_t;

reg [3:0] in1 = 4'b0000;
reg [3:0] in2 = 4'b0010;
reg control = 1'b0;
wire [3:0] out1, out2;

Crossbar_2x2_4bit c1(
    .in1(in1), 
    .in2(in2), 
    .control(control), 
    .out1(out1), 
    .out2(out2)
);

//brute force
initial begin
    repeat (2) begin
        #1 control = control + 1'b1;
        in1 = in1 + 4'b1;
        in2 = in2 + 4'b1;
    end
    #1 $finish;
end

endmodule
