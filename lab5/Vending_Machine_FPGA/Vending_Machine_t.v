`timescale 1ns/1ps

module vending_machine_t;
reg rst_n = 1'b1, clk = 1'b0;
reg insert_coin_10, insert_coin_5, insert_coin_50;
reg cancel;
reg select_a, select_s, select_d, select_f;
wire [6:0] coin;

reg [1:0] sel_insert;
wire state;

vending_machine Vending_Machine(clk, rst_n, coin, insert_coin_5, insert_coin_10,  insert_coin_50, cancel, select_a, select_s, select_d, select_f, state);

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

initial begin
    @(negedge clk)
        rst_n = 1'b0;
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b000;
        {select_a, select_s, select_d, select_f} = 4'b0000;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b100;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b000;
        {select_a, select_s, select_d, select_f} = 4'b1000;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b010;
        {select_a, select_s, select_d, select_f} = 4'b0000;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b001;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b010;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b100;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b100;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b001;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b010;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b100;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b010;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b010;
    @(negedge clk)
        {insert_coin_10, insert_coin_5, insert_coin_50} = 3'b000;
        {select_a, select_s, select_d, select_f} = 4'b1000;
    @(negedge clk)
        {select_a, select_s, select_d, select_f} = 4'b0100;

    
end


endmodule