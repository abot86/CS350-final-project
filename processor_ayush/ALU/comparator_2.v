module comparator_2(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [1:0] A, B;
    output EQ0, GT0;
    wire muxeq, muxgt, w1, w2, notB0, notEQ1, notGT1;

    wire [2:0] select;
    assign select[2:1] = A;
    assign select[0] = B[1];

    not(notB0, B[0]);
    not(notGT1, GT1);
    not(notEQ1, EQ1);

    mux_81 EQMUX(muxeq, select, notB0, 1'b0, B[0], 1'b0, 1'b0, notB0, 1'b0, B[0]);
    and AND1(EQ0, muxeq, EQ1, notGT1);

    mux_81 GTMUX(muxgt, select, 1'b0, 1'b0, notB0, 1'b0, 1'b1, 1'b0, 1'b1, notB0);
    and AND2(w1, muxgt, EQ1, notGT1);
    and AND3(w2, notEQ1, GT1);
    or OR1(GT0, w1, w2);


endmodule