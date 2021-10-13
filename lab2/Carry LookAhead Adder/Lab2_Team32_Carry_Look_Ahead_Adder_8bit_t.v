`timescale 1ns/1ps

module Lab2_Team32_Carry_Look_Ahead_Adder_8bit_t;
reg [7:0] a = 8'b0;
reg [7:0] b = 8'b0;
reg cin = 1'b0;
wire [7:0] sum;
wire cout;

 Carry_Look_Ahead_Adder_8bit cla(
    .a(a), 
    .b(b), 
    .c0(cin), 
    .sum(sum), 
    .c8(cout)
);


initial begin
  repeat (2 ** 16) begin
   	#1 {a, b} = {a, b} + 1'b1;
	#1
	if(a + b + cin != {cout, sum})
		$display("error occurs at a=%b b=%b cin=%b cout=%b sum=%b", a, b, cin, cout,sum);
  end
  cin = 1'b1;
  repeat (2 ** 16) begin
   	#1 {a, b} = {a, b} + 1'b1;
	#1
	if(a + b + cin != {cout, sum})
		$display("error occurs at a=%b b=%b cin=%b cout=%b sum=%b", a, b, cin, cout,sum);
  end
  #1 $finish;
end  
endmodule
