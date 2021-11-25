`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd, state, finish_cycle);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;
output [1:0] state;
output [1:0] finish_cycle;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg [1:0] state, next_state;
reg finish_cal, finish_finish;
reg next_finish_cal, done;
reg [15:0] next_cal_a, next_cal_b;
reg [15:0] cal_a, cal_b;
reg [15:0] gcd;
reg [15:0] gcd_cal, next_gcd_cal;
reg [1:0] finish_cycle;

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
            if(start == 1'b1) 
                next_state = CAL;
            else
                next_state = WAIT;
        end
        CAL: begin
            if(finish_cal == 1'b1) begin
                next_state = FINISH;
            end
            else begin
                next_state = CAL;
            end
        end
        FINISH: begin
            if(finish_finish == 1'b1) begin
                next_state = WAIT;
            end
            else begin
                next_state = FINISH;
            end
        end
        default: begin
            next_state = WAIT;
        end
    endcase
end

//sequential for cal
always @(posedge clk) begin
    cal_a <= next_cal_a;
    cal_b <= next_cal_b;
    gcd_cal <= next_gcd_cal;
    finish_cal <= next_finish_cal;
end

//combinational for cal
always @(*) begin
    if(state == CAL) begin
        if(cal_a > cal_b) begin
            next_cal_a = cal_a - cal_b;
            next_cal_b = cal_b;

            if(cal_b == 16'd0) begin
                //next_cal_b == 0
                next_gcd_cal = cal_a;
                next_finish_cal = 1'b1;
            end
            else begin
                if(cal_a == cal_b) begin
                    //next_cal_a == 0
                    next_gcd_cal = cal_b;
                    next_finish_cal = 1'b1;   
                end
                else begin
                    next_gcd_cal = gcd_cal;
                    next_finish_cal = 1'b0;
                end
            end

        end
        else begin
            next_cal_a = cal_a;
            next_cal_b = cal_b - cal_a;

            if(cal_a == 16'd0) begin
                next_gcd_cal = cal_b;
                next_finish_cal = 1'b1;
            end
            else begin
                if(cal_a == cal_b) begin
                    next_gcd_cal = cal_a;
                    next_finish_cal = 1'b1;
                end
                else begin
                    next_gcd_cal = gcd_cal;
                    next_finish_cal = 1'b0;
                end
            end
            
        end
    end
    else begin
        next_cal_a = a;
        next_cal_b = b;
        next_gcd_cal = gcd_cal;
        next_finish_cal = 1'b0;
    end
end

// always @(*) begin
//     if(state == CAL) begin
//         if(cal_a == cal_b) begin
//             next_gcd_cal = cal_a;
//             next_finish_cal = 1'b1;
//         end
//         else begin
//             next_gcd_cal = gcd_cal;
//             next_finish_cal = 1'b0;
//         end
//     end
//     else begin
//         next_gcd_cal = gcd_cal;
//         next_finish_cal = 1'b0;
//     end
// end

always @(posedge clk) begin
    if(state == FINISH) begin
        finish_cycle <= finish_cycle + 2'b01;
    end
    else begin
        finish_cycle <= 2'b0;
    end
end

always @(*) begin
    if(state == FINISH) begin
        gcd = gcd_cal;
        if(finish_cycle == 2'd1) begin
            finish_finish = 1'b1;
            done = 1'b1;
        end
        else begin
            finish_finish = 1'b0;
            done = 1'b1;
        end
    end
    else begin
        done = 1'b0;
        finish_finish = 1'b0;
        gcd = 16'b0;
    end
end

endmodule
