`timescale 1ns / 1ps



module DeMUX_t;

reg [3:0] in = 4'b0000;
reg [1:0] sel = 2'b0;
wire [3:0] a, b, c, d;

// test instance instantiation
Dmux_1x4_4bit d1(
    .in(in),
    .sel(sel),
    .a(a),
    .b(b),
    .c(c),
    .d(d)
);

//brute force
initial begin
    repeat (2 ** 3) begin
        #1 sel = sel + 2'b1;
        in = in + 4'b1;
    end
    #1 $finish;
end

endmodule
