module cla_outer_32 (data_operandA, data_operandB, Cin, data_result, Cout); 

    input [31:0] data_operandA, data_operandB;
    input Cin;
    output [31:0] data_result;
    output Cout;

    assign data_result = data_operandA + data_operandB + Cin;
    assign Cout = 1'b0;


    // wire [7:0] block_sum_1, block_sum_2, block_sum_3, block_sum_4;
    // wire [3:0] big_G, big_P;
    // wire [4:0] carry;

    // //////////// CALCULATE CARRIES

    // // l0
    // assign carry[0] = Cin;
    // // l1
    // wire c1;
    // and carry_and1(c1, big_P[0], carry[0]);
    // or carry_or1(carry[1], c1, big_G[0]);
    // // l2
    // wire c2, c3;
    // and carry_and2(c2, big_P[1], big_G[0]);
    // and carry_and3(c3, big_P[1], big_P[0], carry[0]);
    // or carry_or2(carry[2], big_G[1], c2, c3);
    // // l3
    // wire c4, c5, c6;
    // and carry_and6(c6, big_P[2], big_G[1]);
    // and carry_and4(c4, big_P[2], big_P[1], big_G[0]);
    // and carry_and5(c5, big_P[2], big_P[1], big_P[0], carry[0]);
    // or carry_or3(carry[3], big_G[2], c4, c5, c6);
    // // l4
    // wire c7, c8, c9, c10;
    // and carry_and7(c7, big_P[3], big_G[2]);
    // and carry_and8(c8, big_P[3], big_P[2], big_G[1]);
    // and carry_and9(c9, big_P[3], big_P[2], big_P[1], big_G[0]);
    // and carry_and10(c10, big_P[3], big_P[2], big_P[1], big_P[0], carry[0]);
    // or carry_or4(carry[4], big_G[3], c7, c8, c9, c10);

    // //////////// CALCULATE SUMS

    // // low 8 bits
    // cla_inner lowest8(.data_operandA(data_operandA[7:0]), .data_operandB(data_operandB[7:0]),
    // .Cin(Cin), .data_result(data_result[7:0]), .Cout(carry[1]), .big_G(big_G[0]), .big_P(big_P[0]));

    // // low-med 8 bits
    // cla_inner lowmed8(.data_operandA(data_operandA[15:8]), .data_operandB(data_operandB[15:8]),
    // .Cin(carry[1]), .data_result(data_result[15:8]), .Cout(carry[2]), .big_G(big_G[1]), .big_P(big_P[1]));

    // // hi-med 8 bits
    // cla_inner himed8(.data_operandA(data_operandA[23:16]), .data_operandB(data_operandB[23:16]),
    // .Cin(carry[2]), .data_result(data_result[23:16]), .Cout(carry[3]), .big_G(big_G[2]), .big_P(big_P[2]));

    // // high 8 bits
    // cla_inner highest8(.data_operandA(data_operandA[31:24]), .data_operandB(data_operandB[31:24]),
    // .Cin(carry[3]), .data_result(data_result[31:24]), .Cout(carry[4]), .big_G(big_G[3]), .big_P(big_P[3]));

    // // FINAL OUTPUTS
    // assign Cout = carry[4];

endmodule