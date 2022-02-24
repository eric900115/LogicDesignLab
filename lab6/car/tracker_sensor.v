`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [2:0] state;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.

    //reg pre_left, pre_right, pre_mid;

    parameter go_straight = 3'd0;
    parameter turn_left = 3'd1;
    parameter turn_strong_left = 3'd2;
    parameter turn_peak_left = 3'd3;
    parameter turn_right = 3'd4;
    parameter turn_strong_right = 3'd5;
    parameter turn_peak_right = 3'd6;
    parameter stop = 3'd7;
    
    parameter left = 2'd0;
    parameter right = 2'd1;
    parameter straight = 2'd2;

    reg [2:0] next_state;
    reg [1:0] direction, next_direction;

    always @(posedge clk) begin
        if(reset == 1'b1) begin
            state <= go_straight;
            direction <= straight;
        end
        else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    always @(*) begin
        case({left_signal, mid_signal, right_signal})
            3'b000: begin
                next_direction = direction;
                if(direction == left)
                    next_state = turn_peak_left;
                else if(direction == right)
                    next_state = turn_peak_right;
                else
                    next_state = state;
            end
            3'b001: begin
                next_state = turn_strong_right;
                next_direction = right;
            end
            3'b011: begin
                next_state = turn_right;
                next_direction = right;
            end
            3'b100: begin
                next_state = turn_strong_left;
                next_direction = left;
            end
            3'b110: begin
                next_state = turn_left;
                next_direction = left;
            end
            default: begin
               next_state = go_straight; 
               next_direction = straight;
            end
        endcase
    end


endmodule
