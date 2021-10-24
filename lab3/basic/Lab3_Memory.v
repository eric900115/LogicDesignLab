`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output [7:0] dout;

reg [7:0] memory [127:0];
reg [7:0] dout;
reg count;

always @(posedge clk) begin

    if(wen == 1'b1 && ren == 1'b1) begin
        dout[7:0] <= memory[addr];
    end
    else if(wen == 1'b1 && ren == 1'b0) begin
        memory[addr] <= din[7:0];
        dout[7:0] <= 8'b00000000;
    end
    else if(wen == 1'b0 && ren == 1'b1) begin
        dout[7:0] <= memory[addr];
    end
    else begin
        dout[7:0] <= 8'b00000000;
    end

end

endmodule
