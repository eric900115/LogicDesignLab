`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg [7:0] d[7:0];
reg [7:0] next_d[7:0];
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
        d[0] <= 8'b0;
        d[1] <= 8'b0;
        d[2] <= 8'b0;
        d[3] <= 8'b0;
        d[4] <= 8'b0;
        d[5] <= 8'b0;
        d[6] <= 8'b0;
        d[7] <= 8'b0;
    end
    else begin
        dout <= next_dout;
        rear <= next_rear;
        front <= next_front;
        size <= next_size;
        error <= next_error;
        d[0] <= next_d[0];
        d[1] <= next_d[1];
        d[2] <= next_d[2];
        d[3] <= next_d[3];
        d[4] <= next_d[4];
        d[5] <= next_d[5];
        d[6] <= next_d[6];
        d[7] <= next_d[7];
    end
end
/*
always @(*)begin
    if((isFull == 1'b0) && (wen == 1'b1) ) begin
        d[rear] = din;
    end
    else begin
        d[rear] = d[rear];
    end
end*/

always @(*) begin
    next_d[7] = d[7];
    next_d[6] = d[6];
    next_d[5] = d[5];
    next_d[4] = d[4];
    next_d[3] = d[3];
    next_d[2] = d[2];
    next_d[1] = d[1];
    next_d[0] = d[0];

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
                next_d[rear] = din;
                /*case(rear)
                    3'b000:begin
                        next_d = {d[7:1], din}; 
                    end
                    3'b001:begin
                        next_d = {d[7:2], din, d[0]}; 
                    end
                    3'b010:begin
                        next_d = {d[7:3], din, d[1:0]}; 
                    end
                    3'b011:begin
                        next_d = {d[7:4], din, d[2:0]};
                    end
                    3'b100:begin
                        next_d = {d[7:5], din, d[3:0]};
                    end
                    2'b101:begin
                        next_d = {d[7:6], din, d[4:0]};
                    end
                    3'b110:begin
                        next_d = {d[7], din, d[5:0]};
                    end
                    default:begin
                        next_d = {din, d[6:0]};
                    end
                endcase*/
            end
        end
        default:begin
            next_rear = rear;
            next_d = d;
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
    endcase
end

endmodule
