module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    output trig,
    output left_motor,
    output reg [1:0]left,
    output right_motor,
    output reg [1:0]right,
    output left_signal_light,
    output right_signal_light,
    output mid_signal_light,
    input EN_Stop
);

    wire Rst_n, rst_pb, stop;
    wire [2:0] state;

    parameter go_straight = 3'd0;
    parameter turn_left = 3'd1;
    parameter turn_strong_left = 3'd2;
    parameter turn_peak_left = 3'd3;
    parameter turn_right = 3'd4;
    parameter turn_strong_right = 3'd5;
    parameter turn_peak_right = 3'd6;
    parameter stop_going = 3'd7;

    parameter motor_off = 2'b00;
    parameter forward = 2'b10;
    parameter backward = 2'b01;

    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);

    motor A(
        .clk(clk),
        .rst(Rst_n),
        .mode(state),
        .pwm({left_motor, right_motor})
    );

    sonic_top B(
        .clk(clk), 
        .rst(Rst_n), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .left_signal(left_signal), 
        .right_signal(right_signal),
        .mid_signal(mid_signal), 
        .state(state)
       );

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        if(stop && EN_Stop) 
            {left, right} = {motor_off, motor_off};
        else begin
        case(state)
            go_straight: begin
               {left, right} = {forward, forward};
            end
            turn_left: begin
                {left, right} = {forward, forward};
            end
            turn_strong_left: begin
                {left, right} = {motor_off, forward};
            end
            turn_peak_left: begin
                {left, right} = {backward, forward};
            end
            turn_right: begin
                {left, right} = {forward, forward};
            end
            turn_strong_right: begin
                {left, right} = {forward, motor_off};
            end
            turn_peak_right: begin
                {left, right} = {forward, backward};
            end
            default: begin
                {left, right} = {motor_off, motor_off};
            end
        endcase
        end
    end

    assign left_signal_light = left_signal;
    assign right_signal_light = right_signal;
    assign mid_signal_light = mid_signal;

endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

