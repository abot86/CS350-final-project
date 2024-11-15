module sra65 #(parameter WIDTH = 65) (out, in, sh_amt);
    input [4:0] sh_amt;
    input [WIDTH-1:0] in;
    output [WIDTH-1:0] out;

    // intermediate wires
    wire [WIDTH-1:0] s1, s2, s4, s8, s16;
    wire [WIDTH-1:0] ta, tb, tc, td;
    wire [WIDTH-1:0] zero;
    
    // reverse order; starts with least significant bit
    assign s1 = {in[WIDTH-1],in[WIDTH-1:1]};
    assign ta = sh_amt[0] ? s1 : in;

    assign s2 = {{2{ta[WIDTH-1]}},ta[WIDTH-1:2]};
    assign tb = sh_amt[1] ? s2 : ta;

    assign s4 = {{4{tb[WIDTH-1]}},tb[WIDTH-1:4]};
    assign tc = sh_amt[2] ? s4 : tb;

    assign s8 = {{8{tc[WIDTH-1]}},tc[WIDTH-1:8]};
    assign td = sh_amt[3] ? s8 : tc;

    assign s16 = {{16{td[WIDTH-1]}},td[WIDTH-1:16]};
    assign out = sh_amt[4] ? s16 : td;    
endmodule