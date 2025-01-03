module adc_interface(
    input wire CLK25MHZ,
    input [7:0] JA,  // Digital output from ADC0808
    output reg [7:0] LED // Digital data captured from ADC
);
    assign JA[7:0] = LED[7:0];

endmodule

