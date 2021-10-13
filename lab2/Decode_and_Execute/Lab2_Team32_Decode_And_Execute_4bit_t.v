`timescale 1ns/1ps

module Decode_And_Execute_t;

reg [3:0] rs = 4'b0000, rt = 4'b0000;
reg [2:0] sel = 3'b000;
//reg cin = 0;
wire [3:0] rd;

Decode_And_Execute d1(
    .rs(rs), 
    .rt(rt), 
    .sel(sel), 
    .rd(rd)
);
    
initial begin
    repeat(8)begin
        repeat(2 ** 8)begin
            #1 {rs, rt} = {rs, rt} + 4'b0001;
            #1 
            //$display("%b %b %b",rs, rt, rd);
            case (sel)
                3'b000:
                    if(rs + rt != rd)begin
                        $display("error occurs at add rs=%b rt=%b rd=%b", rs, rt, rd);
                    end
                3'b001:
                    if(rs - rt != rd)begin
                        $display("error occurs at sub rs=%b rt=%b rd=%b", rs, rt, rd);
                    end
                3'b010:
                    if((rs & rt) != rd)begin
                        $display("error occurs at bitwise_and rs=%b rt=%b rd=%b rs&rd=%b", rs, rt, rd, rs&rd);
                    end
                3'b011:
                    if((rs | rt) != rd)begin
                        $display("error occurs at bitwise_or rs=%b rt=%b rd=%b rs|rd=%b", rs, rt, rd, rs|rd);
                    end
                3'b100:
                    if(rd != {rs[2:0], rs[3]})begin
                        $display("error occurs at rs L_shift rs=%b rd=%b", rs, rd);
                    end
                3'b101:
                    if(rd != {rt[3], rt[3:1]})begin
                        $display("error occurs at rt R_shift rt=%b rd=%b", rt, rd);
                    end
                3'b110:
                    if(rd != {3'b111, rs == rt})begin
                        $display("error occurs at equal rs=%b rt=%b rd=%b", rs, rt, rd);
                    end
                3'b111:
                    if(rd != {3'b101, rs > rt})begin
                        $display("error occurs at grater_than rs=%b rt=%b rd=%b", rs, rt, rd);
                    end
            endcase
        end
        sel = sel + 3'b001;
    end
    #1 $finish;
end

endmodule