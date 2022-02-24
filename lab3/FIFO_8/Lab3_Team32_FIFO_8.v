`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg [7:0] d[7:0];
reg [7:0] next_d;
reg [2:0] rear, front;
reg [2:0] next_rear, next_front;
reg [3:0] size, next_size;
reg [7:0] dout, next_din, next_dout;
reg error, next_error;
wire isEmpty, isFull;

assign ptr_equal = (front == rear) ? 1'b1 : 1'b0; 
assign isFull = (ptr_equal) && (size == 4'b1000);
assign isEmpty = (ptr_equal) && (size == 4'b0000);

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
        d[rear] <= next_d;
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
            next_d = d[rear];
        end
        2'b01:begin
            next_front = front;
            next_dout = 8'b0;
            if(isFull == 1'b1)begin
                next_rear = rear;
                next_size = size;   
                next_error = 1'b1;
                next_d = d[rear];
            end
            else begin
                next_rear = rear + 3'b001;
                next_size = size + 4'b0001; 
                next_error = 1'b0;
                next_d = din;
            end
        end
        default:begin
            next_rear = rear;
            if(isEmpty == 1'b1) begin
                next_front = front;
                next_size = size;
                next_dout = 8'b0;
                next_error = 1'b1;
                next_d = d[rear];
            end
            else begin
                next_front = front + 3'b001;
                next_size = size - 4'b0001;
                next_dout = d[front];
                next_error = 1'b0;
                next_d = d[rear];
            end
        end
    endcase
end

endmodule
