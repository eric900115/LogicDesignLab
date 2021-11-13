`timescale 1ns / 1ps

module top(clk, rst_n, button, enter, out);
input clk, rst_n;
input [3:0] button;
input enter;
output [27:0] out;

reg [2:0] state, next_state;
reg finish;

parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter S3 = 3'd3;
// parameter F0 = 3'd4;

always @(posedge clk) begin
    if(rst_n == 1'b1) begin
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        S0: begin
            next_state = S1;
        end  
        S1: begin
            next_state = S2;
        end  
        S2: begin
            next_state = S3;
        end  
        S3: begin
            next_state = S0;
        end
        default: begin
            next_state = state;
        end
    endcase
end

endmodule

module getInput(clk, start, button, enter, guesses, finish);
input clk;
input start;
input [3:0] button;
input enter;
output reg [15:0] guesses;
output finish;

reg [2:0] state, next_state;
reg [15:0] next_guesses;

parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter S3 = 3'd3;
parameter F0 = 3'd4;

always @(posedge clk) begin
    if(start == 1'b1) begin
        state <= S0;
        guesses <= {4'd0, 4'd0, 4'd0, 4'd0};
    end
    else begin
        state <= next_state;
        guesses <= next_guesses;
    end
end

always @(*) begin
    case(state)
        S0: begin
            next_state = (enter == 1'b1)? S1 : state;
            next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses; 
        end
        S1: begin
            next_state = (enter == 1'b1)? S2 : state;
            next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses;
        end
        S2: begin
            next_state = (enter == 1'b1)? S3 : state;
            next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses;
        end
        S3: begin
            next_state = (enter == 1'b1)? F0 : state;
            next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses;
        end
        default: begin
            next_state = state;
            next_guesses = guesses;
      
        end
    endcase
end

assign finish = (state == F0 ? 1'b1 : 1'b0);
endmodule

module getResult(clk, start, randoms, guesses, num_A, num_B, state, finish);
input clk;
input start;
input [15:0] randoms, guesses;
output reg [2:0]num_A, num_B; 
output finish;

wire [3:0]random[3:0];
wire [3:0]guess[3:0];
assign {random[3], random[2], random[1], random[0]} = randoms;
assign {guess[3], guess[2], guess[1], guess[0]} = guesses;
output reg [2:0]state;
reg [2:0]next_state, next_numA, next_numB;

parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter S3 = 3'd3;
parameter F0 = 3'd4;

always @(posedge clk) begin
    if(start == 1'b1) begin
        state <= S0;
        num_A <= 1'b0;
        num_B <= 1'b0;
    end
    else begin
        state <= next_state;
        num_A <= next_numA;
        num_B <= next_numB;
    end
end

always @(*) begin
    case(state)
        S0: begin
            next_numA = num_A + (random[3] == guess[3]? 1'b1 : 1'b0);
            next_numB = num_B + (((random[3] == guess[0]) || (random[3] == guess[1]) || (random[3] == guess[2]))? 1'b1 : 1'b0);
            next_state = S1;
            end
        S1: begin
            next_numA = num_A + (random[2] == guess[2]? 1'b1 : 1'b0);
            next_numB = num_B + (((random[2] == guess[0]) || (random[2] == guess[1]) || (random[2] == guess[3]))? 1'b1 : 1'b0);
            next_state = S2;
            end
        S2: begin
            next_numA = num_A + (random[1] == guess[1]? 1'b1 : 1'b0);
            next_numB = num_B + (((random[1] == guess[0]) || (random[1] == guess[2]) || (random[1] == guess[3]))? 1'b1 : 1'b0);        
            next_state = S3;
            end
        S3: begin
            next_numA = num_A + (random[0] == guess[0]? 1'b1 : 1'b0);
            next_numB = num_B + (((random[0] == guess[1]) || (random[0] == guess[2]) || (random[0] == guess[3]))? 1'b1 : 1'b0);
            next_state = F0;
            end
        default: begin
            next_numA = num_A; 
            next_numB = num_B;
            next_state = F0;
            end
    
    endcase
end

assign finish = (state == F0 ? 1'b1 : 1'b0);
endmodule

// generate random numbers
module Many_To_One_LFSR(clk, rst_n, data);
input clk;
input rst_n;
output [3:0] data;

reg [7:0] out;
reg [7:0] next_out;

wire in_DFF0;

always @(posedge clk) begin
    if(rst_n == 1'b0)
        out <= 8'b10111101;
    else begin
        out <= next_out;
    end
end

assign in_DFF0 = out[7] ^ out[3] ^ out[2] ^ out[1]; 
assign data = out[7:4];

always @(*)begin
    next_out = {out[6:0], in_DFF0};
end

endmodule


