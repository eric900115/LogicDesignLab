`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output direction;
output [3:0] out;
reg [3:0] out, nxt_out;
reg direction, nxt_dir;

// seq
always @(posedge clk)begin
    if(rst_n == 1'b0)begin
        out <= min;
        direction <= 1'b1;
    end
    else begin
        out <= nxt_out;
        direction <= nxt_dir;
    end
end

// enable == 1'b1, counter begins its operation
// comb
always @(*)begin
    if(enable == 1'b1) begin
        if(max > min) begin
            if(out <= max && out >= min) begin
                if(flip == 1'b1) begin
                    nxt_dir = !direction;
                end
                else begin
                    if(out == max)begin
                        nxt_dir = 1'b0;         // declined
                    end
                    else if(out == min)begin
                        nxt_dir = 1'b1;        // increased  
                    end
                    else begin
                        nxt_out = out;
                        nxt_dir = direction;
                    end
                end
                
                if(nxt_dir == 1'b1)begin
                    nxt_out = out + 4'b1;
                end
                else if(nxt_dir == 1'b0)begin
                    nxt_out = out - 4'b1;
                end
                
            end
            else begin
                nxt_out = out;
                nxt_dir = direction;
            end
        end
        else begin
            nxt_out = out;
            nxt_dir = direction;
        end
    end
    else begin
        nxt_out = out;
        nxt_dir = direction;
    end
end

/*
always @(*)begin
    if(enable == 1'b1) begin
            if(max > min) begin
                if(out <= max && out >= min) begin
                    
                end
                else    nxt_out = out;
            end
            else    nxt_out = out;
    end
    else    nxt_out = out;
end
*/
        
endmodule


