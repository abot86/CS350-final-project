module adder_block_tb;
    // inputs to the module (wire)
    wire [7:0] A, B;
    wire c0;
    // outputs of the module (wire)
    wire c8;
    wire [7:0] S;

    // Instantiate the module to test
    adder_block add(A, B, c0, S, c8);

    integer i; // Use a 32-Bit integer as the For Loop variable

    // Use the concatenation operator to quickly assign module inputs
    assign {A, B, c0} = i[16:0]; // Cin = i[4], A = i[3:2], B = i[1:0]

    initial begin
        for(i = 0; i < 2**17; i = i + 1) begin
            // Allow time for the outputs to stabilize
            #20;
            // Display the outputs for the current inputs
            $display("A:%b, B:%b, C0:%b => S:%b, C8:%b", A, B, c0, S, c8);
        end
        // End the testbench
        $finish;
    end

    initial begin
        $dumpfile("Wave1.vcd");
        $dumpvars(0, adder_block_tb);
    end
endmodule
