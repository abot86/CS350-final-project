module sll #(parameter WIDTH = 32) (in, out, sh_amt);
    input [4:0] sh_amt;
    input [WIDTH-1:0] in;
    output [WIDTH-1:0] out;

    wire [WIDTH-1:0] s1, s2, s4, s8, s16;
    wire [WIDTH-1:0] ta, tb, tc, td;
    wire [WIDTH-1:0] zero;
    
    assign zero = 32'd0;

    assign s1 = {in[WIDTH-2:0],zero[0]};
    assign ta = sh_amt[0] ? s1 : in;

    assign s2 = {ta[WIDTH-3:0],zero[1:0]};
    assign tb = sh_amt[1] ? s2 : ta;
    
    assign s4 = {tb[WIDTH-5:0],zero[3:0]};
    assign tc = sh_amt[2] ? s4 : tb;

    assign s8 = {tc[WIDTH-9:0],zero[7:0]};
    assign td = sh_amt[3] ? s8 : tc;

    assign s16 = {td[WIDTH-17:0],zero[15:0]};
    assign out = sh_amt[4] ? s16 : td;    
endmodule