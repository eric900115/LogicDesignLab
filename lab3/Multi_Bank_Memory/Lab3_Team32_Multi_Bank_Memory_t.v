`timescale 1ns / 1ps

module Multi_Bank_Memory_t;
reg clk = 0;
reg ren, wen;
reg [10:0] waddr;
reg [10:0] raddr;
reg [7:0] din;
wire [7:0] dout;


integer i = 0;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Multi_Bank_Memory m0(clk, ren, wen, waddr, raddr, din, dout);

//uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
/*initial begin
     $fsdbDumpfile("Clock_Divider.fsdb");
     $fsdbDumpvars;
end*/

initial begin

    //write data to memory
    @ (negedge clk)begin
    wen = 1'b1;
    ren = 1'b0;
    din = 7'd2;
    waddr = 11'b0;
    raddr = 11'd2000;
    end

    for(i = 1; i < 2 ** 2; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b1;
        ren = 1'b0;
        din = i + 7'd2;
        waddr = waddr + 1'b1;
        raddr = 11'd2000;
        end
    end

    //read data from the memory we write data
    @ (negedge clk)begin
    wen = 1'b0;
    ren = 1'b1;
    din = 7'd2;
    waddr = 11'd2000;
    raddr = 11'b0;
    end
    
    for(i = 1; i < 2 ** 2; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b0;
        ren = 1'b1;
        din = i + 7'd2;
        raddr = raddr + 1'b1;
        waddr = 11'd2000;
        end
    end
    
    //read and write data to the different memory simultaneously
  /*  @ (negedge clk)begin
    wen = 1'b1;
    ren = 1'b1;
    din = 7'd2;
    waddr = 11'd1500;
    raddr = 11'd2000;
    end
    
    for(i = 1; i < 2 ** 2; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b1;
        ren = 1'b1;
        din = i + 7'd2;
        raddr = raddr + 1'b1;
        waddr = waddr + 1'b1;
        end
    end

    @ (negedge clk)begin
    wen = 1'b0;
    ren = 1'b1;
    din = 7'd2;
    waddr = 11'd500;
    raddr = 11'd1500;
    end
    
    for(i = 1; i < 2 ** 2; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b1;
        ren = 1'b1;
        din = i + 7'd2;
        raddr = raddr + 1'b1;
        waddr = waddr + 1'b1;
        end
    end
*/

    //read and write data to the same memory simultaneously
    @ (negedge clk)begin
    //rst_n = 1'b0;
    wen = 1'b1;
    ren = 1'b1;
    din = 7'd2;
    waddr = 11'd1001;
    raddr = 11'd1000;
    end
    
    for(i = 1; i < 2 ** 2; i = i + 1)begin
        @(negedge clk)begin
        wen = 1'b1;
        ren = 1'b1;
        din = i + 7'd2;
        raddr = raddr + 1'b1;
        waddr = waddr + 1'b1;
        end
    end
    #1 $finish;
end

endmodule
