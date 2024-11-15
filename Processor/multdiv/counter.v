module counter(q, clk, en, clr);
    input clk, en, clr;

    output [5:0] q;

    wire en1, en2, en3, en4, en5;

    and(en1, q[0], en);
    and(en2, q[1], en1);
    and(en3, q[2], en2);
    and(en4, q[3], en3);
    and(en5, q[4], en4);

    tff TFF0(q[0], en, clk, en, clr);
    tff TFF1(q[1], en1, clk, en1, clr);
    tff TFF2(q[2], en2, clk, en2, clr);
    tff TFF3(q[3], en3, clk, en3, clr);
    tff TFF4(q[4], en4, clk, en4, clr);
    tff TFF5(q[5], en5, clk, en5, clr);

endmodule
