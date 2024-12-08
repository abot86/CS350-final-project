module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here

    // wires n all that ECE shit
    wire mul_on, div_on; 
    wire [31:0] data_result_mul, data_result_div;
    wire data_exception_mul, data_exception_div;
    wire data_resultRDY_mul, data_resultRDY_div; 

    // SR Latch to determine which operation is running
//    nor nor1(mul_on, ctrl_DIV, div_on);
//    nor nor2(div_on, ctrl_MULT, mul_on);

/*  SCUFFED COMMENTING BUT PERHAPS IT FIXES TIMING LOOP*/    
    // ONLY divides
     assign mul_on = 1'b0;

//    // MULTIPLY module
//    multiplier multiplies(
//        .data_operandA(data_operandA),
//        .data_operandB(data_operandB), 
//	    .ctrl_MULT(ctrl_MULT),
//        .ctrl_DIV(ctrl_DIV), 
//	    .clock(clock), 
//	    .data_result(data_result_mul),
//        .data_exception(data_exception_mul),
//        .data_resultRDY(data_resultRDY_mul)
//    );

//    // DIVIDER module
//    divider divides(
//        .data_operandA(data_operandA),
//        .data_operandB(data_operandB), 
//	    .ctrl_MULT(ctrl_MULT),
//        .ctrl_DIV(ctrl_DIV), 
//	    .clock(clock), 
//	    .data_result(data_result_div),
//        .data_exception(data_exception_div),
//        .data_resultRDY(data_resultRDY_div)
//    );

//    // FINAL OUTPUTS
//    assign data_result = mul_on ? data_result_mul : data_result_div;
//    assign data_exception = mul_on ? data_exception_mul : data_exception_div;
//    assign data_resultRDY = mul_on ? data_resultRDY_mul : data_resultRDY_div;

    assign data_result = data_operandA / data_operandB;
    assign data_ready = (ctrl_DIV) || (ctrl_MULT);
endmodule