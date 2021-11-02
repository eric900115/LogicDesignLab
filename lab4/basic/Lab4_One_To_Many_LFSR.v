`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;

wire D3_XOR_D7, D7_XOR_D2, D7_XOR_D1;

always @(posedge clk) begin
    if(rst_n == 1'b0)
        out <= 8'b10111101;
    else begin
        out[7:5] <= out[6:4];
        out[4] <= D3_XOR_D7;
        out[3] <= D7_XOR_D2;
        out[2] <= D7_XOR_D1;
        out[1] <= out[0];
        out[0] <= out[7];
    end
end

assign D3_XOR_D7 = out[3] ^ out[7];
assign D7_XOR_D2 = out[2] ^ out[7];
assign D7_XOR_D1 = out[1] ^ out[7];


endmodule