`timescale 1ns / 1ps

module mult_tb;

    // Inputs
    reg [31:0] data_operandA;
    reg [31:0] data_operandB;
    reg ctrl_MULT;
    reg ctrl_DIV;
    reg clock;

    // Outputs
    wire [31:0] data_result;
    wire data_exception;
    wire data_resultRDY;

    // Internal Wires (optional, if you want to monitor them)
    wire [64:0] inP, inPf, outP, pShifted, initP;
    wire [31:0] outM, inAdd, S, outAdd, shiftM, outShift;
    wire [2:0] ctrl;
    wire Cout;
    wire [3:0] count;

    // Instantiate the Unit Under Test (UUT)
    multdiv uut (
        .data_operandA(data_operandA), 
        .data_operandB(data_operandB), 
        .ctrl_MULT(ctrl_MULT), 
        .ctrl_DIV(ctrl_DIV), 
        .clock(clock), 
        .data_result(data_result), 
        .data_exception(data_exception), 
        .data_resultRDY(data_resultRDY)
    );

    // Assign internal wires to monitor (optional, for detailed observation)
    assign inP = uut.inP;
    assign outP = uut.outP;
    assign pShifted = uut.pShifted;
    assign initP = uut.initP;
    assign outM = uut.outM;
    assign inAdd = uut.inAdd;
    assign S = uut.S;
    assign outAdd = uut.outAdd;
    assign shiftM = uut.shiftM;
    assign outShift = uut.outShift;
    assign ctrl = uut.ctrl;
    assign Cout = uut.Cout;
    assign count = uut.count;
    assign inPf = uut.inPf;

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // 10ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        data_operandA = 32'd7;
        data_operandB = 32'd7;
        ctrl_MULT = 1'b0;
        ctrl_DIV = 1'b0;

        // Monitor all variables
        $monitor("Time = %0d\nA = %0b, B = %0b\nResult = %0b\nResultRDY = %0b\nCount = %0b\ninPf = %0b\noutP = %0b\npShifted = %0b\ninitP = %0b\noutM = %0b\ninAdd = %0b\nS = %0b\noutAdd = %0b\nshiftM = %0b\noutShift = %0b\nctrl = %0b\nCout = %0b\n", 
            $time, data_operandA, data_operandB, data_result, data_resultRDY, count, inPf, outP, pShifted, initP, outM, inAdd, S, outAdd, shiftM, outShift, ctrl, Cout);

        // Start the multiplication operation
        #10 ctrl_MULT = 1'b1;
        #10 ctrl_MULT = 1'b0;

        // Wait for result to be ready
        wait(data_resultRDY == 1'b1);

        // Stop the simulation after result is ready
        
        $finish;
    end

    initial begin
        $dumpfile("Wave1.vcd");
        $dumpvars(0, mult_tb);
    end

endmodule
