`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector_t ();

reg clk = 1'b0;
reg rst_n = 1'b0;
reg in = 1'b0;
reg [3:0] seq = 8'b1100;
reg [1:0] repeated = 2'b10;
wire dec;
wire [3:0] state;
integer i = 0;
reg [4:0] cur = 5'd0;

parameter cyc = 4;

always #(cyc/2) clk = !clk;

Sliding_Window_Sequence_Detector sq0(
  .clk(clk),
  .rst_n(rst_n),
  .in(in),
  .dec(dec),
  .state(state)
);


initial begin
    @(negedge clk)
    rst_n = 1'b0;
     
        #20 init;
        repeated_num;
        
  
   
    @(negedge clk)
    rst_n = 1'b1;
    in = repeated[0];
    @(negedge clk)
    rst_n = 1'b1;
    in = repeated[1];
    
    #cyc
    $finish;
end

task init;
    begin
        @(negedge clk)
        rst_n = 1'b1;
        in = seq[3];
        @(negedge clk)
        rst_n = 1'b1;
        in = seq[2];
        @(negedge clk)
        rst_n = 1'b1;
        in = seq[1];
        @(negedge clk)
        rst_n = 1'b1;
        in = seq[0];

    end
endtask
task repeated_num;
    begin
        @(negedge clk)
        rst_n = 1'b1;
        in = repeated[1];
        @(negedge clk)
        rst_n = 1'b1;
        in = repeated[0];
    end
endtask

task end_num;
    begin
        @(negedge clk)
        rst_n = 1'b1;
        in = repeated[0];
        @(negedge clk)
        rst_n = 1'b1;
        in = repeated[1];
    end
endtask

endmodule