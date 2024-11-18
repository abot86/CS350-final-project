module clock_25M_50k (
    input clk_in,     // 25 MHz input clock
    input reset,      // Asynchronous reset signal
    output reg clk_out // 50 kHz output clock
);

    // Divide factor: 500 (25 MHz / 50 kHz)
    localparam DIV_FACTOR = 500;

    reg [9:0] counter; // Counter to divide the clock

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIV_FACTOR / 2) - 1) begin
                clk_out <= ~clk_out; // Toggle the output clock
                counter <= 0;        // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end

endmodule
