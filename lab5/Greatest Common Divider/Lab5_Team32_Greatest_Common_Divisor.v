`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg [1:0] state, next_state;
reg [15:0] cal_gcd, next_cal_gcd, gcd;
reg done, next_done;
reg finish_cal, finish_finish;
reg [15:0] cal_a, next_cal_a;
reg [15:0] cal_b, next_cal_b;
reg finish_counter;

always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        state <= WAIT;
    end 
    else begin
        state <= next_state;
    end   
end

always @(*) begin
    case(state)
        WAIT: begin
            next_state = (start == 1'b1)? CAL : WAIT;
        end
        CAL: begin
            next_state = (finish_cal == 1'b1)? FINISH : CAL;
        end
        default: begin
            next_state = (finish_finish == 1'b1)? WAIT : FINISH;
        end
    endcase
end

always @(posedge clk) begin
    cal_a <= next_cal_a;
    cal_b <= next_cal_b;
    cal_gcd <= next_cal_gcd;
end

always @(*) begin
    if(state == CAL) begin
        if(cal_a == 16'b0) begin
            if(cal_b == 16'b0) begin
                next_cal_gcd = 16'b0;
                finish_cal = 1'b1;
                next_cal_a = cal_a;
                next_cal_b = cal_b;
            end
            else begin
                next_cal_gcd = cal_b;
                finish_cal = 1'b1;
                next_cal_a = cal_a;
                next_cal_b = cal_b;
            end
        end
        else begin
            if(cal_b == 16'b0) begin
                next_cal_gcd = cal_a;
                finish_cal = 1'b1;
                next_cal_a = cal_a;
                next_cal_b = cal_b;
            end
            else begin
                next_cal_gcd = cal_gcd;
                finish_cal = 1'b0;
                if(cal_a > cal_b) begin
                    next_cal_a = cal_a - cal_b;
                    next_cal_b = cal_b;
                end
                else begin
                    next_cal_a = cal_a;
                    next_cal_b = cal_b - cal_a;
                end
            end
        end
    end
    else begin
        next_cal_gcd = cal_gcd;
        finish_cal = 1'b0;
        next_cal_a = a;
        next_cal_b = b;
    end
end

always @(posedge clk) begin
    if(state == FINISH) begin
        finish_counter <= finish_counter + 1'b1;
    end
    else begin
        finish_counter <= 1'b0;
    end
end

always @(*) begin
    if(state == FINISH) begin
        gcd = cal_gcd;
        done = 1'b1;
        finish_finish = (finish_counter == 1'b1) ? 1'b1 : 1'b0;
    end
    else begin
        gcd = 16'd0;
        done = 1'b0;
        finish_finish = 1'b0;
    end
end

endmodule
