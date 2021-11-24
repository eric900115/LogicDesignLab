`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec, state);
input clk, rst_n;
input in;
output dec;
output state;

reg [4:0] state, next_state;
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
parameter S9 = 4'd9;

always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        S0: begin
            next_state = (in)? S1 : S0;
            dec = (in)? 1'b0 : 1'b0;        
        end
        S1: begin
            next_state = (in)? S2 : S0;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S2: begin
            next_state = (in)? S0 : S3;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S3: begin
            next_state = (in)? S0 : S4;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S4: begin
            next_state = (in)? S5 : S0;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S5: begin
            next_state = (in)? S0 : S6;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S6: begin
            next_state = (in)? S7 : S9;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S7: begin
            next_state = (in)? S0 : S8;
            dec = (in)? 1'b0 : 1'b0;  
        end
        S8: begin
            next_state = (in)? S7 : S9;
            dec = (in)? 1'b0 : 1'b0;  
        end
        default: begin
            next_state = (in)? S0 : S0;
            dec = (in)? 1'b1 : 1'b0;  
        end
    endcase
end

endmodule 