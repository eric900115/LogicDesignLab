`timescale 1ns/1ps

module Scan_Chain_Design_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg scan_en = 1'b0;
wire scan_out;
wire scan_in;
reg [7:0] p;
reg [7:0] m;
reg [7:0] data;
integer i = 0;
reg [3:0] a, b;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Built_In_Self_Test built_in_test(clk, rst_n, scan_en, scan_in, scan_out);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Many_To_One_LFSR.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @(negedge clk)
    rst_n = 1'b0;
    
    repeat(2 ** 8) begin
    
        for(i = 0; i < 8; i = i + 1) begin
            @(negedge clk) begin
            rst_n = 1'b1;
            scan_en = 1'b1;
            data[i] = scan_in;
            end
        end

        @(negedge clk) begin
        rst_n = 1'b1;
        scan_en = 1'b0;
        p = data[3:0] * data[7:4];
        {b, a} = data;
        end

        for(i = 0; i < 8; i = i + 1) begin
            @(negedge clk) begin
                rst_n = 1'b1;
                scan_en = 1'b1;
                m[i] = scan_out;
            end
        end
        if(m != p)
            $display("error m=%d p=%d", m, p);
    end
    
    #(cyc * 16)
    $finish;
end
endmodule