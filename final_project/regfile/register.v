module register #(parameter NUM_REG = 32) (out, in, clk, en, clr);
    input [NUM_REG-1:0] in;
    input clk, en, clr;
    output [NUM_REG-1:0] out;

    // USE GENVAR LOOPS
    genvar i;
    generate 
        for (i=0; i<NUM_REG; i=i+1) begin : dffe_gen
            dffe_ref dff(.q(out[i]), .d(in[i]), .clk(clk), .en(en), .clr(clr));
        end
    endgenerate
endmodule