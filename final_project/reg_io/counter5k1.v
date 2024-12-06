module counter5k1(
    input clk25mhz,
    output pulse
);
    
    // NOT 5000:1
    // THIS IS 500:1 but NAME IS NOT CHANGED
    
    // counter  stays on for 5 cycle 
    reg[12:0] counter = 0;
    reg[2:0] inner_counter = 0; // inner counter to count to 5 
    reg pulse5khz;

    assign pulse = pulse5khz;
    
    always @(posedge clk25mhz) begin
        if (counter < 500) begin
            counter <= counter + 1;
            if (inner_counter > 0) begin
                pulse5khz <= 1;
                inner_counter <= inner_counter + 1;
                if (inner_counter >= 5) inner_counter <= 0;
            end
            else pulse5khz <= 0;
        end
        else begin
            pulse5khz <= 1;
            inner_counter <= 1;
            counter <=0;
        end
    end

endmodule