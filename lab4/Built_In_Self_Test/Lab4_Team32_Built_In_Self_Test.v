`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;

Many_To_One_LFSR LFSR(clk, rst_n, scan_in, scan_en);
Scan_Chain_Design scan_chain(clk, rst_n, scan_in, scan_en, scan_out);

endmodule

module Many_To_One_LFSR(clk, rst_n, data, scan_en);
input clk;
input rst_n, scan_en;
output data;

reg [7:0] out;
reg [7:0] next_out;

wire in_DFF0;

always @(posedge clk) begin
    if(rst_n == 1'b0)
        out <= 8'b10111101;
    else begin
        out <= next_out;
    end
end

assign in_DFF0 = out[7] ^ out[3] ^ out[2] ^ out[1]; 
assign data = out[7];

always @(*)begin
    //if(scan_en == 1'b1)
    next_out = {out[6:0], in_DFF0};
    //else
    //    next_out = out;
end

endmodule

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;

reg [7:0] DFF;
reg [3:0] a, b;
wire [7:0] p;

always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        DFF <= 8'b0;
    end
    else begin
        if (scan_en == 1'b1) begin
            DFF[7:1] <= DFF[6:0];
            DFF[0] <= scan_in;
        end    
        else begin
            DFF <= {p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]};//data
        end
    end
end

always @(*) begin
    b = {DFF[4], DFF[5], DFF[6], DFF[7]};
    a = {DFF[0], DFF[1], DFF[2], DFF[3]};
end

assign scan_out = DFF[7];

Multiplier_4bit Mul(a, b, p);

endmodule

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;

wire [3:0] w0, w1, w2, w3, w4, w5;

assign w0 = {1'b0, a[3] & b[0], a[2] & b[0], a[1] & b[0]};
assign w1 = {a[3] & b[1], a[2] & b[1], a[1] & b[1], a[0] & b[1]};
assign w2 = {a[3] & b[2], a[2] & b[2], a[1] & b[2], a[0] & b[2]};
assign w3 = {a[3] & b[3], a[2] & b[3], a[1] & b[3], a[0] & b[3]};

assign p[0] = a[0] & b[0];

adder adder0(w0, w1, 1'b0, {w4[2:0], p[1]}, w4[3]);
adder adder1(w2, w4, 1'b0, {w5[2:0], p[2]}, w5[3]);
adder adder2(w3, w5, 1'b0, p[6:3], p[7]);

endmodule

module adder(a, b, cin, sum, cout);
input [3:0] a, b;
input cin;
output [3:0] sum;
output cout;

assign {cout, sum} = a[3:0] + b[3:0] + cin;
    
endmodule