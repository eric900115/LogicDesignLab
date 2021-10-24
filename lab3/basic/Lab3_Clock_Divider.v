`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;

reg clk1_2, clk1_4, clk1_3, clk1_8, dclk;
reg [2:0] clk_count_8;
reg [1:0] clk_count_4;
reg [1:0] clk_count_3;
reg clk_count;

wire CLK;

assign CLK = ~clk;

always @(posedge CLK)begin
    
    if(rst_n == 1'b0) begin
        clk_count <= 1'b01;
        clk_count_3 <= 2'b01;
        clk_count_4 <= 2'b01;
        clk_count_8 <= 3'b001;
        clk1_2 <= 1'b1;
        clk1_3 <= 1'b1;
        clk1_4 <= 1'b1;
        clk1_8 <= 1'b1;
    end
    else begin
        clk_count_8 <= clk_count_8 + 1'b1;
        clk_count_4 <= clk_count_4 + 1'b1;
        clk_count <= clk_count + 1'b1;

        if(clk_count_8 == 3'b000) 
            clk1_8 <= 1'b1;
        else
            clk1_8 <= 1'b0;
        
        if(clk_count_4 == 2'b00)
            clk1_4 <= 1'b1;
        else
            clk1_4 <= 1'b0;

        if(clk_count_3 == 2'b00) begin
            clk_count_3 <= 2'b01;
            clk1_3 <= 1'b1;
        end        
        else if(clk_count_3 == 2'b01) begin
            clk_count_3 <= 2'b10;
            clk1_3 <= 1'b0;
        end
        else if(clk_count_3 == 2'b10) begin
            clk_count_3 <= 2'b00;
            clk1_3 <= 1'b0;
        end
        else begin
            //do nothing
        end

        if(clk_count == 1'b0)
            clk1_2 <= 1'b1;
        else
            clk1_2 <= 1'b0;

    end
end



always @(*)begin
    //if(rst_n == 1'b0)
    if(sel == 2'b00)
        dclk = clk1_3;
    else if(sel == 2'b01) 
        dclk = clk1_2;
    else if(sel == 2'b10)
        dclk = clk1_4;
    else
        dclk = clk1_8;
end

endmodule
