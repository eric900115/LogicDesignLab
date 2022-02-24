// *******************************
// PmodAMP2_Demo_1: Piano
// TOP module
// ********************************

module TOP (
    input clk,
    input reset,
    input [15:0] tone, //piano keys
	output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4	//SHUTDOWN_N
);
	
wire [31:0] freq;
assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on
	
Decoder decoder00 (
	.tone(tone),
	.freq(freq)
);

PWM_gen pwm_0 ( 
	.clk(clk), 
	.reset(reset), 
	.freq(freq),
	.duty(10'd512), 
	.PWM(pmod_1)
);

endmodule