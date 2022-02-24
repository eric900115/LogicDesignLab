`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg [2:0] state, next_state;
reg dec;

parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter S3 = 3'd3;
parameter S4 = 3'd4;
parameter S5 = 3'd5;
parameter S6 = 3'd6;
parameter S7 = 3'd7;

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
            next_state = (in == 1'b1) ? S1 : S0;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        S1: begin
            next_state = (in == 1'b1) ? S2 : S0;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        S2: begin
            next_state = (in == 1'b1) ? S2 : S3;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        S3: begin
            next_state = (in == 1'b1) ? S1 : S4;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        S4: begin
            next_state = (in == 1'b1) ? S5 : S0;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        S5: begin
            next_state = (in == 1'b1) ? S2 : S6;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        S6: begin
            next_state = (in == 1'b1) ? S5 : S7;
            dec = (in == 1'b1) ? 1'b0 : 1'b0;
        end
        default: begin
            next_state = (in == 1'b1) ? S1 : S0;
            dec = (in == 1'b1) ? 1'b1 : 1'b0;
        end
    endcase
end

endmodule 