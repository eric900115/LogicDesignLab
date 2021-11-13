`timescale 1ns / 1ps

module getInput_t;
reg clk = 1'b0;
reg start = 1'b1;
reg [3:0] button = 4'd5;
reg enter = 1'b1;
wire [15:0] guesses;

//parameter cyc = 20;

//always#(cyc/2)clk = !clk;

getInput get(
    .clk(clk), 
    .start(start), 
    .button(button), 
    .enter(enter), 
    .guesses(guesses)
);

reg [4:0]cur = 5'd0;

initial begin
    
    repeat(20) begin
        #1
        clk = ~clk;
        
        if(cur % 2 == 1)
            enter = ~enter;
        
        if(cur >= 5'd2 && cur <= 5'd14) begin
            if(cur == 5'd2)
                button = 4'd4;
            if(cur == 5'd6)
                button = 4'd3;
            if(cur == 5'd10)
                button = 4'd2;
            if(cur == 5'd14)
                button = 4'd7;
        end
        
        if(clk == 1'b0)
            start = 1'b0;
        
        
        cur = cur + 5'd1;
        
    end
    $finish;

end
endmodule
