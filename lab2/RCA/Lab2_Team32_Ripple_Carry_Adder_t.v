`timescale 1ns/1ps

module Lab2_Team32_Ripple_Carry_Adder_t;
reg [7:0] a = 8'b0;
reg [7:0] b = 8'b0;
reg cin = 1'b0;
wire [7:0] sum;
wire cout;

Ripple_Carry_Adder rca(
    .a (a),
    .b (b),
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Adders.fsdb");
//      $fsdbDumpvars;
// end

initial begin
  repeat (2 ** 4) begin
    #1 a = a + 8'b1;
    #1 cin = cin + 1'b1;
  end
  #1 {a, b} = 16'b0;
  repeat (2 ** 4) begin
    #1 b = b + 8'b1;
    #1 cin = cin + 1'b1;
  end
  
  #1 {b, a} = 16'hfa00;
  repeat (2 ** 4) begin
    #1 a = a + 8'b1;
    #1 cin = cin + 1'b1;
  end
  #1 {a, b} = 16'hfa00;
  repeat (2 ** 4) begin
    #1 b = b + 8'b1;
    #1 cin = cin + 1'b1;
  end
  
   #1 {b, a} = 16'hfffa;
  repeat (2 ** 3) begin
    #1 a = a + 8'b1;
    #1 cin = cin + 1'b1;
  end
  #1 {a, b} = 16'hfffa;
  repeat (2 ** 3) begin
    #1 b = b + 8'b1;
    #1 cin = cin + 1'b1;
  end
  
end  
endmodule
