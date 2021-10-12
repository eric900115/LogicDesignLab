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
/*
// ADD d2(rs, rt, rd);
//ADD m0(rs, rt, I0);
//SUB m1(rs, rt, I1);
//Bitwise_AND m2(rs, rt, rd);
//Bitwise_OR m3(rs, rt, rd);
//rs_L_shift m4(rs, rd);
//rt_R_shift m5(rt, rd);
//Equality m6(rs, rt, rd);
Grater_than m7(rs, rt, rd);   */
    
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
/*
reg a = 1'b0 , b = 1'b0;
wire And, Or, Xor, Nand, Not, Nor, Xnor;

AND d0(a, b, And);
OR d1(a, b, Or);
XOR d2(a, b, Xor);
NAND d3(a, b, Nand);
NOT d4(a, Not);
NOR d5(a, b, Nor);
XNOR d6(a, b, Xnor);

initial begin

    repeat(4)begin
    
        #10 {a, b} = {a, b} +1'b1;
    end

end
*/
endmodule