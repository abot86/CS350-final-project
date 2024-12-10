module adder(A, B, Cin, S, Cout);
    input [31:0] A, B;
    input Cin;
    output [31:0] S;
    output Cout;

    wire c8, c16, c24;
    wire G0, P0, G1, P1, G2, P2, G3, P3;

    wire w8_1;
    and(w8_1, P0, Cin);
    or(c8, w8_1, G0);

    wire w16_1, w16_2;
    and(w16_1, P1, G0);
    and(w16_2, P1, P0, Cin);
    or(c16, G1, w16_1, w16_2);

    wire w24_1, w24_2, w24_3;
    and(w24_1, P2, G1);
    and(w24_2, P2, P1, G0);
    and(w24_3, P2, P1, P0, Cin);
    or(c24, G2, w24_1, w24_2, w24_3);

    wire w32_1, w32_2, w32_3, w32_4;
    and(w32_1, P3, G2);
    and(w32_2, P3, P2, G1);
    and(w32_3, P3, P2, P1, G0);
    and(w32_4, P3, P2, P1, P0, Cin);
    or(Cout, G3, w32_1, w32_2, w32_3, w32_4);

    adder_block add0(A[7:0], B[7:0], Cin, S[7:0], G0, P0);
    adder_block add1(A[15:8], B[15:8], c8, S[15:8], G1, P1);
    adder_block add2(A[23:16], B[23:16], c16, S[23:16], G2, P2);
    adder_block add3(A[31:24], B[31:24], c24, S[31:24], G3, P3);

endmodule