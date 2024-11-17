module adc_top_level (
    input wire CLK100MHZ,      // FPGA clock
    input wire reset,          // Reset signal
    input wire eoc,            // End-of-conversion signal from ADC0808
    input wire [7:0] data_in,  // Digital output from ADC0808
    output wire ale,           // Address latch enable for ADC0808
    output wire start,         // Start conversion signal for ADC0808
    output wire oe,            // Output enable signal for ADC0808
    output wire [2:0] addr,    // Address lines to select analog input channel
    output wire [6:0] seg,     // 7-segment display segments
    output wire [3:0] an       // 7-segment display digit select
);

    // Internal signals
    wire [7:0] adc_value;          // Captured ADC output
    wire data_ready;               // Signal indicating ADC data is ready
    wire [3:0] hundreds, tens, ones; // BCD outputs

    // Instantiate the ADC interface
    adc_interface adc_intf (
        .CLK100MHZ(CLK100MHZ),
        .reset(reset),
        .eoc(eoc),
        .data_in(data_in),
        .ale(ale),
        .start(start),
        .oe(oe),
        .addr(addr),
        .data_out(adc_value)
    );

    // Instantiate the Binary-to-BCD converter
    binary_to_bcd bin_to_bcd (
        .binary_in(adc_value),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    // Instantiate the 7-segment display multiplexer
    seven_segment_multiplexer seg_mux (
        .clk(CLK100MHZ),
        .reset(reset),
        .digit0(ones),      // Least significant digit
        .digit1(tens),
        .digit2(hundreds),  // Most significant digit
        .digit3(4'b0000),   // Unused digit (can be set to zero)
        .seg(seg),
        .an(an)
    );

endmodule
