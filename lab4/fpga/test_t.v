`timescale 1ns / 1ps

module test_t();
    reg in;
    reg clk = 1'b0;
    
    wire out, in_debounce, clk_27, clk_19;
    integer i;
    test t0(in, clk, out, in_debounce, clk_27, clk_19);
    
    initial begin
        for(i = 0; i < 10000000;i=i+1) begin
            #1 clk = ~clk;
            if(i > 100 && i % 10 != 4'd9)
                in = 1'b1;
            else 
                in = 1'b0;
        end
        $finish;
    end
endmodule
