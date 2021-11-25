`timescale 1ns/1ps

module top_module(clk, rst_n, insert_5, insert_10, insert_50, cancel, display, digit, PS2_DATA, PS2_CLK, LED);
input clk, rst_n;
input insert_5, insert_10, insert_50, cancel;
output [7:0] display;
output [3:0] digit;
output [3:0] LED;
inout wire PS2_DATA;
inout wire PS2_CLK;

wire clk_19, clk_27, clk_100;
wire [6:0] coin;
wire reset_debounce, reset_onepluse;
wire cancel_debounce, cancel_onepluse;
wire insert_5_debounce, insert_5_onepulse;
wire insert_10_debounce, insert_10_onepulse;
wire insert_50_debounce, insert_50_onepulse;
wire [511:0] key_down;
wire [8:0] last_change;
wire been_ready;
reg select_a, select_s, select_d, select_f;

parameter KEY_CODE_A = 9'h1C;
parameter KEY_CODE_S = 9'h1B;
parameter KEY_CODE_D = 9'h23;
parameter KEY_CODE_F = 9'h2B;

// debounce, onepulse, setting frequency of clock
clock_div_27 clk27(clk, clk_27);
clock_div_19 clk19(clk, clk_19);
clock_div_100 clk100(clk, clk_100);

vending_machine vending(.clk(clk), .rst_n(reset_onepluse), .coin(coin), 
                        .insert_coin_5(insert_5_onepulse), 
                        .insert_coin_10(insert_10_onepulse), 
                        .insert_coin_50(insert_50_onepulse), 
                        .cancel(cancel_onepluse), 
                        .select_a(select_a), 
                        .select_s(select_s), 
                        .select_d(select_d), 
                        .select_f(select_f),
                        .clk_100(clk_100),
                        .available_a(LED[0]), 
                        .available_s(LED[1]), 
                        .available_d(LED[2]), 
                        .available_f(LED[3]));

debounce debounce_reset(reset_debounce, rst_n, clk_27);
onepulse onepulse_reset(reset_debounce, clk, reset_onepluse);

debounce debounce_cancel(cancel_debounce, cancel, clk_27);
onepulse onepulse_cancel(cancel_debounce, clk, cancel_onepluse);

debounce debounce_insert_5(insert_5_debounce, insert_5, clk_27);
onepulse onepulse_insert_5(insert_5_debounce, clk, insert_5_onepulse);
    
debounce debounce_insert_10(insert_10_debounce, insert_10, clk_27);
onepulse onpluse_insert_10(insert_10_debounce, clk, insert_10_onepulse);
    
debounce debounce_insert_50(insert_50_debounce, insert_50, clk_27);
onepulse onpluse_insert_50(insert_50_debounce, clk, insert_50_onepulse);

segment_display seg({9'd0, coin}, clk, clk_19, clk_27, display, digit);

KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

always @(posedge clk) begin
    if (been_ready && key_down[last_change] == 1'b1) begin
        select_a <= (last_change == KEY_CODE_A) ? 1'b1 : 1'b0;
        select_s <= (last_change == KEY_CODE_S) ? 1'b1 : 1'b0;
        select_d <= (last_change == KEY_CODE_D) ? 1'b1 : 1'b0;
        select_f <= (last_change == KEY_CODE_F) ? 1'b1 : 1'b0;
    end
    else begin
        select_a <= 1'b0;
        select_s <= 1'b0; 
        select_d <= 1'b0; 
        select_f <= 1'b0;
    end
end

endmodule

module vending_machine(clk, rst_n, coin, insert_coin_5, insert_coin_10,  insert_coin_50, 
                        cancel, select_a, select_s, select_d, select_f, clk_100,
                        available_a, available_s, available_d, available_f);
input rst_n, clk, clk_100;
input insert_coin_10, insert_coin_5, insert_coin_50;
input cancel;
input select_a, select_s, select_d, select_f;
output reg [6:0] coin;
output available_a, available_s, available_d, available_f;

parameter Insert = 1'b0;
parameter Return = 1'b1;

reg state, next_state;
reg sel, next_sel;
reg [6:0] next_coin;

assign available_a = (coin >= 7'd75 && state == Insert) ? 1'b1 : 1'b0;
assign available_s = (coin >= 7'd50 && state == Insert) ? 1'b1 : 1'b0;
assign available_d = (coin >= 7'd30 && state == Insert) ? 1'b1 : 1'b0;
assign available_f = (coin >= 7'd25 && state == Insert) ? 1'b1 : 1'b0;

//sequential circuit
always @(posedge clk) begin
    if(rst_n == 1'b1) begin
        state <= Insert;
    end
    else begin
        state <= next_state;
    end
end

always @(posedge clk) begin
    if(rst_n == 1'b1) begin
        coin <= 7'd0;
    end
    else begin
        if(state == Insert)
            coin <= next_coin;
        else begin
            coin <= next_coin;
        end
    end   
end

//combinational circuit for coin
always @(*) begin
    case(state)
        Insert: begin
            case({insert_coin_10, insert_coin_5, insert_coin_50, select_a, select_s, select_d, select_f, cancel})
                8'b10000000: begin
                    if(coin <= 7'd100) begin
                        if(coin >= 7'd90)
                            next_coin = 7'd100;
                        else
                            next_coin = coin + 7'd10;
                    end
                    else begin
                        next_coin = coin;
                    end
                end
                8'b01000000: begin
                    if(coin <= 7'd100) begin
                        if(coin >= 7'd95)
                            next_coin = 7'd100;
                        else
                            next_coin = coin + 7'd5;
                    end
                    else begin
                        next_coin = coin;
                    end
                end
                8'b00100000: begin
                    if(coin <= 7'd100) begin
                        if(coin >= 7'd50)
                            next_coin = 7'd100;
                        else
                            next_coin = coin + 7'd50;
                    end
                    else begin
                        next_coin = coin;
                    end
                end
                8'b00010000: begin
                    if(coin >= 7'd75)
                        next_coin = coin - 7'd75;
                    else
                        next_coin = coin;
                end
                8'b00001000: begin
                    if(coin >= 7'd50)
                        next_coin = coin - 7'd50;
                    else
                        next_coin = coin;
                end
                8'b00000100: begin
                    if(coin >= 7'd30)
                        next_coin = coin - 7'd30;
                    else
                        next_coin = coin;
                end
                8'b00000010: begin
                    if(coin >= 7'd25)
                        next_coin = coin - 7'd25;
                    else
                        next_coin = coin;
                end
                8'b00000001: begin
                    next_coin = coin;
                end
                default: begin
                    next_coin = coin;
                end
            endcase
        end
        Return: begin
            if(coin >= 7'd5) begin
                if(clk_100 == 1'b1)
                    next_coin = coin - 7'd5;
                else
                    next_coin = coin;
            end
            else begin
                next_coin = coin;
            end
        end
    endcase
end

//combinational circuit for state
always @(*) begin
    case(state)
        Insert: begin
            case({select_a, select_s, select_d, select_f, cancel})
                5'b10000: begin
                    if(coin >= 7'd75)
                        next_state = Return;
                    else
                        next_state = Insert;
                end
                5'b01000: begin
                    if(coin >= 7'd50)
                        next_state = Return;
                    else
                        next_state = Insert;
                end
                5'b00100: begin
                    if(coin >= 7'd30)
                        next_state = Return;
                    else
                        next_state = Insert;
                end
                5'b00010: begin
                    if(coin >= 7'd25)
                        next_state = Return;
                    else
                        next_state = Insert;
                end
                5'b00001: begin
                    next_state = Return;
                end
                default: begin
                    next_state = Insert;
                end
            endcase
        end
        Return: begin
            if(coin >= 7'd5) begin
                next_state = Return;
            end
            else begin
                next_state = Insert;
            end
        end
    endcase
end

endmodule

module segment_display(data, clk, clk_27, clk_100, chosenOut, control);
input [15:0] data;
input clk, clk_27, clk_100;
output [7:0] chosenOut;
output [3:0] control;

reg [15:0] in;
wire [31:0] out;
reg [15:0] seg0;

transToSegment toSegment3(in[15:12], out[31:24]);
transToSegment toSegment2(in[11:8], out[23:16]);
transToSegment toSegment1(in[7:4], out[15:8]);
transToSegment toSegment0(in[3:0], out[7:0]);

select7segment select_segment(out, clk_27, clk_100, control, chosenOut);

always @(*) begin
    if(data < 16'd10) begin
        in = {4'hC, 4'hC, 4'hC, data[3:0]};
    end
    else if(data >= 16'd10 && data < 16'd20) begin
        seg0 = data - 16'd10;
        in = {4'hC, 4'hC, 4'd1, seg0[3:0]};
    end
    else if(data >= 16'd20 && data < 16'd30) begin
        seg0 = data - 16'd20;
        in = {4'hC, 4'hC, 4'd2, seg0[3:0]};
    end
    else if(data >= 16'd30 && data < 16'd40) begin
        seg0 = data - 16'd30;
        in = {4'hC, 4'hC, 4'd3, seg0[3:0]};
    end
    else if(data >= 16'd40 && data < 16'd50) begin
        seg0 = data - 16'd40;
        in = {4'hC, 4'hC, 4'd4, seg0[3:0]};
    end
    else if(data >= 16'd50 && data < 16'd60) begin
        seg0 = data - 16'd50;
        in = {4'hC, 4'hC, 4'd5, seg0[3:0]};
    end
    else if(data >= 16'd60 && data < 16'd70) begin
        seg0 = data - 16'd60;
        in = {4'hC, 4'hC, 4'd6, seg0[3:0]};
    end
    else if(data >= 16'd70 && data < 16'd80) begin
        seg0 = data - 16'd70;
        in = {4'hC, 4'hC, 4'd7, seg0[3:0]};
    end
    else if(data >= 16'd80 && data < 16'd90) begin
        seg0 = data - 16'd80;
        in = {4'hC, 4'hC, 4'd8, seg0[3:0]};
    end
    else if(data >= 16'd90 && data < 16'd100) begin
        seg0 = data - 16'd90;
        in = {4'hC, 4'hC, 4'd9, seg0[3:0]};
    end
    else if(data >= 16'd100 && data < 16'd110) begin
        seg0 = data - 16'd100;
        in = {4'hC, 4'd1, 4'd0, seg0[3:0]};
    end
    else if(data >= 16'd110 && data < 16'd120) begin
        seg0 = data - 16'd110;
        in = {4'hC, 4'd1, 4'd1, seg0[3:0]};
    end
    else begin
        seg0 = data - 16'd120;
        in = {4'hC, 4'd1, 4'd2, seg0[3:0]};
    end
end

endmodule

// select 7 segment
module select7segment(in, clk_27, clk_100, control, out);
    input [31:0] in;
    input clk_27, clk_100;
    output reg [3:0] control;
    output reg [7:0] out;
    
    reg [1:0] counter, next_counter;
    
    always @(posedge clk_27)begin
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
    
    always @(*)begin
        case(counter)
        2'b00:begin
            control = 4'b1110;
            out = in[7:0];   
        end
        2'b01:begin
            control = 4'b1101;
            out = in[15:8];
        end
        2'b10:begin
            control = 4'b1011;
            out = in[23:16];
        end
        default:begin
            control = 4'b0111;
            out = in[31:24];
        end
        
        endcase
    end	
endmodule

// transfer to segment
module transToSegment(in, out);
input [3:0] in;
output reg [7:0] out;
    
always @(*) begin
    
    case (in)
        4'h0: out = 8'b00000011;
        4'h1: out = 8'b10011111;
        4'h2: out = 8'b00100101;
        4'h3: out = 8'b00001101;
        4'h4: out = 8'b10011001;
        4'h5: out = 8'b01001001;
        4'h6: out = 8'b01000001;
        4'h7: out = 8'b00011111;
        4'h8: out = 8'b00000001;
        4'h9: out = 8'b00001001;
        4'hA: out = 8'b00010001;
        4'hB: out = 8'b11000001;
        default: out = 8'b11111111;
    endcase

end

endmodule


// clock_div_100
module clock_div_100(clk, slow_clk);
    input clk;
    output slow_clk;
    
    reg [30:0] counter;
    
    always @(posedge clk) begin
        if(counter <= 31'd100000000)
            counter <= counter + 31'd1;
        else
            counter <= 31'd0;
    end
    
    assign slow_clk = (counter === 31'd99999999) ? 1'b1 : 1'b0;

endmodule

// clock_div_27
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

// colck_div_19
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
    reg [7:0] DFF;
    
    always @(posedge clk)
        begin
            DFF[7:1] <= DFF[6:0];
            DFF[0] <= pb;
        end
    assign pb_debounced = ((DFF == 8'b11111111) ? 1'b1 : 1'b0);
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