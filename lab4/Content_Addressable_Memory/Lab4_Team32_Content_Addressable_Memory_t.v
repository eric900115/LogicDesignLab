`timescale 1ns/1ps

module CAM_t;
reg clk = 1'b0;
reg ren = 1'b0;
reg wen = 1'b0;
reg [3:0] addr = 4'd0;
reg [7:0] din = 8'd0;
wire [3:0] dout;
wire hit;

integer i = 0;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Content_Addressable_Memory cam(
    .clk(clk),
    .ren(ren),
    .wen(wen),
    .din(din),
    .addr(addr),
    .dout(dout),
    .hit(hit)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Memory.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    for(i = 0; i < 16; i = i + 1) begin
        @(negedge clk) begin
        addr = i;
        din = i * 2;
        ren = 1'b0;
        wen = 1'b1; 
        end
    end
    for(i = 0; i < 16; i = i + 1) begin
        @(negedge clk) begin
        addr = 4'd0;
        din = i + 100;
        ren = 1'b1;
        wen = 1'b0; 
        end
    end
    
    
    for(i = 0; i < 16; i = i + 1) begin
        @(negedge clk) begin
        addr = i;
        din = i * 2;
        ren = 1'b0;
        wen = 1'b1; 
        end
    end
    @(negedge clk) begin
    addr = 4'd0;
    din = 8'b0;
    ren = 1'b1;
    wen = 1'b0; 
    end
    for(i = 1; i < 16; i = i + 1) begin
        @(negedge clk) begin
        if(hit === 1'b0) begin
            $display("hit error");
        end
        if(dout !== i - 1'b1) begin
            $display("address error %d %d",dout, i);
        end
        addr = 4'd0;
        din = i * 2;
        ren = 1'b1;
        wen = 1'b0; 
        end
    end
    
    for(i = 0; i < 16; i = i + 1) begin
        @(negedge clk) begin
        addr = i;
        din = 8'd100;
        ren = 1'b0;
        wen = 1'b1; 
        end
    end
    @(negedge clk) begin
        addr = 4'd0;
        din = 8'd100;
        ren = 1'b1;
        wen = 1'b0; 
    end
    for(i = 1; i < 16; i = i + 1) begin
        @(negedge clk) begin
        if(dout !== 4'hf)
            $display("error occurs at checking data in memory all the same");
        addr = 4'd0;
        din = 8'd100;
        ren = 1'b1;
        wen = 1'b0; 
        end
    end
    
    
    for(i = 0; i < 8; i = i + 1) begin
        @(negedge clk) begin
        addr = i;
        din = 8'd100;
        ren = 1'b0;
        wen = 1'b1; 
        end
    end
    for(i = 8; i < 16; i = i + 1) begin
        @(negedge clk) begin
        addr = i;
        din = 8'd50;
        ren = 1'b0;
        wen = 1'b1; 
        end
    end
    
    @(negedge clk) begin
        addr = 4'd0;
        din = 8'd100;
        ren = 1'b1;
        wen = 1'b1; 
    end
    for(i = 1; i < 16; i = i + 1) begin
        @(negedge clk) begin
        if(dout !== 4'd7)
            $display("error occurs at partial checking");
        addr = 4'd0;
        din = 8'd100;
        ren = 1'b1;
        wen = 1'b1; 
        end
    end
  
    $finish;
end

endmodule
