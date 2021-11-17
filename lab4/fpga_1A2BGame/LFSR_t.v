`timescale 1ns/1ps

module LFSR_t;
reg clk = 0;
reg rst_n = 1;
wire [3:0] out_0, out_1, out_2, out_3;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

random_generator m21lfsr(clk, rst_n, out_0, out_1, out_2, out_3);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Many_To_One_LFSR.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @(negedge clk)
    rst_n = 1'b0;

    repeat(2 ** 9) begin
        @(negedge clk)
        rst_n = 1'b1;
    end
    
    #(cyc * 16)
    $finish;
end
endmodule