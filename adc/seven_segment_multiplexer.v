module seven_segment_multiplexer (
    input wire clk,
    input wire reset,
    input wire [3:0] digit0,
    input wire [3:0] digit1,
    input wire [3:0] digit2,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg [1:0] mux_sel;
    reg [3:0] current_digit;

    always @(posedge clk or posedge reset) begin
        if (reset)
            mux_sel <= 0;
        else
            mux_sel <= mux_sel + 1;
    end

    always @(*) begin
        case (mux_sel)
            2'd0: begin
                current_digit = digit0;
                an = 4'b1110; // Activate first digit
            end
            2'd1: begin
                current_digit = digit1;
                an = 4'b1101; // Activate second digit
            end
            2'd2: begin
                current_digit = digit2;
                an = 4'b1011; // Activate third digit
            end
            default: begin
                current_digit = 4'b1111;
                an = 4'b1111; // All off
            end
        endcase
    end

    seven_segment_decoder decoder (
        .digit(current_digit),
        .seg(seg)
    );
endmodule
