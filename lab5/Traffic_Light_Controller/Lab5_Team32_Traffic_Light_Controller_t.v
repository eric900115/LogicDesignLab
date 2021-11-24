`timescale 1ns/1ps

module Traffic_Light_Controllers_t;
reg clk = 1'b0, rst_n = 1'b0;
reg lr_has_car = 1'b0;
wire [2:0] hw_light;
wire [2:0] lr_light;
wire [2:0]state;

//reg [10:0] count = 11'd0;

// specify duration of a clock cycle.
parameter cyc = 5;

// generate clock.
always#(cyc/2)clk = !clk;

Traffic_Light_Controller traffic_light(clk, rst_n, lr_has_car, hw_light, lr_light, state);

//uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
/*initial begin
     $fsdbDumpfile("Clock_Divider.fsdb");
     $fsdbDumpvars;
end
*/

initial begin
  @(negedge clk)
  rst_n = 1'b1;
  //lr_has_car = 1'b1;
 
  #(cyc * 79) //count = count + 11'd1;
  @(negedge clk)
  lr_has_car = 1'b1;
  
  #(cyc * 20) //count = count + 11'd1;
  #(cyc * 1) 
  #(cyc * 80)
  #(cyc * 20)
  #(cyc * 1)
/*
  */
  #cyc
  $finish;
end

endmodule