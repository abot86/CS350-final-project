module cla_inner(data_operandA, data_operandB, Cin, data_result, Cout, big_G, big_P);
    input [7:0] data_operandA, data_operandB;
    input Cin;

    output [7:0] data_result;
    output Cout, big_G, big_P;
    
    wire [7:0] g;
    wire [7:0] p;
    wire [7:0] c;

    // 'Generate' bits
    and and_g0(g[0], data_operandA[0], data_operandB[0]);
    and and_g1(g[1], data_operandA[1], data_operandB[1]);
    and and_g2(g[2], data_operandA[2], data_operandB[2]);
    and and_g3(g[3], data_operandA[3], data_operandB[3]);
    and and_g4(g[4], data_operandA[4], data_operandB[4]);
    and and_g5(g[5], data_operandA[5], data_operandB[5]);
    and and_g6(g[6], data_operandA[6], data_operandB[6]);
    and and_g7(g[7], data_operandA[7], data_operandB[7]);

    // 'Propagate' bits
    or or_p0(p[0], data_operandA[0], data_operandB[0]);
    or or_p1(p[1], data_operandA[1], data_operandB[1]);
    or or_p2(p[2], data_operandA[2], data_operandB[2]);
    or or_p3(p[3], data_operandA[3], data_operandB[3]);
    or or_p4(p[4], data_operandA[4], data_operandB[4]);
    or or_p5(p[5], data_operandA[5], data_operandB[5]);
    or or_p6(p[6], data_operandA[6], data_operandB[6]);
    or or_p7(p[7], data_operandA[7], data_operandB[7]);

    // carry out bit 0
    wire a1;
    and c0_and(a1, Cin, p[0]);
    or c0_or(c[0], g[0], a1);

    // carry out bit 1
    wire b1, b2;
    and c1_and1(b1, Cin, p[0], p[1]);
    and c1_and2(b2, c[0], p[1]);
    or c1_or(c[1], g[1], b1, b2);

    // carry out bit 2
    wire c1, c2, c3;
    and c2_and1(c1, Cin, p[0], p[1], p[2]);
    and c2_and2(c2, c[0], p[1], p[2]);
    and c2_and3(c3, c[1], p[2]);
    or c2_or(c[2], g[2], c1, c2, c3);

    // carry out bit 3
    wire d1, d2, d3, d4;
    and c3_and1(d1, Cin, p[0], p[1], p[2], p[3]);
    and c3_and2(d2, c[0], p[1], p[2], p[3]);
    and c3_and3(d3, c[1], p[2], p[3]);
    and c3_and4(d4, c[2], p[3]);
    or c3_or(c[3], g[3], d1, d2, d3, d4);

    // carry out bit 4
    wire e1, e2, e3, e4, e5;
    and c4_and1(e1, Cin, p[0], p[1], p[2], p[3], p[4]);
    and c4_and2(e2, c[0], p[1], p[2], p[3], p[4]);
    and c4_and3(e3, c[1], p[2], p[3], p[4]);
    and c4_and4(e4, c[2], p[3], p[4]);
    and c4_and5(e5, c[3], p[4]);
    or c4_or(c[4], g[4], e1, e2, e3, e4, e5);

    // carry out bit 5
    wire f1, f2, f3, f4, f5, f6;
    and c5_and1(f1, Cin, p[0], p[1], p[2], p[3], p[4], p[5]);
    and c5_and2(f2, c[0], p[1], p[2], p[3], p[4], p[5]);
    and c5_and3(f3, c[1], p[2], p[3], p[4], p[5]);
    and c5_and4(f4, c[2], p[3], p[4], p[5]);
    and c5_and5(f5, c[3], p[4], p[5]);
    and c5_and6(f6, c[4], p[5]);
    or c5_or(c[5], g[5], f1, f2, f3, f4, f5, f6);

    // carry out bit 6
    wire g1, g2, g3, g4, g5, g6, g7;
    and c6_and1(g1, Cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
    and c6_and2(g2, c[0], p[1], p[2], p[3], p[4], p[5], p[6]);
    and c6_and3(g3, c[1], p[2], p[3], p[4], p[5], p[6]);
    and c6_and4(g4, c[2], p[3], p[4], p[5], p[6]);
    and c6_and5(g5, c[3], p[4], p[5], p[6]);
    and c6_and6(g6, c[4], p[5], p[6]);
    and c6_and7(g7, c[5], p[6]);
    or c6_or(c[6], g[6], g1, g2, g3, g4, g5, g6, g7);

    // carry out bit 7
    wire h1, h2, h3, h4, h5, h6, h7, h8;
    and c7_and1(h1, Cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c7_and2(h2, c[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c7_and3(h3, c[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and c7_and4(h4, c[2], p[3], p[4], p[5], p[6], p[7]);
    and c7_and5(h5, c[3], p[4], p[5], p[6], p[7]);
    and c7_and6(h6, c[4], p[5], p[6], p[7]);
    and c7_and7(h7, c[5], p[6], p[7]);
    and c7_and8(h8, c[6], p[7]);
    or c7_or(c[7], g[7], h1, h2, h3, h4, h5, h6, h7, h8);

    // 'Sum' bits
    xor xor1(data_result[0], data_operandA[0], data_operandB[0], Cin);
    xor xor2(data_result[1], data_operandA[1], data_operandB[1], c[0]);
    xor xor3(data_result[2], data_operandA[2], data_operandB[2], c[1]);
    xor xor4(data_result[3], data_operandA[3], data_operandB[3], c[2]);
    xor xor5(data_result[4], data_operandA[4], data_operandB[4], c[3]);
    xor xor6(data_result[5], data_operandA[5], data_operandB[5], c[4]);
    xor xor7(data_result[6], data_operandA[6], data_operandB[6], c[5]);
    xor xor8(data_result[7], data_operandA[7], data_operandB[7], c[6]);

    // 'big_G' bits
    wire bg1, bg2, bg3, bg4, bg5, bg6, bg7;
    and bgand1(bg1, g[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and bgand2(bg2, g[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    and bgand3(bg3, g[2], p[3], p[4], p[5], p[6], p[7]);
    and bgand4(bg4, g[3], p[4], p[5], p[6], p[7]);
    and bgand5(bg5, g[4], p[5], p[6], p[7]);
    and bgand6(bg6, g[5], p[6], p[7]);
    and bgand7(bg7, g[6], p[7]);
    or bgor(big_G, bg1, bg2, bg3, bg4, bg5, bg6, bg7, g[7]);

    // Final outputs
    assign Cout = c[7];
    and big_P_and(big_P, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);

endmodule