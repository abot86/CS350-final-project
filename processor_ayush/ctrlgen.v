module ctrlgen(
    input wire clk,
    input wire condition,
    output wire ctrl
);

    wire current_condition;
    wire previous_condition;

    dffe_ref DFF1(.q(current_condition), .d(condition), .clk(clk), .en(1'b1), .clr(1'b0));
    dffe_ref DFF2(.q(previous_condition), .d(current_condition), .clk(clk), .en(1'b1), .clr(1'b0));

    // Generate ctrl on rising edge
    assign ctrl = current_condition & ~previous_condition;

endmodule