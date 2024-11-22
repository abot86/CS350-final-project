module adc_interface(
    input clk,
    input reset,          // Reset signal
    input eoc,            // End-of-conversion signal from ADC0808
    input [7:0] data_in,  // Digital output from ADC0808
    output reg ale,       // Address latch enable for ADC0808
    output reg start,     // Start conversion signal for ADC0808
    output reg oe,        // Output enable signal for ADC0808
    output reg [7:0] data_out // Digital data captured from ADC
);
    //address always 0

    reg [2:0] state;

    localparam IDLE = 3'd0, START_CONV = 3'd1, WAIT_EOC = 3'd2, READ_DATA = 3'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ale <= 0;
            start <= 0;
            oe <= 0;
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
                    state <= IDLE;
                end
            endcase
        end
        data_out <= data_in;
    end
endmodule

