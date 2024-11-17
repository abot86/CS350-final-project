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

    reg [2:0] state;

    localparam IDLE = 3'd0, START_CONV = 3'd1, WAIT_EOC = 3'd2, READ_DATA = 3'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ale <= 0;
            start <= 0;
            oe <= 0;
            data_ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ale <= 1;
                    start <= 1;
                    state <= START_CONV;
                end
                START_CONV: begin
                    ale <= 0;
                    start <= 0;
                    state <= WAIT_EOC;
                end
                WAIT_EOC: begin
                    if (eoc) begin
                        oe <= 1;
                        state <= READ_DATA;
                    end
                end
                READ_DATA: begin
                    data_out <= adc_data;
                    data_ready <= 1;
                    oe <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

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