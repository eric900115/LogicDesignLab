`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg [3:0] state;
reg [3:0] next_state;
reg dec;

parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;
parameter S6 = 4'd6;
parameter S7 = 4'd7;
parameter S8 = 4'd8;
parameter A0 = 4'd9;    // Abort state
parameter A1 = 4'd10;   // Abort state

always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        state <= 4'd0;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        S0:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? S1 : S6;
            end
        S1:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? S4 : S2;
            end
        S2:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? A1: S3;
            end
        S3:
            begin
                dec = (in)? 1'b1 : 1'b0;
                next_state = (in)? S0: S0;
            end
        S4:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? S5: A1;
            end 
        S5:
            begin
                dec = (in)? 1'b0 : 1'b1;
                next_state = (in)? S0: S0;
            end 
        S6:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? S7: A0;
            end 
        S7:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? S8: A1;
            end 
        S8:
            begin
                dec = (in)? 1'b1 : 1'b0;
                next_state = (in)? S0 : S0;
            end
        A0:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? A1 : A1;
            end
        default:
            begin
                dec = (in)? 1'b0 : 1'b0;
                next_state = (in)? S0 : S0;
            end 
    endcase
end
endmodule
