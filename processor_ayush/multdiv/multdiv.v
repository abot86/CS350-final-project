module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire exc1;
    wire exc2;
    wire excMULT;
    wire excDIV;

// Exception handling
    assign exc1 = ~((&outP[64:32])|(&(~outP[64:32])));  // Throw exception when multiplying and top 32 bits are not 1's or 0's
    assign exc2 = data_operandA[31]^data_operandB[31]^outP[32]; // Sign exceptions
    assign excDIV = ~(|data_operandB) & ~multORdiv;  // Div by 0
    assign excMULT = (exc1 | exc2) & (|data_operandA) & (|data_operandB) & multORdiv;

    assign data_exception = excDIV | excMULT;

    wire signalOn, multORdiv;
    assign signalOn = ctrl_DIV | ctrl_MULT;

    // CHOOSE outputs 1 MULT, 0 DIV (multORdiv)
    dffe_ref CHOOSE(.q(multORdiv), .d(ctrl_MULT), .clk(clock), .en(signalOn), .clr(1'b0));


// Data Result logic
    wire [31:0] pre_result_DIV, result_DIV, result_MULT;

    assign pre_result_DIV = negate ? negQ : outRQ[31:0];
    assign result_DIV = excDIV ? 32'b0 : pre_result_DIV;
    assign result_MULT = outP[32:1];

    assign data_result = multORdiv ? result_MULT : result_DIV;



//DIV LOGIC (non-restoring)

    // handle negatives
    wire negate;
    wire [31:0] negA, negB, Adiv, Bdiv;
    wire [31:0] negR, negQ;
    wire Cout_negA, Cout_negB, Cout_negR, Cout_negQ;

    adder NEGATE_A(.A(~data_operandA), .B(32'b0), .Cin(1'b1), .S(negA), .Cout(Cout_negA));
    adder NEGATE_B(.A(~data_operandB), .B(32'b0), .Cin(1'b1), .S(negB), .Cout(Cout_negB));

    adder NEGATE_R(.A(~outRQ[63:32]), .B(32'b0), .Cin(1'b1), .S(negR), .Cout(Cout_negR));
    adder NEGATE_Q(.A(~outRQ[31:0]), .B(32'b0), .Cin(1'b1), .S(negQ), .Cout(Cout_negQ));
    
    assign negate = data_operandA[31] ^ data_operandB[31];
    
    assign Adiv = data_operandA[31] ? negA : data_operandA;
    assign Bdiv = data_operandB[31] ? negB : data_operandB;

    
    // initialize registers
    wire [63:0] initRQ, inRQf, inRQ, outRQ, slRQ, restored;
    wire [31:0] outV, Vadd, Radd, SDiv, Srestored;
    wire Cout_div, Cout_restore;

    assign initRQ[63:32] = 32'b0;
    assign initRQ[31:0] = Adiv;

    register V(.q(outV), .d(Bdiv), .clk(clock), .en(ctrl_DIV), .clr(1'b0));
    register64 RQ(.q(outRQ), .d(inRQf), .clk(clock), .en(1'b1), .clr(1'b0));

    //sll
    assign slRQ = outRQ << 1;
    assign Radd = slRQ[63:32];

    // R += V (R is -) or R -= V (R is +)
    assign Vadd = ~outRQ[63] ? ~outV : outV;
    adder ADDDIV(.A(Radd), .B(Vadd), .Cin(~outRQ[63]), .S(SDiv), .Cout(Cout_div));
    assign inRQ[63:32] = SDiv;
    assign inRQ[31:1] = slRQ[31:1];

    // Q[0] = (~R MSB)
    assign inRQ[0] = ~SDiv[31];
    
    // To RQ
    assign inRQf = ctrl_DIV ? initRQ : inRQ;

    // Restoring (R+V)
    adder RESTORE(.A(outRQ[63:32]), .B(outV), .Cin(1'b0), .S(Srestored), .Cout(Cout_restore));
    assign restored [63:32] = Srestored;
    assign restored [31:0] = outRQ[31:0];

// MULT LOGIC (modified Booth's)
    
    // Initialize registers
    wire [2:0] ctrl;
    wire [64:0] inPf, inP, initP;
    wire [31:0] inA;
    wire [31:0] outM;
    wire [64:0] outP;
    wire [64:0] pShifted;

    wire [31:0] shiftM;
    wire [31:0] outShift;
    wire [31:0] inAdd;
    wire [31:0] outAdd;

    wire [31:0] S;
    wire Cout;

    wire [5:0] count;

    //Initialize product and multiplicand registers
    assign initP[64:33] = 32'b0;
    assign initP[32:1] = data_operandB;
    assign initP[0] = 1'b0;
    
    register MULTIPLICAND(outM, data_operandA, clock, ctrl_MULT, 1'b0);
    register65 PRODUCT(outP, inPf, clock, 1'b1, 1'b0);

    assign inA = outP[64:33];

    //Choose between initalize and inP
    assign inPf = ctrl_MULT ? initP : pShifted;

    //Read product register
    mux_83 BOOTH(ctrl, outP[2:0], 3'b000, 3'b100, 3'b100, 3'b101, 3'b111, 3'b110, 3'b110, 3'b000);

    //Shift select (+2M or +1M)
    assign shiftM = outM << 1;
    assign outShift = ctrl[0] ? shiftM : outM;

    //Adder
    assign inAdd = ctrl[1] ? ~outShift : outShift;
    adder ADDMULT(inA, inAdd, ctrl[1], S, Cout);

    //Nothing (000) or (111)
    assign outAdd = ctrl[2] ? S : inA;

    assign inP [64:33] = outAdd;
    assign inP [32:0] = outP[32:0];
    sra65 SHIFTP(pShifted, inP, 5'b0010);

//Counter logic
    wire multRDY;
    wire divRDY;
    counter COUNTER(count, clock, 1'b1, signalOn);

    assign multRDY = ~count[5] & count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];
    assign divRDY = count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];
    assign data_resultRDY = (multRDY & multORdiv) | (divRDY & ~multORdiv);


endmodule