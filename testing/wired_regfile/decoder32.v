module decoder32(out, select, enable);
    input [4:0] select;
    input [31:0] enable;
    output [31:0] out;

    assign out = enable << select;
endmodule
