module tff(q, clock, T, clr);
    input clock, T, clr;
    output q;
    wire w1a, w1b, w2;
    wire nT, nq;

    not notT(nT, T);
    not notQ(nq, q);

    and and_top(w1a, nT, q);
    and and_bottom(w1b, T, nq);
    or or1(w2, w1a, w1b);

    // DFF: No clear/enable bits to toggle for now
    dffe_ref dff(.q(q), .d(w2), .clk(clock), .en(1'b1), .clr(clr));
endmodule