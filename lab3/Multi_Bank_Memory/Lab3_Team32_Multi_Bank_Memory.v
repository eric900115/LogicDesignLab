`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output [7:0] dout;

wire [7:0] d[3:0];
reg [3:0] r_en, w_en;
reg [7:0] dout;
reg [1:0] out_addr;

Single_Bank_Memory Baank_0(clk, r_en[0], w_en[0], waddr[8:0], raddr[8:0], din, d[0]);
Single_Bank_Memory Baank_1(clk, r_en[1], w_en[1], waddr[8:0], raddr[8:0], din, d[1]);
Single_Bank_Memory Baank_2(clk, r_en[2], w_en[2], waddr[8:0], raddr[8:0], din, d[2]);
Single_Bank_Memory Baank_3(clk, r_en[3], w_en[3], waddr[8:0], raddr[8:0], din, d[3]);

always @(posedge clk) begin
    out_addr <= raddr[10:9];
end

always @(*) begin
    case (waddr[10:9])
        2'b00:begin
            w_en[0] = wen;
            w_en[3:1] = 3'b0;
        end
        2'b01:begin
            w_en[1] = wen;
            {w_en[3:2], w_en[0]} = 3'b0;
        end
        2'b10:begin
            w_en[2] = wen;
            {w_en[3], w_en[1:0]} = 3'b0;
        end
        default:begin
            w_en[3] = wen;
            w_en[2:0] = 3'b0;
        end 
    endcase 
end

always @(*) begin
    case (raddr[10:9])
        2'b00:begin
            r_en[0] = ren;
            r_en[3:1] = 3'b0;
        end
        2'b01:begin
            r_en[1] = ren;
            {r_en[3:2], r_en[0]} = 3'b0;
        end
        2'b10:begin
            r_en[2] = ren;
            {r_en[3], r_en[1:0]} = 3'b0;
        end
        default:begin
            r_en[3] = ren;
            r_en[2:0] = 3'b0;
        end 
    endcase 
end


//output combinational circuit
always @(*) begin
    case (out_addr)
        2'b00:begin
            dout = d[0];
        end
        2'b01:begin
            dout = d[1];
        end
        2'b10:begin
            dout = d[2];
        end
        default:begin
            dout = d[3];
        end
    endcase
end

endmodule


module Single_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [8:0] waddr;
input [8:0] raddr;
input [7:0] din;
output [7:0] dout;

// output [7:0] a, b, c, d;

wire [7:0] d_out [3:0];
//reg [7:0] d_in [3:0];
reg [1:0] out_addr;
reg [3:0] r_en, w_en;
reg [7:0] dout;


Memory memory_0(clk, r_en[0], w_en[0], waddr[6:0], raddr[6:0], din, d_out[0]);
Memory memory_1(clk, r_en[1], w_en[1], waddr[6:0], raddr[6:0], din, d_out[1]);
Memory memory_2(clk, r_en[2], w_en[2], waddr[6:0], raddr[6:0], din, d_out[2]);
Memory memory_3(clk, r_en[3], w_en[3], waddr[6:0], raddr[6:0], din, d_out[3]);

always @(posedge clk) begin
    out_addr <= raddr[8:7];
end


//write
always @(*) begin
    if(wen == 1'b1)begin
        case (waddr[8:7])
            2'b00:begin
                w_en[0] = wen;
                w_en[3:1] = 3'b0;
            end
            2'b01:begin
                w_en[1] = wen;
                {w_en[3:2], w_en[0]} = 3'b0;
            end
            2'b10:begin
                w_en[2] = wen;
                {w_en[3], w_en[1:0]} = 3'b0;
            end
            default:begin
                w_en[3] = wen;
                w_en[2:0] = 3'b0;
            end 
        endcase
    end
    else begin
        w_en = 4'b0;
    end

end

//read
always @(*) begin
    if(ren == 1'b1)begin
        case (raddr[8:7])
            2'b00:begin
                r_en[0] = ren;
                r_en[3:1] = 3'b0;
            end
            2'b01:begin
                r_en[1] = ren;
                {r_en[3:2], r_en[0]} = 3'b0;
            end
            2'b10:begin
                r_en[2] = ren;
                {r_en[3], r_en[1:0]} = 3'b0;
            end
            default:begin
                r_en[3] = ren;
                {r_en[2:0]} = 3'b0;
            end 
        endcase
    end
    else begin
        r_en = 4'b0000;
    end
end

always @(*) begin
    case (out_addr)
        2'b00:begin
            dout = d_out[0];
        end
        2'b01:begin
            dout = d_out[1];
        end
        2'b10:begin
            dout = d_out[2];
        end
        default:begin
            dout = d_out[3];
        end
    endcase
end


endmodule

module Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [6:0] waddr;
input [6:0] raddr;
input [7:0] din;
output [7:0] dout;

reg [7:0] memory [127:0];
reg [7:0] dout;

always @(posedge clk) begin

    if(wen == 1'b0 && ren == 1'b0) begin
        dout[7:0] <= 8'b00000000;
    end
    else if(wen == 1'b0 && ren == 1'b1) begin
        dout[7:0] <= memory[raddr];
    end
    else begin
        dout[7:0] <= 8'b00000000;
        memory[waddr] <= din[7:0];
    end

end

endmodule
