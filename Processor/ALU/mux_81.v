module mux_81(out, select, in0, in1, in2, in3, in4, in5, in6, in7);

  input [2:0] select;
  input in0, in1, in2, in3, in4, in5, in6, in7;
  output out;
  wire w1, w2, w3, w4, w5, w6;
  mux_21 first_1(w1, select[0], in0, in1);
  mux_21 first_2(w2, select[0], in2, in3);
  mux_21 first_3(w3, select[0], in4, in5);
  mux_21 first_4(w4, select[0], in6, in7);

  mux_21 second_1(w5, select[1], w1, w2);
  mux_21 second_2(w6, select[1], w3, w4);

  mux_21 third(out, select[2], w5, w6);

endmodule