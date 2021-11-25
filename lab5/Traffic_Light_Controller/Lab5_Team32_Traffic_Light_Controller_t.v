`timescale 1ns/1ps

module Traffic_Light_Controllers_t;
reg clk = 1'b0, rst_n = 1'b0;
reg lr_has_car = 1'b0;
wire [2:0] hw_light;
wire [2:0] lr_light;

reg [10:0] count = 11'd0;

// specify duration of a clock cycle.
parameter cyc = 2;

// generate clock.
always#(cyc/2)clk = !clk;

Traffic_Light_Controller traffic_light(clk, rst_n, lr_has_car, hw_light, lr_light);

//uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
/*initial begin
     $fsdbDumpfile("Clock_Divider.fsdb");
     $fsdbDumpvars;
end
*/

initial begin
  @(negedge clk)
  rst_n = 1'b1;
  count = count + 11'd1;
 


  //lr_has_car after the 80th cycle
  repeat(85) begin//count = count + 11'd1;
    @(negedge clk)
    rst_n = 1'b1;
    count = count + 11'd1;
  end
  
  @(negedge clk)
  count = count + 11'd1;
  lr_has_car = 1'b1;
  
  //process state HW_Y HW_R LR_G LR_Y LR_R
  repeat(121) begin//count = count + 11'd1;
    @(negedge clk) 
    rst_n = 1'b1;
    count = count + 11'd1;
  end



  //lr_has_car at the 80th cycles
  repeat(80) begin//count = count + 11'd1;
    @(negedge clk)
    lr_has_car = 1'b0;
    rst_n = 1'b1;
    count = count + 11'd1;
  end
  
  @(negedge clk)
  count = count + 11'd1;
  lr_has_car = 1'b1;
  
  //process state HW_Y HW_R LR_G LR_Y LR_R
  repeat(121) begin//count = count + 11'd1;
    @(negedge clk) 
    rst_n = 1'b1;
    count = count + 11'd1;
  end



  //lr_has_car before the 80th cycles
  repeat(65) begin//count = count + 11'd1;
    @(negedge clk)
    lr_has_car = 1'b0;
    rst_n = 1'b1;
    count = count + 11'd1;
  end
  
  repeat(15) begin
    @(negedge clk)
    count = count + 11'd1;
    lr_has_car = 1'b1;
  end
  
  //process state HW_Y HW_R LR_G LR_Y LR_R
  repeat(124) begin//count = count + 11'd1;
    @(negedge clk) 
    rst_n = 1'b1;
    count = count + 11'd1;
  end


  #cyc $finish;
end

endmodule