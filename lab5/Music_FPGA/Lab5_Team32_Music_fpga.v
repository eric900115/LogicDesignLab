`timescale 1ns/1ps

module Music_fpga (
    input clk,
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4	//SHUTDOWN_N
    );
    
    // keyboard
    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	parameter LEFT_ENTER = 9'b0_0101_1010;
	parameter RIGHT_ENTER = 9'b1_0101_1010;
    parameter key_w = 9'b0_0001_1101;
    parameter key_s = 9'b0_0001_1011;
    parameter key_r = 9'b0_0010_1101;
    
    reg rst;
    reg w_pressed;  // ascend
    reg s_pressed;  // descend
    reg r_pressed;  // change the sec per note
    
    // audio
    parameter DUTY_BEST = 10'd512;
    reg [31:0] BEAT_FREQ, next_BEAT_FREQ; //32'd2: one beat = 0.5 sec, 32'd1: one beat = 1 sec
    parameter [31:0] cnt_1 = 32'd100_000_000;
    parameter [31:0] cnt_1_2 = 32'd50_000_000;

    wire [31:0] freq;
    wire [4:0] ibeatNum;
    wire beatFreq;
    
    assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;	//turn-on 
     
    KeyboardDecoder key_de (
        .key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
    ClockDivider clk_divider(
        .clk(clk), 
        .rst(rst), 
        .cnt_max(BEAT_FREQ),
        .clk_div(beatFreq)
    ); 
     
    UserCtrl playerCtrl (
        .clk(clk),
        .rst(rst),
        .beatFreq(beatFreq),
        .ascend(w_pressed),
        .descend(s_pressed),
        .ibeat(ibeatNum)
    );    
    
    //Generate variant freq. of tones
    scale scale0(
        .ibeatNum(ibeatNum),
        .tone(freq)
    );
    
    // Generate particular freq. signal
    PWM_gen toneGen ( 
        .clk(clk), 
        .reset(rst), 
        .freq(freq),
        .duty(DUTY_BEST), 
        .PWM(pmod_1)
    );
    
    always @(posedge clk) begin
        if (been_ready && key_down[last_change] == 1'b1) begin
            rst <= (last_change == LEFT_ENTER || last_change == RIGHT_ENTER) ? 1'b1 : 1'b0;
            w_pressed <= (last_change == key_w) ? 1'b1 : 1'b0;
            s_pressed <= (last_change == key_s) ? 1'b1 : 1'b0;
            r_pressed <= (last_change == key_r) ? 1'b1 : 1'b0;
        end
        else begin
            rst <= 1'b0;
            w_pressed <= 1'b0;
            s_pressed <= 1'b0;
            r_pressed <= 1'b0;           
        end
    end
    
    always @(posedge clk) begin
        if(rst == 1'b1) BEAT_FREQ <= cnt_1;
        else    BEAT_FREQ <= next_BEAT_FREQ;
    end
    
    always @(*) begin
    if(r_pressed == 1'b1) begin
        if(BEAT_FREQ == cnt_1)  next_BEAT_FREQ = cnt_1_2;
        else                    next_BEAT_FREQ = cnt_1;
    end
    else next_BEAT_FREQ = BEAT_FREQ;
    end
    
endmodule

module ClockDivider (
    input clk,
    input rst,
    input [31:0] cnt_max,
    output clk_div
  );

  reg [31:0] cnt;
    
  always @(posedge clk) begin
        if(rst == 1'b1) begin
            cnt <= 32'b0;
        end
        else begin
            if(cnt >= cnt_max)  cnt <= 32'b0;
            else cnt <= cnt + 32'b1;
        end
    end
    assign clk_div = (cnt >= cnt_max)? 1'b1 : 1'b0;

endmodule

module UserCtrl (
	input clk,
	input rst,
	input beatFreq,
	input ascend,
	input descend,
	output reg [4:0] ibeat
);
parameter C8 = 5'd28;
parameter C4 = 5'd0;
reg direction, next_dir;
reg [4:0] next_ibeat;

always @(posedge clk) begin
	if (rst) begin
		ibeat <= C4;
		direction <= 1'b1;
	end
	else begin
		  ibeat <= next_ibeat;
		  direction <= next_dir;
    end
end

always @(*) begin
    if(ibeat <= C8 && ibeat >= C4) begin
        if(ascend == 1'b1)
            next_dir = 1'b1;
        else if(descend == 1'b1)
            next_dir = 1'b0;
        else 
		  next_dir = direction;
    end
    else begin
        next_dir = direction;
    end
    
    
    if(next_dir == 1'b1) begin
        if(ibeat == C8)
            next_ibeat = ibeat;
        else
        	next_ibeat = ibeat + 5'd1;
	end
	else begin
        if(ibeat == C4)
            next_ibeat = ibeat;
        else
        	next_ibeat = ibeat - 5'd1;
	end
//	if(ibeat <= C4 || ibeat >= C8)
//	    next_ibeat = ibeat;
	
	next_ibeat = (beatFreq == 1'b1)? next_ibeat : ibeat;
end
endmodule

module scale (
    input [4:0] ibeatNum,
    output reg [31:0] tone
    );
  
    parameter NM1 = 32'd262; // C4_freq
    parameter NM2 = 32'd294; // D4_freq
    parameter NM3 = 32'd330; // E4_freq
    parameter NM4 = 32'd349; // F4_freq
    parameter NM5 = 32'd392; // G4_freq
    parameter NM6 = 32'd440; // A4_freq
    parameter NM7 = 32'd494; // B4_freq
    parameter NM0 = 32'd20000; //slience (over freq.)

    always @(*) begin
        case(ibeatNum)
            // C4~B4
            5'd0:   tone = NM1;
            5'd1:   tone = NM2;
            5'd2:   tone = NM3;
            5'd3:   tone = NM4;
            5'd4:   tone = NM5;
            5'd5:   tone = NM6;
            5'd6:   tone = NM7;
            
            // C5~B5
            5'd7:   tone = NM1 << 1;
            5'd8:   tone = NM2 << 1;
            5'd9:   tone = NM3 << 1;
            5'd10:   tone = NM4 << 1;
            5'd11:   tone = NM5 << 1;
            5'd12:   tone = NM6 << 1;
            5'd13:   tone = NM7 << 1;
            
            // C6~B6
            5'd14:   tone = NM1 << 2;
            5'd15:   tone = NM2 << 2;
            5'd16:   tone = NM3 << 2;
            5'd17:   tone = NM4 << 2;
            5'd18:   tone = NM5 << 2;
            5'd19:   tone = NM6 << 2;
            5'd20:   tone = NM7 << 2;
            
            // C7~B7
            5'd21:   tone = NM1 << 3;
            5'd22:   tone = NM2 << 3;
            5'd23:   tone = NM3 << 3;
            5'd24:   tone = NM4 << 3;
            5'd25:   tone = NM5 << 3;
            5'd26:   tone = NM6 << 3;
            5'd27:   tone = NM7 << 3;
            
            5'd28:   tone = NM1 << 4;
            default:    tone = NM0; 
        endcase
    end
    
endmodule

