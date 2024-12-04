module divider (
    data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    //// NOTE: NON-RESTORING ONLY WORKS FOR NON-NEGATIVES

    // IO instantiation
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;
    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // data_exception: iff data_operandB = 0
    assign data_exception = !(|data_operandB);

    // wires because thats how ece works
    wire [63:0] albert, bartholomew, candice, dexter;
    wire [31:0] vermouth, data_operandA_not, data_operandB_not, data_A_in, data_B_in, dexter_not;
    wire [2:0] Cout_extra;

    // Registers
    register #(32) reg_V(.out(vermouth), .in(data_B_in), .clk(clock), .en(ctrl_DIV), .clr(ctrl_MULT));
    register #(64) reg_RQ(.out(bartholomew), .in(albert), .clk(clock), .en(clock), .clr(ctrl_MULT));


    // ABOVE RQ (EA)
    cla_outer_32 negateA(.data_operandA(~data_operandA), .data_operandB(32'd1), .Cin(1'b0), .data_result(data_operandA_not), .Cout(Cout_extra[0]));
    cla_outer_32 negateB(.data_operandA(~data_operandB), .data_operandB(32'd1), .Cin(1'b0), .data_result(data_operandB_not), .Cout(Cout_extra[1]));
    assign data_A_in = data_operandA[31] ? data_operandA_not : data_operandA;
    assign data_B_in = data_operandB[31] ? data_operandB_not : data_operandB;
    assign albert = ctrl_DIV ? {32'd0, data_A_in} : dexter;

    // (AB)
    // register instantiation via above

    // (BC)
    sll #(64) single_shift(.in(bartholomew), .out(candice), .sh_amt(5'd1));

    // (CD)
    wire [31:0] cplus, cminus;
    wire doICare, iDontCare;
    cla_outer_32 plus(.data_operandA(candice[63:32]), .data_operandB(vermouth), .Cin(1'b0), .data_result(cplus), .Cout(doICare));
    cla_outer_32 minus(.data_operandA(candice[63:32]), .data_operandB(~vermouth), .Cin(1'b1), .data_result(cminus), .Cout(iDontCare));
    assign dexter[63:32] = candice[63] ? cplus : cminus;
    assign dexter[31:1] = candice[31:1];

    // (DA)
    wire [31:0] dplus;
    wire neverCared;
    assign dexter[0] = dexter[63] ? 1'b0 : 1'b1; 
    cla_outer_32 final_res(.data_operandA(dexter[63:32]), .data_operandB(vermouth), .Cin(1'b0), .data_result(dplus), .Cout(neverCared));
     
    // FINAL (test comment)
    // assign data_result[63:32] = dexter[63] ? dplus : dexter[63:32]; // FOR REMAINDER BIT
    cla_outer_32 negateRES(.data_operandA(~dexter[31:0]), .data_operandB(32'd1), .Cin(1'b0), .data_result(dexter_not), .Cout(Cout_extra[2]));
    assign data_result = (data_operandA[31] ^ data_operandB[31]) ? dexter_not : dexter[31:0];


    /////////////      TIMING (possibly use single counter instantiated in multdiv module rather than 1 each)
    wire [5:0] counter, data_ready_32;
    counter6b counts_too(.out(counter), .clock(clock), .enable(ctrl_DIV), .dis(ctrl_MULT), .clr(ctrl_DIV));
    assign data_ready_32 = counter ^ 6'd31;
    assign data_resultRDY = !(data_ready_32 || 6'd0);

endmodule