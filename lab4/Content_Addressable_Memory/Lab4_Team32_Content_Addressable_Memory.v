`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;

reg [3:0] dout;
reg hit;
reg [15:0] pri;
reg [3:0] pri_addr;
reg [7:0] cam_data [15:0];
reg [15:0]found_match;
wire [2:0] en0, en1;
wire sel;
wire match;

priority_encoder pe0(pri[7:0], en0);
priority_encoder pe1(pri[15:8], en1);

always@(posedge clk) begin
    if(wen == 1'b0 && ren == 1'b0) begin
        dout <= 4'b0;
        hit <= 1'b0;
    end
    else if(wen == 1'b1 && ren == 1'b0) begin
        cam_data[addr] <= din;
        dout <= 4'b0;
        hit <= 1'b0;  
    end
    else begin  // ren == 1'b1
        if(match == 1'b1) begin
            dout <= pri_addr;
            hit <= 1'b1;
        end
        else begin
           dout <= 4'b0;
           hit <= 1'b0; 
        end
    end
end

assign sel = pri[8] | pri[9] | pri[10] | pri[11] | pri[12] | pri[13] | pri[14] | pri[15];
assign match = |pri;

always @(*) begin
    if(ren == 1'b1) begin
       pri[0] = (cam_data[0] === din)? 1'b1: 1'b0;
       pri[1] = (cam_data[1] === din)? 1'b1: 1'b0;
       pri[2] = (cam_data[2] === din)? 1'b1: 1'b0;
       pri[3] = (cam_data[3] === din)? 1'b1: 1'b0;
       pri[4] = (cam_data[4] === din)? 1'b1: 1'b0;
       pri[5] = (cam_data[5] === din)? 1'b1: 1'b0;
       pri[6] = (cam_data[6] === din)? 1'b1: 1'b0;
       pri[7] = (cam_data[7] === din)? 1'b1: 1'b0;
       pri[8] = (cam_data[8] === din)? 1'b1: 1'b0;
       pri[9] = (cam_data[9] === din)? 1'b1: 1'b0;
       pri[10] = (cam_data[10] === din)? 1'b1: 1'b0;
       pri[11] = (cam_data[11] === din)? 1'b1: 1'b0;
       pri[12] = (cam_data[12] === din)? 1'b1: 1'b0;
       pri[13] = (cam_data[13] === din)? 1'b1: 1'b0;
       pri[14] = (cam_data[14] === din)? 1'b1: 1'b0;
       pri[15] = (cam_data[15] === din)? 1'b1: 1'b0;
              
       if(sel == 1'b1) begin
           pri_addr = {1'b1, en1};
       end
       else begin
           pri_addr = {1'b0, en0};
       end

    end
    else begin
        pri = 16'b0;
        pri_addr = 4'b0;
    end
end
endmodule

module priority_encoder(data, out);
input [7:0] data;
output wire [2:0] out;

assign out[0] = (((~data[6]) & ((~data[4]) & (~data[2]) & data[1]) | ((~data[4]) & data[3]) | data[5]) | data[7]);
assign out[1] = ((~data[5]) & (~data[4]) & (data[2] | data[3]) | data[6] | data[7]);
assign out[2] = (data[4] | data[5] | data[6] | data[7]);

endmodule

