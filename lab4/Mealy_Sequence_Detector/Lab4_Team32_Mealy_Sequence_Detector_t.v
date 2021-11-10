`timescale 1ns/1ps

module Mealy_Sequence_Detector_t ();

reg clk = 1'b0;
reg rst_n = 1'b0;
reg in;
reg [4-1:0] seq = 4'b0000;
wire dec;
wire [3:0] state;
integer i, j;
parameter cyc = 4;

always #(cyc/2) clk = !clk;

Mealy_Sequence_Detector q1(
  .clk(clk),
  .rst_n(rst_n),
  .in(in),
  .dec(dec),
  .state(state)
);

initial begin
  @(negedge clk)
  rst_n = 1'b0;
 
  for(i=0;i<16;i=i+1) begin
    //for(j = 0;j < 4; j= j +1) begin
    @(negedge clk)
    seq = seq + 4'd1;
    rst_n = 1'b1;
    in = seq[0];
    @(negedge clk)
    rst_n = 1'b1;
    in = seq[1];
    @(negedge clk)
    rst_n = 1'b1;
    in = seq[2];
    @(negedge clk)
    rst_n = 1'b1;
    in = seq[3];
    /*if(j % 4 == 2'd0) begin
        in = seq[3];
        seq = seq + 4'd1;
    end
    else if(j % 4 == 2'd1) begin
     
        in = seq[0];
    end
    else if(j % 4 == 2'd2) begin
        in = seq[1];
    end
    else if(j % 4 == 2'd3) begin
        in = seq[2];
        
    end*/
    
    
    end
   
    
  
    #cyc
  $finish;
end

endmodule