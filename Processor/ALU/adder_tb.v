module adder_tb;
    // inputs to the module (wire)
    wire [31:0] A, B;
    wire Cin;
    // outputs of the module (wire)
    wire Cout;
    wire [31:0] S;

    // Instantiate the module to test
    adder add(A, B, Cin, S, Cout);

    // Use the concatenation operator to quickly assign module inputs
    assign A = 32'b10101;
    assign B = 32'b100110011;
    assign Cin = 0;

    initial begin
        #20;
        $display("A:%d, B:%d, Cin:%d => S:%d, Cout:%d", A, B, Cin, S, Cout);
        $finish;
    end

    initial begin
        $dumpfile("Wave1.vcd");
        $dumpvars(0, adder_tb);
    end
endmodule
