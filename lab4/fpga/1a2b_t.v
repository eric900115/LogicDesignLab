`timescale 1ns / 1ps

module game_t;
reg [15:0] randoms = {4'd1, 4'd2, 4'd3, 4'd4};
reg [15:0] guesses = {4'd1, 4'd3, 4'd2, 4'd5};
reg clk = 1'b0, start = 1'b1;
wire [2:0]num_A, num_B; 
wire [2:0] state;

//parameter cyc = 20;
//always 
getResult result(
    .randoms(randoms), 
    .guesses(guesses),
    .clk(clk), 
    .start(start), 
    .num_A(num_A),
    .num_B(num_B),
    .state(state)
);

initial begin    
    repeat (20) begin
        #1
        clk = ~clk;
        if(clk == 1'b0)
            start = 1'b0;
    end
    if(num_A == 3'd2)
        $display(" correct ");
    $finish;
end
endmodule
