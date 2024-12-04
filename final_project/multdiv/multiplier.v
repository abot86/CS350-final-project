module multiplier(
    data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    /////////////     WIRES
    // MXA (M x ALU) (combinational)
    wire [32:0] reg_M_out_mxa, mux8_out_mxa, cla_out_mxa;
    // REG PROD
    wire [2:0] ctrl_MBOOTH; 
    wire [65:0] reg_PROD_in, reg_PROD_out, data_operandB_extended, sra_in_mxa, sra_out_mxa;

    // other
    wire [4:0] counter, data_ready_16;
    wire cout_no1, cout_no2;

    /////////////    REGISTERS
    // M REGISTER
    register #(32) reg_M(.out(reg_M_out_mxa[31:0]), .in(data_operandA), .clk(clock), .en(ctrl_MULT), .clr(ctrl_DIV));
    // PROD REGISTER
    register #(66) reg_PROD(.out(reg_PROD_out), .in(reg_PROD_in), .clk(clock), .en(clock), .clr(ctrl_DIV));
    assign ctrl_MBOOTH = reg_PROD_out[2:0];
    assign reg_M_out_mxa[32] = reg_M_out_mxa[31];

    /////////////     COMBINATIONAL LOGIC --------------------------- TEST IF +2M, +M, -M, -2M are CORRECT
    // mux8 and inputs *CHANGE TO OUTPUT FOR TEST
    wire [32:0] plus2m_mxa, plusm_mxa, minusm_mxa, minus2m_mxa;
    sll #(33) makes_2m(.in(reg_M_out_mxa), .out(plus2m_mxa), .sh_amt(5'd1));
    assign plusm_mxa = reg_M_out_mxa;
    // Make Minus inputs (since we have to use an adder smh)
        // assign minus2m_mxa = ~plus2m_mxa + 1'b1; (see how this line is commented out)
        // assign minusm_mxa = ~reg_M_out_mxa + 1'b1; (same with this one)
    cla_outer minus2m(.data_operandA(~plus2m_mxa), .data_operandB(33'd1), .Cin(1'b0), .data_result(minus2m_mxa), .Cout(cout_no1));
    cla_outer minusm(.data_operandA(~reg_M_out_mxa), .data_operandB(33'd1), .Cin(1'b0), .data_result(minusm_mxa), .Cout(cout_no2));

    mux8 #(33) mbooth_alg(.out(mux8_out_mxa), .select(ctrl_MBOOTH),
        .in0(33'b0), .in1(plusm_mxa), .in2(plusm_mxa), .in3(plus2m_mxa),
        .in4(minus2m_mxa), .in5(minusm_mxa), .in6(minusm_mxa), .in7(33'b0)); //change to 33 bits
    

    // CLA & SRA & into REG_PROD
    wire cla_cout;
    cla_outer new_prod_input(.data_operandA(reg_PROD_out[65:33]), .data_operandB(mux8_out_mxa), .Cin(1'b0), .data_result(cla_out_mxa), .Cout(cla_cout));
    assign sra_in_mxa[65:33] = cla_out_mxa; 
    assign sra_in_mxa[32:0] = reg_PROD_out[32:0];
    sra #(66) shift_by_2(.out(sra_out_mxa), .in(sra_in_mxa), .sh_amt(5'd2));

    // MUX for B vs SRA_OUT
    assign data_operandB_extended = {33'b0, data_operandB, 1'b0};
    assign reg_PROD_in = ctrl_MULT ? data_operandB_extended : sra_out_mxa;

    /////////////      TIMING
    counter5b counts(.out(counter), .clock(clock), .enable(ctrl_MULT), .dis(ctrl_DIV), .clr(ctrl_MULT));
    assign data_ready_16 = counter ^ 5'd16;
    assign data_resultRDY = !(data_ready_16 || 5'd0);

    /////////////      FINAL OUTPUT
    assign data_result = reg_PROD_out[32:1];

    // data exception
    wire [31:0] intermediate_data_exception;
    wire de_1, de_2;
    assign intermediate_data_exception = reg_PROD_out[64:33];
    assign de_1 = !((&intermediate_data_exception) || (&(~intermediate_data_exception)));  
    assign de_2 = data_result[31] ? ~(data_operandA[31] ^ data_operandB[31]) : (data_operandA[31] ^ data_operandB[31]);
    assign data_exception = (de_1 | de_2) & (|data_operandA) & (|data_operandB);

    // // TEST
    // always @(posedge data_resultRDY) begin
    //     $display("\n upper: %b, lower: %b \n bonus:%b end:%b ",reg_PROD_out[64:33], reg_PROD_out[32:1],reg_PROD_out[65],reg_PROD_out[0]);
    //     $display(" I gave exception of: %b ", data_exception);
    // end 

endmodule
