`timescale 1ns/1ps

module Exhausted_Testing(a, b, cin, error, done);
output [3:0] a, b;
output cin;
output error;
output done;

// input signal to the test instance.
reg [3:0] a = 4'b0000;
reg [3:0] b = 4'b0000;
reg cin = 1'b0;
reg error = 1'b0;
reg done = 1'b0;

// output from the test instance.
wire [3:0] sum;
wire cout;

// instantiate the test instance.
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    // design you test pattern here.
    // Remember to set the input pattern to the test instance every 5 nanasecond
    // Check the output and set the `error` signal accordingly 1 nanosecond after new input is set.
    // Also set the done signal to 1'b1 5 nanoseconds after the test is finished.
    // Example:
    // setting the input
    // a = 4'b0000;
    // b = 4'b0000;
    // check the output
    // #1
    // check_output;
    // #4
    // setting another input
    // a = 4'b0001;
    // b = 4'b0000;
    //.....
    // #4
    // The last input pattern
    // a = 4'b1111;
    // b = 4'b1111;
    // #1
    // check_output;
    // #4
    // setting the done signal
    // done = 1'b1;
    repeat(2 ** 8) begin
        #1
        if(a + b + cin != {cout, sum}) begin
           error = 1'b1; 
        end
        else begin
            error = 1'b0;
        end
        #4
        {a, b} = {a, b} + 4'b0001;
    end
    cin = 1'b1;
    repeat(2 ** 8) begin
        #1
        if(a + b + cin != {cout, sum}) begin
           error = 1'b1; 
        end
        else begin
            error = 1'b0;
        end
        #4
        {a, b} = {a, b} + 4'b0001;
    end
    #1 error = 1'b0;
    #4 done = 1'b1;
    #5 $finish;
end

endmodule