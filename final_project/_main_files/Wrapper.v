`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (CLK100MHZ, BTNC, BTNL, BTNR, JA, JB, JB_clk, LED);
	input CLK100MHZ, BTNC;
	input [7:0] JA;
	input BTNL, BTNR;

	output JB, JB_clk;
	output [15:0] LED;
	
	assign LED[7:0] = JA;

	wire clock, clk25mhz;

	wire reset;
	assign reset = BTNC;


	// clock - NOT PLL
    reg[3:0] counter;
    always @(posedge CLK100MHZ) begin
        counter <= counter + 1;
    end
    assign clk25mhz = counter[1];

//	assign clock = clk25mhz;
//    clk_wiz_0 PLL(
//        .clk_out1(clk25mhz),
//        .reset(reset),
//        .locked(locked),
//        .clk_in1(CLK100MHZ));

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;


	// ADD YOUR MEMORY FILE HERE - COMMENTED OUT
//	localparam INSTR_FILE = "C:/Users/ab973/Desktop/CS350-final-project/main";
	
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
//	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
//	InstMem(.clk(clock), 
//		.addr(instAddr[11:0]), 
//		.dataOut(instData));
	
	
	//REGFILE COMMENTED OUT
//	wire [15:0] led_input;
//    always @(posedge clk25mhz) begin
//        LED <= led_input;
//    end
    	
//	// Register File
//	regfile RegisterFile(.clock(clock), 
//		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
//		.ctrl_writeReg(rd),
//		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2),
//		.JA(JA), 
//		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
//		.PWMout(JB), .rest(BTNL), .active(BTNR), .testing(led_input));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

	// JB_clk
	clock_25M_500k JB_clock_module(clk25mhz, reset, JB_clk);
//    assign JB_clk = 1'b0;

endmodule
