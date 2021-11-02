`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [3:0] out;

reg [3:0] out, nxt_out;
reg direction, nxt_dir;

// seq
always @(posedge clk)begin
    if(rst_n == 1'b0)begin
        direction <= 1'b1;
        out <= 4'b0000;
    end
    else begin
        direction <= nxt_dir;
        out <= nxt_out;
    end    
end   

// combinational circuit for direction
always @(*)begin
    if(enable == 1'b1)begin
        if(out == 4'b1111)
            nxt_dir = 1'b0;
        else if(out == 4'b0000)
            nxt_dir = 1'b1;
        else
            nxt_dir = direction;
    end
    else
        nxt_dir = direction;
end

// combinational circuit for out
always @(*)begin
    if(enable == 1'b1)begin
        if(nxt_dir == 1'b1)
            nxt_out = out + 4'b1;
        else
            nxt_out = out - 4'b1;
    end  
	else 
		nxt_out = out;
end     

endmodule
