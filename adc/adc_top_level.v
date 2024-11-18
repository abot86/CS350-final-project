module adc_top_level (
    input wire CLK100MHZ,      // FPGA clock
    input wire reset,          // Reset signal
    inout wire [11:0] JA,            // \ NOT NECESSARILY INPUT, NEED TO CHANGE
    inout wire [11:0] JB,            // / 

    output wire [6:0] seg,     // 7-segment display segments
    output wire [3:0] an       // 7-segment display digit select
);
    // wire instantiation
    wire [7:0] data_in;                     // Digital output from ADC0808
    wire ale, start, oe;
    wire [2:0] addr;

    assign data_in = {JA[10:7], JA[4:1]};
    assign eoc = JA[3];       //
    assign ale =  JA[1];       // Address latch enable for ADC0808 
    assign start = JA[4]      // Start conversion signal for ADC0808
    assign oe =  JA[2];      // Output enable signal for ADC0808
    assign addr = 3'd0;       // Address lines to select analog input channel
    assign JA[7] = clock50kHz;

    // Internal signals
    wire [7:0] adc_value;          // Captured ADC output
    wire data_ready;               // Signal indicating ADC data is ready
    wire [3:0] hundreds, tens, ones; // BCD outputs

    // Clocking
    wire clock50kHz;
    clock_100M_50k clock_delta(.clk_in(CLK100MHZ), .reset(reset), .clk_out(clock50kHz));


    // Instantiate the ADC interface
    adc_interface adc_intf (
        .clk(clock50kHz),
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
