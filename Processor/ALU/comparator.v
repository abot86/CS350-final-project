module comparator(A, B, EQ0, GT0);
    input [31:0] A, B;
    output EQ0, GT0;
    wire eq15, gt15, eq14, gt14, eq13, gt13, eq12, gt12, eq11, gt11, eq10, gt10, eq9, gt9, eq8, gt8, eq7, gt7, eq6, gt6, eq5, gt5, eq4, gt4, eq3, gt3, eq2, gt2, eq1, gt1;

    comparator_2 compare1(1'b1, 1'b0, A[31:30], B[31:30], eq15, gt15);
    comparator_2 compare2(eq15, gt15, A[29:28], B[29:28], eq14, gt14);
    comparator_2 compare3(eq14, gt14, A[27:26], B[27:26], eq13, gt13);
    comparator_2 compare4(eq13, gt13, A[25:24], B[25:24], eq12, gt12);

    comparator_2 compare5(eq12, gt12, A[23:22], B[23:22], eq11, gt11);
    comparator_2 compare6(eq11, gt11, A[21:20], B[21:20], eq10, gt10);
    comparator_2 compare7(eq10, gt10, A[19:18], B[19:18], eq9, gt9);
    comparator_2 compare8(eq9, gt9, A[17:16], B[17:16], eq8, gt8);

    comparator_2 compare9(eq8, gt8, A[15:14], B[15:14], eq7, gt7);
    comparator_2 compare10(eq7, gt7, A[13:12], B[13:12], eq6, gt6);
    comparator_2 compare11(eq6, gt6, A[11:10], B[11:10], eq5, gt5);
    comparator_2 compare12(eq5, gt5, A[9:8], B[9:8], eq4, gt4);

    comparator_2 compare13(eq4, gt4, A[7:6], B[7:6], eq3, gt3);
    comparator_2 compare14(eq3, gt3, A[5:4], B[5:4], eq2, gt2);
    comparator_2 compare15(eq2, gt2, A[3:2], B[3:2], eq1, gt1);
    comparator_2 compare16(eq1, gt1, A[1:0], B[1:0], EQ0, GT0);
    

endmodule