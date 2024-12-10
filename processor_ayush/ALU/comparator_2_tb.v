module comparator_2_tb;
    // inputs to the module (wire)
    wire [1:0] A, B;
    wire EQ1, GT1;
    // outputs of the module (wire)
    wire EQ0, GT0;

    // Instantiate the module to test
    comparator_2 compare(EQ1, GT1, A, B, EQ0, GT0);

    integer i; // Use a 32-Bit integer as the For Loop variable

    // Use the concatenation operator to quickly assign module inputs
    assign {EQ1, GT1, A, B} = i[5:0]; // Cin = i[4], A = i[3:2], B = i[1:0]

    initial begin
        for(i = 0; i < 64; i = i + 1) begin
            // Allow time for the outputs to stabilize
            #20;
            // Display the outputs for the current inputs
            $display("A:%b, B:%b, EQ1:%b, GT1:%b => EQ0:%b, GT0:%b", A, B, EQ1, GT1, EQ0, GT0);
        end
        // End the testbench
        $finish;
    end

    initial begin
        $dumpfile("Wave1.vcd");
        $dumpvars(0, comparator_2_tb);
    end
endmodule
