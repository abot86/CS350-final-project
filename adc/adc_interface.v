module adc_interface(
    input CLK100MHZ;
    input reset,          // Reset signal
    input eoc,            // End-of-conversion signal from ADC0808
    input [7:0] data_in,  // Digital output from ADC0808
    output reg ale,       // Address latch enable for ADC0808
    output reg start,     // Start conversion signal for ADC0808
    output reg oe,        // Output enable signal for ADC0808
    output reg [2:0] addr,// Address lines to select analog input channel
    output reg [7:0] data_out // Digital data captured from ADC

);

/*
CTRL SIGNALS:
    INPUT (OUT FROM ADC):
    - [2^-1 : 2^-8]

    OUTPUT (TO ADC):
    - ALE (Address Latch Enable)

    OTHER:
    - ADD A / ADD B / ADD C (address selection)
        -  just tie all to ground and keep our input on In0.
    
https://www.ti.com/lit/ds/symlink/adc0808-n.pdf?ts=1731677092610&ref_url=https%253A%252F%252Fwww.google.com%252F

*/


endmodule