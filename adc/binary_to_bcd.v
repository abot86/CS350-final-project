module binary_to_bcd (
    input wire [7:0] binary_in,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    reg [19:0] shift_reg;

    always @(*) begin
        shift_reg = 0;
        shift_reg[7:0] = binary_in;

        for (i = 0; i < 8; i = i + 1) begin
            if (shift_reg[11:8] >= 5)
                shift_reg[11:8] = shift_reg[11:8] + 3;
            if (shift_reg[15:12] >= 5)
                shift_reg[15:12] = shift_reg[15:12] + 3;
            shift_reg = shift_reg << 1;
        end

        hundreds = shift_reg[15:12];
        tens = shift_reg[11:8];
        ones = shift_reg[7:4];
    end
endmodule
