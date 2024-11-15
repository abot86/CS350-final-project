module sra_tb;
    // inputs to the module (wire)
    wire [31:0] A;
    wire [4:0] shiftamt;
    // outputs of the module (wire)
    wire [31:0] result;
    // Instantiate the module to test
    sra SRA(A, shiftamt, result);

    assign A = 32'b00101100101101011011010101010111;
    // assign shiftamt = 4'b0101;

    // initial begin
    //     #20;
    //     $display("A:%b, shiftamt:%b, => result:%b", A, shiftamt, result);
    //     $finish;
    // end

    integer i; // Use a 32-Bit integer as the For Loop variable

    // Use the concatenation operator to quickly assign module inputs
    assign {shiftamt} = i[4:0]; // Cin = i[4], A = i[3:2], B = i[1:0]

    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            // Allow time for the outputs to stabilize
            #20;
            // Display the outputs for the current inputs
            $display("A:%b, shiftamt:%b, => result:%b", A, shiftamt, result);
        end
        // End the testbench
        $finish;
    end

    initial begin
        $dumpfile("Wave2.vcd");
        $dumpvars(0, sra_tb);
    end
endmodule
