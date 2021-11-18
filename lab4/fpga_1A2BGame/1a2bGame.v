`timescale 1ns / 1ps

module top(clk, rst_n, button, enter, start, chosenOut, control, fixedRandom);
    input clk, rst_n;
    input [3:0] button;
    input enter, start;
    output [7:0] chosenOut;
    output [3:0] control;
    output [15:0] fixedRandom;
    
    wire [31:0] out;
    reg [2:0] state, next_state;
    reg start_in, next_start_in, start_rs, next_start_rs; 
    wire finish_in, finish_rs;
    reg [15:0] fixedRandom, next_fixed;
    reg [3:0] in3, in2, in1, in0;
    reg [3:0] next_in3, next_in2, next_in1, next_in0;
    
    wire [15:0] guesses;
    wire [15:0] randoms;
    wire [3:0] num_A, num_B;
    
    wire reset_debounce, start_debounce, enter_debounce;
    wire reset_onepluse, start_onepluse, enter_onepluse;
    wire clk_27, clk_19, clk_100;
    
    parameter INIT = 3'd0;
    //parameter GEN_RAN = 3'd1;
    parameter GET_IN = 3'd2;
    parameter GET_RS = 3'd3;
    parameter SHOW = 3'd4;
    // parameter F0 = 3'd4;
    
    /*Many_To_One_LFSR generate_random(
        .clk(clk), 
        .rst_n(reset_onepluse), 
        .data(randoms)
    );*/
    random_generator generate_random(
         .clk(clk), 
         .rst_n(reset_onepluse), 
         .data(randoms)
    );


    
    getInput get_in(
        .clk(clk_19), 
        .start(start_in),  //
        .button(button), 
        .enter(enter_onepluse), 
        .guesses(guesses), 
        .finish(finish_in)
    );
    
    getResult get_rs(
        .clk(clk), 
        .start(start_rs), 
        .randoms(fixedRandom), 
        .guesses(guesses), 
        .num_A(num_A),
        .num_B(num_B),
        .finish(finish_rs)
    );
    
    transToSegment toSegment3(in3, out[31:24]);
    transToSegment toSegment2(in2, out[23:16]);
    transToSegment toSegment1(in1, out[15:8]);
    transToSegment toSegment0(in0, out[7:0]);
    
    // debounce, onepulse, setting frequency of clock
    clock_div_27 clk27(clk, clk_27);
    clock_div_19 clk19(clk, clk_19);
    clock_div_100 clk100(clk, clk_100);
    
    debounce debounce_reset(reset_debounce, rst_n, clk_27);
    onepulse onepulse_reset(reset_debounce, clk_19, reset_onepluse);
    
    debounce debounce_start(start_debounce, start, clk_27);
    onepulse onpluse_start(start_debounce, clk_19, start_onepluse);
    
    debounce debounce_enter(enter_debounce, enter, clk_27);
    onepulse onpluse_enter(enter_debounce, clk_19, enter_onepluse);
    
    select7segment select_segment(out, clk_27, clk_100, start_in, control, chosenOut);
    
    // sequential circuit
    always @(posedge clk) begin
        if(reset_onepluse == 1'b1) begin
            state <= INIT;
            fixedRandom <= next_fixed;
            start_in <= next_start_in;
            start_rs <= next_start_rs;
            in3 <= next_in3;
            in2 <= next_in2;
            in1 <= next_in1;
            in0 <= next_in0;
        end
        else begin
            state <= next_state;
            fixedRandom <= next_fixed;
            start_in <= next_start_in;
            start_rs <= next_start_rs;
            in3 <= next_in3;
            in2 <= next_in2;
            in1 <= next_in1;
            in0 <= next_in0;
        end
    end
    
    // combinational circuit
    always @(*) begin
        case(state)
            INIT: begin
                next_state = (start_onepluse == 1'b1)? GET_IN : state;
                next_fixed = randoms;
                next_start_in = 1'b1;
                next_start_rs = 1'b1;
                next_in3 = 4'h1;
                next_in2 = 4'ha;
                next_in1 = 4'h2;
                next_in0 = 4'hb;
            end  
            GET_IN: begin
                next_state = (finish_in == 1'b1)? GET_RS : state;
                next_fixed = fixedRandom;
                next_start_in = 1'b0;
                next_start_rs = 1'b1;
                //next_start_rs = (finish_in == 1'b1)? 1'b1 : 1'b0;
                next_in3 = guesses[15:12];
                next_in2 = guesses[11:8];
                next_in1 = guesses[7:4];
                next_in0 = guesses[3:0];
            end  
            GET_RS: begin
                next_state = (finish_rs == 1'b1)? SHOW : state;
                next_fixed = fixedRandom;
                next_start_in = 1'b1;
                next_start_rs = 1'b0;
//                next_in3 = in3;
//                next_in2 = in2;
//                next_in1 = in1;
//                next_in0 = in0;
                next_in3 = num_A;
                next_in2 = 4'ha;
                next_in1 = num_B;
                next_in0 = 4'hb;
            end
            default: begin
                next_state = (enter_onepluse == 1'b1) ? (in3 === 4'd4 ? INIT : GET_IN) :state;
                next_fixed = fixedRandom;
                //next_start_in = (enter_onepluse == 1'b1)? ((num_A !== 4'd4)? 1'b1 : 1'b1) : 1'b0;
                //next_start_in = (enter_onepluse == 1'b1)? 1'b1 : 1'b0;
                next_start_in = 1'b1;
                next_start_rs = 1'b1;
//                next_in3 = num_A;
//                next_in2 = 4'ha;
//                next_in1 = num_B;
//                next_in0 = 4'hb;
                next_in3 = in3;
                next_in2 = in2;
                next_in1 = in1;
                next_in0 = in0;
            end
        endcase
    end

endmodule

// select 7 segment
module select7segment(in, clk_27, clk_100, start_in, control, out);
    input [31:0] in;
    input clk_27, clk_100, start_in;
    output reg [3:0] control;
    output reg [7:0] out;
    
    reg [1:0] counter, next_counter;
    reg display0_en;
    
    always @(posedge clk_27)begin
        counter <= next_counter;
    end

    always @(posedge clk_100) begin
        display0_en <= ~display0_en;
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
            // first bits
            control = 4'b1110;
            //out = in[7:0];
            if(start_in == 1'b1)
                out = in[7:0];
            else
                out = (display0_en == 1'b1) ? in[7:0] : 8'b11111111;
    
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
            /*4'hC: out = 8'b01100011;
            4'hD: out = 8'b10000101;
            4'hE: out = 8'b01100001;
            4'hF: out = 8'b01110001;*/
            default: out = 8'b11111111;
        endcase
    
    end
endmodule

// get input
module getInput(clk, start, button, enter, guesses, finish);
    input clk;
    input start;
    input [3:0] button;
    input enter;
    output reg [15:0] guesses;
    output finish;
    
    reg [2:0] state, next_state;
    reg [15:0] next_guesses;
    
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;
    parameter F0 = 3'd5;
    
    always @(posedge clk) begin
        if(start == 1'b1) begin
            state <= S0;
            guesses <= {4'd0, 4'd0, 4'd0, 4'd0};
        end
        else begin
            state <= next_state;
            guesses <= next_guesses;
        end
    end
    
    always @(*) begin
        case(state)
            S0: begin //reset state
                next_state = (start == 1'b0)? S1 : state;
                next_guesses = 16'd0;
                //next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses; 
            end
            S1: begin
                next_state = (enter == 1'b1)? S2 : state;
                next_guesses = (enter == 1'b1)? {guesses[7:0], button[3:0], button[3:0]} : {guesses[15:4], button[3:0]};
                //next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses;
            end
            S2: begin
                next_state = (enter == 1'b1)? S3 : state;
                next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : {guesses[15:4], button[3:0]};
                //next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses;
            end
            S3: begin
                next_state = (enter == 1'b1)? S4 : state;
                next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : {guesses[15:4], button[3:0]};
                //next_guesses = (enter == 1'b1)? {guesses[11:0], button[3:0]} : guesses;
            end
            S4: begin
                next_state = (enter == 1'b1)? F0 : state;
                next_guesses = (enter == 1'b1)? {guesses[15:0]} : {guesses[15:4], button[3:0]};
                //next_guesses = guesses;
            end
            default: begin
                next_state = state;
                next_guesses = guesses;
            end
        endcase
    end
    
    assign finish = (state == F0) ? 1'b1 : 1'b0;
endmodule

// get result
module getResult(clk, start, randoms, guesses, num_A, num_B, finish);
    input clk;
    input start;
    input [15:0] randoms, guesses;
    output reg [3:0]num_A, num_B; 
    output finish;
    
    wire [3:0]random[3:0];
    wire [3:0]guess[3:0];
    
    // assign {random[3], random[2], random[1], random[0]} = randoms;
    assign random[3] = randoms[15:12];
    assign random[2] = randoms[11:8];
    assign random[1] = randoms[7:4];
    assign random[0] = randoms[3:0];
    
    // assign {guess[3], guess[2], guess[1], guess[0]} = guesses;
    assign guess[3] = guesses[15:12];
    assign guess[2] = guesses[11:8];
    assign guess[1] = guesses[7:4];
    assign guess[0] = guesses[3:0];
    reg [2:0]state, next_state;
    reg [3:0]next_numA, next_numB;
    
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter F0 = 3'd4;
    
    always @(posedge clk) begin
        if(start == 1'b1) begin
            state <= S0;
            num_A <= 1'b0;
            num_B <= 1'b0;
        end
        else begin
            state <= next_state;
            num_A <= next_numA;
            num_B <= next_numB;
        end
    end
    
    always @(*) begin
        case(state)
            S0: begin
                next_numA = num_A + (random[3] == guesses[15:12]? 1'b1 : 1'b0);
                next_numB = num_B + (((random[3] === guess[0]) || (random[3] === guess[1]) || (random[3] === guess[2]))? 1'b1 : 1'b0);
                next_state = S1;
                end
            S1: begin
                next_numA = num_A + (random[2] == guesses[11:8]? 1'b1 : 1'b0);
                next_numB = num_B + (((random[2] === guess[0]) || (random[2] === guess[1]) || (random[2] === guess[3]))? 1'b1 : 1'b0);
                next_state = S2;
                end
            S2: begin
                next_numA = num_A + (random[1] == guesses[7:4]? 1'b1 : 1'b0);
                next_numB = num_B + (((random[1] === guess[0]) || (random[1] === guess[2]) || (random[1] === guess[3]))? 1'b1 : 1'b0);        
                next_state = S3;
                end
            S3: begin
                next_numA = num_A + (random[0] == guesses[3:0]? 1'b1 : 1'b0);
                next_numB = num_B + (((random[0] === guess[1]) || (random[0] === guess[2]) || (random[0] === guess[3]))? 1'b1 : 1'b0);
                next_state = F0;
                end
            default: begin
                next_numA = num_A; 
                next_numB = num_B;
                next_state = F0;
            end
        
        endcase
    end
    
    assign finish = (state == F0 ? 1'b1 : 1'b0);
endmodule

// generate random numbers

module random_generator(clk, rst_n, data);
    input clk;
    input rst_n;
    output reg [15:0] data;

    reg [15:0] next_data;
    //reg [3:0] next_out_0, next_out_1, next_out_2, next_out_3;
    wire [15:0] out;
    reg [15:0] next_out;

    Many_To_One_LFSR many_2_one(clk, rst_n, out);

    always @(posedge clk) begin
        data <= next_data;
    end

    always @(*) begin
        if(out[15:12] >= 4'd10)
            next_out[15:12] = out[15:12] - 4'd10;
        else
            next_out[15:12] = out[15:12];

        if(out[11:8] >= 4'd10)
            next_out[11:8] = out[11:8] - 4'd10;
        else
            next_out[11:8] = out[11:8];

        if(out[7:4] >= 4'd10)
            next_out[7:4] = out[7:4] - 4'd10;
        else
            next_out[7:4] = out[7:4];
        
        if(out[3:0] >= 4'd10)
            next_out[3:0] = out[3:0] - 4'd10;
        else
            next_out[3:0] = out[3:0];

        if((next_out[15:12] == next_out[11:8]) || (next_out[15:12] == next_out[7:4]) || (next_out[15:12] == next_out[3:0]) || (next_out[11:8] == next_out[7:4]) || (next_out[11:8] == next_out[3:0]) || (next_out[7:4] == next_out[3:0]))
            next_data = data;
        else
            next_data = next_out;
            
    end

endmodule

module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [15:0] out;
    
    //reg [15:0] out;
    wire [15:0] next_out;
    //reg [15:0] next_data;
    //wire in_DFF0;
    
    always @(posedge clk) begin
        if(rst_n == 1'b1) begin
            out <= 8'b1010110011100001;
            //data <= 16'b0;
        end
        else begin
            //out <= next_out;
            out <= next_out;
        end
    end
    
    assign next_out = {out[0], out[15] ^ out[0], out[14] ^ out[0], out[13] ^ out[0], out[12], out[11] ^ out[0], out[10:1]};

endmodule
/*
module Many_To_One_LFSR(clk, rst_n, data);
    input clk;
    input rst_n;
    output reg [15:0] data;
    
    reg [7:0] out;
    reg [7:0] next_out;
    reg [15:0] next_data;
    wire in_DFF0;
    
    always @(posedge clk) begin
        if(rst_n == 1'b0) begin
            out <= 8'b10111101;
            data <= 16'b0;
        end
        else begin
            out <= next_out;
            data <= next_data;
        end
    end
    
    assign in_DFF0 = out[7] ^ out[3] ^ out[2] ^ out[1]; 
    
    always @(*)begin
        next_out = {out[6:0], in_DFF0};
        next_data = {data[14:0], out[7]};
    end
endmodule*/

// clock_div_100
module clock_div_100(clk, slow_clk);
    input clk;
    output slow_clk;
    
    reg slow_clk;
    reg [30:0] counter;
    
    always @(posedge clk) begin
        if(counter < 100000000)
            counter <= counter + 1;
        else
            counter <= 0;
    end
    
    always @(posedge clk) begin
        if(counter < 50000000)
            slow_clk <= 1'b0;
        else
            slow_clk <= 1'b1;
    end


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