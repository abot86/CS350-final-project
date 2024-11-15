module mux_23(out, select, in0, in1);
  input select;
  input [2:0] in0, in1;
  output [2:0] out;
  assign out = select ? in1 : in0;
endmodule