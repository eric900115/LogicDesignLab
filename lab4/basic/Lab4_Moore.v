`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output [1:0] out;
output [2:0] state;

reg [2:0] state, next_state;
reg [1:0] out;

parameter S0 = 3'b000;
parameter S1 = 2'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

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
        S0:begin
            out = 2'b11;
            if(in == 1'b0)
                next_state = S1;
            else
                next_state = S2;
        end
        S1:begin
            out = 2'b01;
            if(in == 1'b0)
                next_state = S4;
            else
                next_state = S5;
        end
        S2:begin
            out = 2'b11;
            if(in == 1'b0)
                next_state = S1;
            else
                next_state = S3;
        end
        S3:begin
            out = 2'b10;
            if(in == 1'b0)
                next_state = S1;
            else
                next_state = S0;
        end
        S4:begin
            out = 2'b10;
            if(in == 1'b0)
                next_state = S4;
            else
                next_state = S5;
        end
        default:begin
            out = 2'b00;
            if(in == 1'b0)
                next_state = S3;
            else
                next_state = S0;
        end
    endcase
end

endmodule
