module counter5k1(
    input clk25mhz,
    output reg pulse5khz
);

    // counter only stays on for 1 cycle - have it stay on for longer? 
    reg[12:0] counter = 0;
    always @(posedge clk25mhz) begin
        if (counter < CounterLimit) begin
            counter <= counter + 1;
            pulse5khz <= 1'b0;
        end
        else begin
            pulse5khz <= 1;
            counter <=0;
        end
    end

endmodule