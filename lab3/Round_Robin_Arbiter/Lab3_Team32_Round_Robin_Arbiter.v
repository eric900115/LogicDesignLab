`timescale 1ns/1ps

module Round_Robin_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [3:0] wen;
input [7:0] a, b, c, d;
output [7:0] dout;
output valid;
//output [1:0]state; 
reg valid;
reg [7:0] dout;
reg [3:0] ren, next_ren;
reg [1:0] next_state, state;

wire [7:0] d_out [3:0];
wire [3:0] error;

FIFO_8 FIFO_A(clk, rst_n, wen[0], ren[0], a, d_out[0], error[0]);
FIFO_8 FIFO_B(clk, rst_n, wen[1], ren[1], b, d_out[1], error[1]);
FIFO_8 FIFO_C(clk, rst_n, wen[2], ren[2], c, d_out[2], error[2]);
FIFO_8 FIFO_D(clk, rst_n, wen[3], ren[3], d, d_out[3], error[3]);



always @(posedge clk) begin
    if(rst_n == 1'b0)begin
        state <= 2'b00;
        ren <= 4'b0001;
    end
    else begin
        state <= next_state;
        ren <= next_ren;
    end
end

always @(*)begin
    case(state)
        2'b00:begin
            next_state = 2'b01;
            next_ren = 4'b0010;
        end
        2'b01:begin
            next_state = 2'b10;
            next_ren = 4'b0100;
        end
        2'b10:begin
            next_state = 2'b11;
            next_ren = 4'b1000;
        end
        default:begin
            next_state = 2'b00;
            next_ren = 4'b0001;
        end
    endcase
end

always @(*)begin
    case(state)
        2'b00:begin
            valid = !error[3];
            dout = d_out[3];
        end
        2'b01:begin
            valid = !error[0];
            dout = d_out[0];
        end
        2'b10:begin
            valid = !error[1];
            dout = d_out[1];
        end
        default:begin
            valid = !error[2];
            dout = d_out[2];
        end
    endcase
end

endmodule


module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg [7:0] d[7:0];
reg [2:0] rear, front;
reg [2:0] next_rear, next_front;
reg [3:0] size, next_size;
reg [7:0] dout, next_din, next_dout;
reg error, next_error;
wire isEmpty, isFull;

assign ptr_equal = (front == rear) ? 1'b1 : 1'b0; 
assign isFull = (ptr_equal) & (size == 4'b1000);
assign isEmpty = (ptr_equal) & (size == 4'b0000);

always @(posedge clk) begin
    if(rst_n == 1'b0)begin
        dout <= 8'b0;
        rear <= 3'b0;
        front <= 3'b0;
        size <= 4'b0;
        error <= 1'b0;
    end
    else begin
        dout <= next_dout;
        rear <= next_rear;
        front <= next_front;
        size <= next_size;
        error <= next_error;
    end
end

always @(*)begin
    if((isFull == 1'b0) && (wen == 1'b1)) begin
        d[rear] = din;
    end
    else begin
        d[rear] = d[rear];
    end
end

always @(*) begin
    case({ren, wen})
        2'b00:begin
            next_rear = rear;
            next_front = front;
            next_size = size;
            next_error = 1'b0;
            next_dout = 8'b0;
        end
        2'b01:begin
            next_front = front;
            next_dout = 8'b0;
            if(isFull == 1'b1)begin
                next_rear = rear;
                next_size = size;   
                next_error = 1'b1;  
            end
            else begin
                next_rear = rear + 3'b001;
                next_size = size + 4'b0001; 
                next_error = 1'b0;
            end
        end
        2'b10:begin
            next_rear = rear;
            if(isEmpty == 1'b1) begin
                next_front = front;
                next_size = size;
                next_dout = 8'b0;
                next_error = 1'b1;
            end
            else begin
                next_front = front + 3'b001;
                next_size = size - 4'b0001;
                next_dout = d[front];
                next_error = 1'b0;
            end
        end
        default:begin
            next_front = front;
            next_dout = 8'b0;
            next_error = 1'b1;
            if(isFull == 1'b1)begin
                next_rear = rear;
                next_size = size;   
            end
            else begin
                next_rear = rear + 3'b001;
                next_size = size + 4'b0001; 
            end
        end
    endcase
end

endmodule




