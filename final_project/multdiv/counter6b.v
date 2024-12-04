module counter6b(out, clock, enable, dis, clr);
    input clock, enable, dis, clr;
    output [5:0] out;
    wire [4:0] t;
    wire on, off;   

    // SR Latch with enable/disable
    nor nor1(on, off, dis);
    nor nor2(off, on, enable);

    and and0(t[0], out[0],on);
    and and1(t[1], out[1],t[0]);
    and and2(t[2], out[2],t[1]);
    and and3(t[3], out[3],t[2]);
    and and4(t[4], out[4],t[3]);

    tff b0(.q(out[0]), .clock(clock), .T(on), .clr(clr));
    tff b1(.q(out[1]), .clock(clock), .T(t[0]), .clr(clr));
    tff b2(.q(out[2]), .clock(clock), .T(t[1]), .clr(clr));
    tff b3(.q(out[3]), .clock(clock), .T(t[2]), .clr(clr));
    tff b4(.q(out[4]), .clock(clock), .T(t[3]), .clr(clr));
    tff b5(.q(out[5]), .clock(clock), .T(t[4]), .clr(clr));

endmodule