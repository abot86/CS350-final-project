`timescale 1ns/100ps

module counter_tb;

    // Inputs
    reg clk;
    reg en;
    reg clr;

    // Outputs
    wire [3:0] q;

    counter COUNTER(q, clk, en, clr);

    // Generate a clock signal with a period of 10 time units
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        en = 0;
        clr = 1;

        // Wait for 20 ns and then release clear
        #20 clr = 0;

        // Enable the counter
        #10 en = 1;

        // Run the counter for some clock cycles
        #300;

        // Disable the counter
        en = 0;
        #50;

        // Clear the counter
        clr = 1;
        #10 clr = 0;

        // Run the counter again
        en = 1;
        #100;

        // Finish simulation
        $finish;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time: %0t | q = %b | clk = %b | en = %b | clr = %b", 
                $time, q, clk, en, clr);
    end

    initial begin
        $dumpfile("Wave1.vcd");
        $dumpvars(0, counter_tb);
    end

endmodule
