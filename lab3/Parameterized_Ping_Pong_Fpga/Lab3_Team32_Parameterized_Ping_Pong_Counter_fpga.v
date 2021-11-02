`timescale 1ns/1ps

module FPGA_Display(SW, seg, seg_4, clk, flip, reset);
//SW[15]:Enable SW[14:11]:max SW[10:7]:min
input [15:7] SW; 
input clk, flip, reset;
output [7:0] seg;
output [3:0] seg_4;

wire reset_debounce, flip_debounce;
wire reset_onepluse, flip_onepluse;
wire clk_27, clk_19;
wire direction;
wire [3:0] num;

clock_div_27(clk, clk_27);
clock_div_19(clk, clk_19);

debounce debounce_reset(reset_debounce, reset, clk_27);
onepulse onepulse_reset(reset_debounce, clk_19, reset_onepluse);

debounce debounce_filp(flip_debounce, flip, clk_27);
onepulse onpluse_flip(flip_debounce, clk_19, flip_onepluse);

Parameterized_Ping_Pong_Counter ping_pong_counter(.clk(clk_19), .rst_n(reset), .enable(SW[15]), 
												.flip(fip_onepluse), .max(SW[14:11]), 
												.min(SW[10:7]), .direction(direction), .out(num));
												
select_seven_segment seven_segment_sel(seg, clk_27, seg_4, direct, num);

endmodule


module select_seven_segment(seg, clk, seg_4, direct, num);
input direct, clk;
input [3:0]num;
output [3:0] seg_4;
output [7:0] seg;


reg [1:0] counter, next_counter;
reg [3:0] data;
reg [3:0] seg_4;

always @(posedge clk)begin
	counter <= next_counter;
end

always @(*)begin
	case(counter)
	2'b00:begin
		next_counter = 2'b01;
	end
	2'b01:begin
		next_counter = 2'b10;
	end
	2'b10:begin
		next_counter = 2'b11;
	end
	default:begin
		next_counter = 2'b00;
	end
	
	endcase
end

Seven_Segment segment0(seg, data);


always @(*)begin
	case(counter)
	2'b00:begin
		seg_4 = 4'b1110;
		data = (direct == 1'b0)?4'b1010 :4'b1011;
		//da
	end
	2'b01:begin
		seg_4 = 4'b1101;
		data = (direct == 1'b0)?4'b1010 :4'b1011;
	end
	2'b10:begin
		seg_4 = 4'b1011;
		if(data >= 10)
			data = num - 4'b0001;
		else
			data = num;
	end
	default:begin
		seg_4 = 4'b0111;
		if(data >= 10)
			data = 4'b0001;
		else
			data = 4'b0000;
	end
	
	endcase
	
end	

endmodule


module Seven_Segment(seg, data);	
input [3:0] data;
output [7:0] seg;


reg [7:0] seg;

always @(*) begin

    case (data)
        4'h0: seg = 8'b00000011;
        4'h1: seg = 8'b10011111;
        4'h2: seg = 8'b00100101;
        4'h3: seg = 8'b00001101;
        4'h4: seg = 8'b10011001;
        4'h5: seg = 8'b01001001;
        4'h6: seg = 8'b01000001;
        4'h7: seg = 8'b00011111;
        4'h8: seg = 8'b00000001;
        4'h9: seg = 8'b00001001;
        4'hA: seg = 8'b00111011;
        4'hB: seg = 8'b11000111;
        default : seg = 8'b01100001;
    endcase

end
endmodule 


module clock_div_27(clk, slow_clk);
input clk;
output slow_clk;

reg slow_clk;
reg [26:0] counter;

always @(posedge clk) begin
    if(counter < 249999)
        counter <= counter + 1;
    else
        counter <= 0;
end

always @(posedge clk) begin
    if(counter < 125000)
        slow_clk <= 1'b0;
    else
        slow_clk <= 1'b1;
end


endmodule

module clock_div_19(clk, slow_clk);
input clk;
output slow_clk;

reg slow_clk;
reg [17:0] counter;

always @(posedge clk) begin
    if(counter < 25000)
        counter <= counter + 1;
    else
        counter <= 0;
end

always @(posedge clk) begin
    if(counter < 12500)
        slow_clk <= 1'b0;
    else
        slow_clk <= 1'b1;
end


endmodule


// debounce
module debounce(pb_debounced, pb, clk);
output pb_debounced;
input pb, clk;
reg [3:0] DFF;

always @(posedge clk)
    begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule


// one-pulse
module onepulse(pb_debounced, clk, pb_one_pulse);
input pb_debounced, clk;
output pb_one_pulse;
reg pb_one_pulse;
reg pb_debounced_delay;

always @(posedge clk)begin
    pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
    pb_debounced_delay <= pb_debounced;
end
endmodule


module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output direction;
output [3:0] out;
reg [3:0] out, nxt_out;
reg direction, nxt_dir;

// seq
always @(posedge clk)begin
    if(rst_n == 1'b0)begin
        out <= min;
        direction <= 1'b1;
    end
    else begin
        out <= nxt_out;
        direction <= nxt_dir;
    end
end

// enable == 1'b1, counter begins its operation
// comb
always @(*)begin
    if(enable == 1'b1) begin
        if(max > min) begin
            if(out <= max && out >= min) begin
                if(flip == 1'b1) begin
                    nxt_dir = !direction;
                end
                else begin
                    if(out == max)begin
                        nxt_dir = 1'b0;         // declined
                    end
                    else if(out == min)begin
                        nxt_dir = 1'b1;        // increased  
                    end
                    else begin
                        nxt_out = out;
                        nxt_dir = direction;
                    end
                end
                
                if(nxt_dir == 1'b1)begin
                    nxt_out = out + 4'b1;
                end
                else if(nxt_dir == 1'b0)begin
                    nxt_out = out - 4'b1;
                end
                
            end
            else begin
                nxt_out = out;
                nxt_dir = direction;
            end
        end
        else begin
            nxt_out = out;
            nxt_dir = direction;
        end
    end
    else begin
        nxt_out = out;
        nxt_dir = direction;
    end
end

/*
always @(*)begin
    if(enable == 1'b1) begin
            if(max > min) begin
                if(out <= max && out >= min) begin
                    
                end
                else    nxt_out = out;
            end
            else    nxt_out = out;
    end
    else    nxt_out = out;
end
*/
        
endmodule


