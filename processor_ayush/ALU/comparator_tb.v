module comparator_tb;
    // inputs to the module (wire)
    wire [31:0] A, B;
    // outputs of the module (wire)
    wire EQ0, GT0;
    // Instantiate the module to test
    comparator compare(A, B, EQ0, GT0);

    assign A = 32'b01010101010101010101010101010101;
    assign B = 32'b10101010101010101010101010101010;

    initial begin
        #20;
        $display("A:%b, B:%b, => EQ0:%b, GT0:%b", A, B, EQ0, GT0);
        $finish;
    end

    // integer i; // Use a 32-Bit integer as the For Loop variable

    // // Use the concatenation operator to quickly assign module inputs
    // assign {A, B} = i[63:0]; // Cin = i[4], A = i[3:2], B = i[1:0]

    // initial begin
    //     for(i = 0; i < ; i = i + 1) begin
    //         // Allow time for the outputs to stabilize
    //         #20;
    //         // Display the outputs for the current inputs
    //         $display("A:%b, B:%b, => EQ0:%b, GT0:%b", A, B, EQ0, GT0);
    //     end
    //     // End the testbench
    //     $finish;
    // end

    initial begin
        $dumpfile("Wave2.vcd");
        $dumpvars(0, comparator_tb);
    end
endmodule
