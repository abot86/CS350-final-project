module adc_top_level (
    input wire CLK100MHZ,      // FPGA clock
    input wire BTNC,          // Reset signal
    inout wire [11:0] JA,            // \ NOT NECESSARILY INOUT, NEED TO CHANGE
    inout wire [11:0] JB,            // / 

    output reg CA,CB,CC,CD,CE,CF,CG,
    output reg [6:0] AN,
    output reg [7:0] LED
);

    // wire instantiation
    wire [7:0] data_in;                     // Digital output from ADC0808
    wire ale, start, oe, reset;
    wire [2:0] addr;

    assign data_in = {JA[10:7], JA[4:1]};
    assign eoc = JA[3];       //
    assign ale =  JA[1];       // Address latch enable for ADC0808 
    assign start = JA[4];      // Start conversion signal for ADC0808
    assign oe =  JA[2];      // Output enable signal for ADC0808
    assign addr = 3'd0;       // Address lines to select analog input channel
    assign JA[7] = clock50kHz;
    assign reset = BTNC;

    // testing
    always LED = data_in;


    // Internal signals
    wire [7:0] adc_value;          // Captured ADC output
    wire data_ready;               // Signal indicating ADC data is ready
    wire [3:0] hundreds, tens, ones; // BCD outputs

    // Clocking
    wire clock50kHz;
    clock_100M_50k clock_delta(.clk_in(CLK100MHZ), .reset(reset), .clk_out(clock50kHz));

    // 7 seg display
    always AN[6:4] = 1;

    reg [6:0] seg;
    always CA = seg[0];
    always CB = seg[1];
    always CC = seg[2];
    always CD = seg[3];
    always CE = seg[4];
    always CF = seg[5];
    always CG = seg[6];

    // Instantiate the ADC interface
    adc_interface adc_intf (
        .clk(clock50kHz),
        .reset(reset),
        .eoc(eoc),
        .data_in(data_in),
        .ale(ale),
        .start(start),
        .oe(oe),
//        .addr(addr),
        .data_out(adc_value)
    );

    // Instantiate the Binary-to-BCD converter
    binary_to_bcd bin_to_bcd (
        .binary_in(adc_value),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );
    
    wire [6:0] segwire;
    wire [3:0] anwire;
    
    // Instantiate the 7-segment display multiplexer
    seven_segment_multiplexer seg_mux (
        .clk(CLK100MHZ),
        .reset(reset),
        .digit0(ones),      // Least significant digit
        .digit1(tens),
        .digit2(hundreds),  // Most significant digit
        .seg(segwire),
        .an(anwire)
    );
    always seg[6:0] = segwire;
    always AN[3:0] = anwire;

endmodule
