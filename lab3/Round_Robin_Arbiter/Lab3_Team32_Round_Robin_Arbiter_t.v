`timescale 1ns / 1ps

module Round_Robin;
reg clk = 0;
reg rst_n = 1'b0;
reg [3:0] wen = 4'b0;
reg [7:0] a, b, c, d;
wire [7:0] dout;
wire valid;
integer i;
wire [1:0] state;

Round_Robin_Arbiter m0(clk, rst_n, wen, a, b, c, d, dout, valid);

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;


//uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
/*initial begin
     $fsdbDumpfile("Clock_Divider.fsdb");
     $fsdbDumpvars;
end
*/

initial begin
    @ (negedge clk)begin
    rst_n = 1'b1;
    wen = 4'b1111;
    a = 8'd87;
    b = 8'd56;
    c = 8'd9;
    d = 8'd13;
    end

    @ (negedge clk)begin
    wen = 4'b1000;
    //a = 7'd87;
    //b = 7'd56;
    //c = 7'd9;
    d = 8'd85;
    end

    @ (negedge clk)begin
    wen = 4'b0100;
    //a = 7'd87;
    //b = 7'd56;
    c = 8'd139;
    //d = 7'd13;
    end

    @ (negedge clk)begin
    wen = 4'b0000;
    //a = 7'd87;
    //b = 7'd56;
    //c = 7'd9;
    //d = 7'd13;
    end

    @ (negedge clk)begin
    wen = 4'b0000;
    //a = 7'd87;
    //b = 7'd56;
    //c = 7'd9;
    //d = 7'd13;
    end

    @ (negedge clk)begin
    wen = 4'b0000;
    //a = 7'd87;
    //b = 7'd56;
    //c = 7'd9;
    //d = 7'd13;
    end
   

    @ (negedge clk)begin
    wen = 4'b0001;
    a = 8'd51;
    //b = 7'd56;
    //c = 7'd9;
    //d = 7'd13;
    end

    @ (negedge clk)begin
    wen = 4'b0000;
    //a = 7'd87;
    //b = 7'd56;
    //c = 7'd9;
    //d = 7'd13;
    end    

    @ (negedge clk)begin
    wen = 4'b0000;
    //a = 7'd87;
    //b = 7'd56;
    //c = 7'd9;
    //d = 7'd13;
    end    
   /* @ (negedge clk)
    rst_n = 1'b0;

    //FIFOA_Write & Read at the same time
    @ (negedge clk)begin
    rst_n = 1'b1;
    wen = 4'b1111;
    a = 8'd87;
    b = 8'd56;
    c = 8'd9;
    d = 8'd13;
    end

    //FIFOB_Write & Read at the same time
    @ (negedge clk)begin
    wen = 4'b1000;
    b = 7'd56;
    d = 8'd85;
    end

    //FIFOC_Write & Read at the same time
    @ (negedge clk)begin
    wen = 4'b0101;
    a = 8'd95;
    c = 8'd139;
    end

    //FIFOD_Write & Read at the same time
    @ (negedge clk)begin
    wen = 4'b1001;
    a = 8'd100;
    d = 7'd13;
    end


    //ALL FIFO WILL NOT READ and WRITE at the same time
    for(i = 0 ; i < 30; i = i + 1)begin
        @ (negedge clk)begin
            wen = {$random}%16;
            b = b + i;
            d = d + i;
        end
        @ (negedge clk)begin
            wen = 4'b0101;
            c = c + i;
            a = a + i;
        end
        @ (negedge clk)begin
            wen = 4'b0010;
            b = b + i;
        end
        @ (negedge clk)begin
            wen = 4'b0011;
            b = b + i;
            a = a + i;
        end
    end

*/
    #1 $finish;
end

endmodule
