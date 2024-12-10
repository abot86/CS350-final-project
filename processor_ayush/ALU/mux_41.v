module mux_41(out, select, in0, in1, in2, in3);
  input [1:0] select;
  input in0, in1, in2, in3;
  output out;
  wire w1, w2;
  mux_21 first_top(w1, select[0], in0, in1);
  mux_21 first_bottom(w2, select[0], in2, in3);
  mux_21 second(out, select[1], w1, w2);
endmodule