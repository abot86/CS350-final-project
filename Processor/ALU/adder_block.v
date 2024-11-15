module adder_block(A, B, c0, S, G, P);
    input [7:0] A, B;
    input c0;
    output [7:0] S;
    output P, G;

    wire g7, g6, g5, g4, g3, g2, g1, g0, p7, p6, p5, p4, p3, p2, p1, p0;
    wire c7, c6, c5, c4, c3, c2, c1;

    // calculate g (generate carry)
    and(g7, A[7], B[7]);
    and(g6, A[6], B[6]);
    and(g5, A[5], B[5]);
    and(g4, A[4], B[4]);
    and(g3, A[3], B[3]);
    and(g2, A[2], B[2]);
    and(g1, A[1], B[1]);
    and(g0, A[0], B[0]);

    // calculate p (propagate carry)
    or(p7, A[7], B[7]);
    or(p6, A[6], B[6]);
    or(p5, A[5], B[5]);
    or(p4, A[4], B[4]);
    or(p3, A[3], B[3]);
    or(p2, A[2], B[2]);
    or(p1, A[1], B[1]);
    or(p0, A[0], B[0]);

    // calculate carries (c0-c7) with recursive logic
    wire w11;
    and(w11, p0, c0);
    or(c1, g0, w11);

    wire w21, w22;
    and(w21, p1, g0);
    and(w22, p1, p0, c0);
    or(c2, g1, w21, w22);

    wire w31, w32, w33;
    and(w31, p2, g1);
    and(w32, p2, p1, g0);
    and(w33, p2, p1, p0, c0);
    or(c3, g2, w31, w32, w33);

    wire w41, w42, w43, w44;
    and(w41, p3, g2);
    and(w42, p3, p2, g1);
    and(w43, p3, p2, p1, g0);
    and(w44, p3, p2, p1, p0, c0);
    or(c4, g3, w41, w42, w43, w44);

    wire w51, w52, w53, w54, w55;
    and(w51, p4, g3);
    and(w52, p4, p3, g2);
    and(w53, p4, p3, p2, g1);
    and(w54, p4, p3, p2, p1, g0);
    and(w55, p4, p3, p2, p1, p0, c0);
    or(c5, g4, w51, w52, w53, w54, w55);

    wire w61, w62, w63, w64, w65, w66;
    and(w61, p5, g4);
    and(w62, p5, p4, g3);
    and(w63, p5, p4, p3, g2);
    and(w64, p5, p4, p3, p2, g1);
    and(w65, p5, p4, p3, p2, p1, g0);
    and(w66, p5, p4, p3, p2, p1, p0, c0);
    or(c6, g5, w61, w62, w63, w64, w65, w66);

    wire w71, w72, w73, w74, w75, w76, w77;
    and(w71, p6, g5);
    and(w72, p6, p5, g4);
    and(w73, p6, p5, p4, g3);
    and(w74, p6, p5, p4, p3, g2);
    and(w75, p6, p5, p4, p3, p2, g1);
    and(w76, p6, p5, p4, p3, p2, p1, g0);
    and(w77, p6, p5, p4, p3, p2, p1, p0, c0);
    or(c7, g6, w71, w72, w73, w74, w75, w76, w77);

    and(P, p0, p1, p2, p3, p4, p5, p6, p7);

    wire wg1, wg2, wg3, wg4, wg5, wg6, wg7;
    and(wg1, p7, g6);
    and(wg2, p7, p6, g5);
    and(wg3, p7, p6, p5, g4);
    and(wg4, p7, p6, p5, p4, g3);
    and(wg5, p7, p6, p5, p4, p3, g2);
    and(wg6, p7, p6, p5, p4, p3, p2, g1);
    and(wg7, p7, p6, p5, p4, p3, p2, p1, g0);
    or(G, g7, wg1, wg2, wg3, wg4, wg5, wg6, wg7);



    // calculate sum
    xor(S[7], A[7], B[7], c7);
    xor(S[6], A[6], B[6], c6);
    xor(S[5], A[5], B[5], c5);
    xor(S[4], A[4], B[4], c4);
    xor(S[3], A[3], B[3], c3);
    xor(S[2], A[2], B[2], c2);
    xor(S[1], A[1], B[1], c1);
    xor(S[0], A[0], B[0], c0);

endmodule