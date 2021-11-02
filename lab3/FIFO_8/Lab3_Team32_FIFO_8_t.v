`timescale 1ns / 1ps



module FIFO_8_t;
reg clk = 0;
reg rst_n = 1'b0;
reg ren = 1'b0;
reg wen = 1'b0;
reg [7:0] din = 8'd0;
wire [7:0] dout;
wire error;
wire [2:0] rear, front;
wire [3:0] size;
wire isFull, isEmpty;
wire [1:0] flag;

integer i = 0;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

FIFO_8 fifo(clk, rst_n, wen, ren, din, dout, error);

//uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
/*initial begin
     $fsdbDumpfile("Clock_Divider.fsdb");
     $fsdbDumpvars;
end
*/

initial begin
    
    //write eight data to the queue
    @ (negedge clk)begin
    rst_n = 1'b0;
    end
    @ (negedge clk)begin
    rst_n = 1'b1;
    wen = 1'b1;
    ren = 1'b0;
    i = 0;
    din = 8'd15;
    end

    for(i = 1; i < 8; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b1;
        ren = 1'b0;
        din = i + 2'b10;
        end
    end

    //write 8 data to full queue
    for(i = 1; i < 9; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b1;
        ren = 1'b0;
        din = i + 2'b10 + 7'd8;
        end
    end


    //read 8 data from queue
    for(i = 0; i < 8; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b0;
        ren = 1'b1;
        din = i + 2'b10;
        end
    end


    //read 8 data from empty queue
    for(i = 0; i < 8; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b0;
        ren = 1'b1;
        din = i + 2'b10;
        end
    end

    #1 $finish;
end

endmodule
