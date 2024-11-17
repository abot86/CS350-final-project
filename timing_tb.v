`timescale 1ns / 1ps

module timing_tb;
    reg clock, reset;

    Wrapper cpu(.clock(clock), .reset(reset));

    always
        #10 clock <= ~clock;

    initial begin
        reset <= 0;
    end
endmodule