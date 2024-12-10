module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
    
    wire OVF;
    wire [31:0] notB, inB;
    wire [31:0] and_result, or_result, sll_result, sra_result, addsub_result;


    mux_32 OPMUX(data_result, ctrl_ALUopcode, addsub_result, addsub_result, and_result, or_result, sll_result, sra_result, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0);

    // determine isNotEqual, isLessThan
    or(isNotEqual, data_result[31], data_result[30], data_result[29], data_result[28], data_result[27], data_result[26], data_result[25], data_result[24], data_result[23], data_result[22], data_result[21], data_result[20], data_result[19], data_result[18], data_result[17], data_result[16], data_result[15], data_result[14], data_result[13], data_result[12], data_result[11], data_result[10], data_result[9], data_result[8], data_result[7], data_result[6], data_result[5], data_result[4], data_result[3], data_result[2], data_result[1], data_result[0]);
    
    wire [1:0] selectLT;
    assign selectLT[1] = data_operandA[31];
    assign selectLT[0] = data_operandB[31];
    mux_41 LTMUX(isLessThan, selectLT, data_result[31], 1'b0, 1'b1, data_result[31]);


    //calculate overflow using sum of products
    wire notAMSB, notBMSB, notRMSB, o1, o2;
    not(notAMSB, data_operandA[31]);
    not(notBMSB, inB[31]);
    not(notRMSB, data_result[31]);

    and(o1, notAMSB, notBMSB, data_result[31]);
    and(o2, data_operandA[31], inB[31], notRMSB);
    or(overflow, o1, o2);

    //bitwise AND
    bitwiseAND BITWISEAND(data_operandA, data_operandB, and_result);

    //bitwise OR
    bitwiseOR BITWISEOR(data_operandA, data_operandB, or_result);

    //shift left logical (unsigned)
    sll SLL(data_operandA, ctrl_shiftamt, sll_result);

    //shift right arithmetic (assume signed, preserve MSB)
    sra SRA(data_operandA, ctrl_shiftamt, sra_result);

    //add subtract
    not32 NOTB(notB, data_operandB);
    assign inB = ctrl_ALUopcode[0] ?  notB : data_operandB;
    adder ADDSUB(data_operandA, inB, ctrl_ALUopcode[0], addsub_result, OVF);
    

endmodule