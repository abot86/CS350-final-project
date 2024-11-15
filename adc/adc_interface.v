module adc_interface(
    input CLK100MHZ;

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