
module tff(q, t, clk, en, clr);
    //Inputs
    input t, clk, en, clr;

    //Output
    output q;

    //Wires
    wire w1, w2;
    wire qn, din;
    assign qn = ~q;
    
    //Logic to produce din
    and(w1, ~t, q);
    and(w2, t, qn);
    or(din, w1, w2);

    //To DFF
    dffe_ref DFF(q, din, clk, en, clr);
    

endmodule