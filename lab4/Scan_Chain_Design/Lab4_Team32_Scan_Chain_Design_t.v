`timescale 1ns/1ps

module Scan_Chain_Design_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg scan_in = 1'b0;
reg scan_en = 1'b0;
wire scan_out;
reg [3:0] a = 4'b0, b = 4'b0;
reg [7:0] p;
reg [7:0] m;
reg [7:0] data;
integer i = 0;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Scan_Chain_Design scan_cahin(clk, rst_n, scan_in, scan_en, scan_out);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Many_To_One_LFSR.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @(negedge clk)
    rst_n = 1'b0;
    
    repeat(2 ** 8) begin
    
        @(negedge clk) begin
        data = {a, b};
        rst_n = 1'b1;
        scan_en = 1'b1;
        {a, b} = {a, b} + 8'd1;
        scan_in = b[0];
        data = {a, b};
        end
        for(i = 1; i < 8; i = i + 1) begin
            @(negedge clk)
                scan_in = data[i];
        end

        @(negedge clk) begin
        rst_n = 1'b1;
        scan_en = 1'b0;
        p = a * b;
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