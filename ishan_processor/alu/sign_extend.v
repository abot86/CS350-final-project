module sign_extend_17_32(out, in);
    input [16:0] in;
    output [31:0] out;
    assign out[16:0] = in;
    assign out[31:17] = {15{in[16]}};
endmodule