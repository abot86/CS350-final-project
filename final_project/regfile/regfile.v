// INPUT JA FROM CONSTRAINTS

module regfile (
	clock, 
	ctrl_writeEnable, ctrl_reset, 
	ctrl_writeReg, ctrl_readRegA, ctrl_readRegB,
	JA, //JA == ADC
	data_writeReg,data_readRegA, data_readRegB, 
	PWMout, rest, active, 
	testing);

    output PWMout; input rest; input active;
    input [7:0] JA;
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	
	output [31:0] data_readRegA, data_readRegB;
	output [15:0] testing;


	wire [31:0] qReg0, qReg1, qReg2, qReg3, qReg4, qReg5, qReg6, qReg7, qReg8, qReg9, qReg10, qReg11, qReg12, qReg13, qReg14, qReg15, qReg16, qReg17, qReg18, qReg19, qReg20, qReg21, qReg22, qReg23, qReg24, qReg25, qReg26, qReg27, qReg28, qReg29, qReg30, qReg31;
	wire [31:0] write_slct;

	decoder32 WRITE_EN(write_slct, ctrl_writeReg, {31'b0, ctrl_writeEnable}); // might need to change ENABLE bit
	//and(en1, ctrl_writeEnable, write_slct[1]);


	// register: (out, in, clk, en, clr)

	//r0: 0
	register ZERO(qReg0, 32'b0, clock, 1'b0, 1'b0);

	//r1: ADC
	wire [31:0] adc;
	assign adc = {{24{1'b0}},JA};
	register REGISTER1(qReg1, adc, clock, 1'b1, ctrl_reset);
//	register REGISTER1(qReg1, data_writeReg, clock, write_slct[1], ctrl_reset);

	//r2: PWM duty-cycle output
	register REGISTER2(qReg2, data_writeReg, clock, write_slct[2], ctrl_reset);
	ServoController PWM_ctrl(.clk25mhz(clock), .reset(reset), .set_high_low(qReg2[0]), .servoSignal(PWMout));
//    assign PWMout = 1'b0;

	// normal
	register REGISTER3(qReg3, data_writeReg, clock, write_slct[3], ctrl_reset);
	register REGISTER4(qReg4, data_writeReg, clock, write_slct[4], ctrl_reset);

	// rest and active
	register rest_register5(qReg5, {{31{1'b0}},rest}, clock, 1'b1, ctrl_reset);
	register active_register6(qReg6, {{31{1'b0}},active}, clock, 1'b1, ctrl_reset);

	// normal
	register REGISTER7(qReg7, data_writeReg, clock, write_slct[7], ctrl_reset);

	// adc ready
	wire adc_ready;
	counter5k1 adc_rdy(clock, adc_ready);
	register REGISTER8(qReg8, {{31{1'b0}},adc_ready}, clock, 1'b1, ctrl_reset);

	// normal
	register REGISTER9(qReg9, data_writeReg, clock, write_slct[9], ctrl_reset);
	register REGISTER10(qReg10, data_writeReg, clock, write_slct[10], ctrl_reset);
	register REGISTER11(qReg11, data_writeReg, clock, write_slct[11], ctrl_reset);
	register REGISTER12(qReg12, data_writeReg, clock, write_slct[12], ctrl_reset);
	register REGISTER13(qReg13, data_writeReg, clock, write_slct[13], ctrl_reset);
	register REGISTER14(qReg14, data_writeReg, clock, write_slct[14], ctrl_reset);
	register REGISTER15(qReg15, data_writeReg, clock, write_slct[15], ctrl_reset);
	register REGISTER16(qReg16, data_writeReg, clock, write_slct[16], ctrl_reset);
	register REGISTER17(qReg17, data_writeReg, clock, write_slct[17], ctrl_reset);
	register REGISTER18(qReg18, data_writeReg, clock, write_slct[18], ctrl_reset);
	register REGISTER19(qReg19, data_writeReg, clock, write_slct[19], ctrl_reset);
	register REGISTER20(qReg20, data_writeReg, clock, write_slct[20], ctrl_reset);
	register REGISTER21(qReg21, data_writeReg, clock, write_slct[21], ctrl_reset);
	register REGISTER22(qReg22, data_writeReg, clock, write_slct[22], ctrl_reset);
	register REGISTER23(qReg23, data_writeReg, clock, write_slct[23], ctrl_reset);

	register REGISTER24(qReg24, data_writeReg, clock, write_slct[24], ctrl_reset);

	// LEDs testing: testing ADC rn
//	always @(posedge clock) begin
//		testing <= qReg1[15:0];
//	end

	// normal
	register REGISTER25(qReg25, data_writeReg, clock, write_slct[25], ctrl_reset);
	register REGISTER26(qReg26, data_writeReg, clock, write_slct[26], ctrl_reset);
	register REGISTER27(qReg27, data_writeReg, clock, write_slct[27], ctrl_reset);
	register REGISTER28(qReg28, data_writeReg, clock, write_slct[28], ctrl_reset);
	register REGISTER29(qReg29, data_writeReg, clock, write_slct[29], ctrl_reset);
	register REGISTER30(qReg30, data_writeReg, clock, write_slct[30], ctrl_reset);
	register REGISTER31(qReg31, data_writeReg, clock, write_slct[31], ctrl_reset);




	wire [31:0] toTriA;
	wire [31:0] toTriB;
	decoder32 RS1(toTriA, ctrl_readRegA, 32'b1);
	decoder32 RS2(toTriB, ctrl_readRegB, 32'b1);

	my_tri TRIA0(qReg0, toTriA[0], data_readRegA);
	my_tri TRIA1(qReg1, toTriA[1], data_readRegA);
	my_tri TRIA2(qReg2, toTriA[2], data_readRegA);
	my_tri TRIA3(qReg3, toTriA[3], data_readRegA);
	my_tri TRIA4(qReg4, toTriA[4], data_readRegA);
	my_tri TRIA5(qReg5, toTriA[5], data_readRegA);
	my_tri TRIA6(qReg6, toTriA[6], data_readRegA);
	my_tri TRIA7(qReg7, toTriA[7], data_readRegA);
	my_tri TRIA8(qReg8, toTriA[8], data_readRegA);
	my_tri TRIA9(qReg9, toTriA[9], data_readRegA);
	my_tri TRIA10(qReg10, toTriA[10], data_readRegA);
	my_tri TRIA11(qReg11, toTriA[11], data_readRegA);
	my_tri TRIA12(qReg12, toTriA[12], data_readRegA);
	my_tri TRIA13(qReg13, toTriA[13], data_readRegA);
	my_tri TRIA14(qReg14, toTriA[14], data_readRegA);
	my_tri TRIA15(qReg15, toTriA[15], data_readRegA);
	my_tri TRIA16(qReg16, toTriA[16], data_readRegA);
	my_tri TRIA17(qReg17, toTriA[17], data_readRegA);
	my_tri TRIA18(qReg18, toTriA[18], data_readRegA);
	my_tri TRIA19(qReg19, toTriA[19], data_readRegA);
	my_tri TRIA20(qReg20, toTriA[20], data_readRegA);
	my_tri TRIA21(qReg21, toTriA[21], data_readRegA);
	my_tri TRIA22(qReg22, toTriA[22], data_readRegA);
	my_tri TRIA23(qReg23, toTriA[23], data_readRegA);
	my_tri TRIA24(qReg24, toTriA[24], data_readRegA);
	my_tri TRIA25(qReg25, toTriA[25], data_readRegA);
	my_tri TRIA26(qReg26, toTriA[26], data_readRegA);
	my_tri TRIA27(qReg27, toTriA[27], data_readRegA);
	my_tri TRIA28(qReg28, toTriA[28], data_readRegA);
	my_tri TRIA29(qReg29, toTriA[29], data_readRegA);
	my_tri TRIA30(qReg30, toTriA[30], data_readRegA);
	my_tri TRIA31(qReg31, toTriA[31], data_readRegA);


	my_tri TRIB0(qReg0, toTriB[0], data_readRegB);
	my_tri TRIB1(qReg1, toTriB[1], data_readRegB);
	my_tri TRIB2(qReg2, toTriB[2], data_readRegB);
	my_tri TRIB3(qReg3, toTriB[3], data_readRegB);
	my_tri TRIB4(qReg4, toTriB[4], data_readRegB);
	my_tri TRIB5(qReg5, toTriB[5], data_readRegB);
	my_tri TRIB6(qReg6, toTriB[6], data_readRegB);
	my_tri TRIB7(qReg7, toTriB[7], data_readRegB);
	my_tri TRIB8(qReg8, toTriB[8], data_readRegB);
	my_tri TRIB9(qReg9, toTriB[9], data_readRegB);
	my_tri TRIB10(qReg10, toTriB[10], data_readRegB);
	my_tri TRIB11(qReg11, toTriB[11], data_readRegB);
	my_tri TRIB12(qReg12, toTriB[12], data_readRegB);
	my_tri TRIB13(qReg13, toTriB[13], data_readRegB);
	my_tri TRIB14(qReg14, toTriB[14], data_readRegB);
	my_tri TRIB15(qReg15, toTriB[15], data_readRegB);
	my_tri TRIB16(qReg16, toTriB[16], data_readRegB);
	my_tri TRIB17(qReg17, toTriB[17], data_readRegB);
	my_tri TRIB18(qReg18, toTriB[18], data_readRegB);
	my_tri TRIB19(qReg19, toTriB[19], data_readRegB);
	my_tri TRIB20(qReg20, toTriB[20], data_readRegB);
	my_tri TRIB21(qReg21, toTriB[21], data_readRegB);
	my_tri TRIB22(qReg22, toTriB[22], data_readRegB);
	my_tri TRIB23(qReg23, toTriB[23], data_readRegB);
	my_tri TRIB24(qReg24, toTriB[24], data_readRegB);
	my_tri TRIB25(qReg25, toTriB[25], data_readRegB);
	my_tri TRIB26(qReg26, toTriB[26], data_readRegB);
	my_tri TRIB27(qReg27, toTriB[27], data_readRegB);
	my_tri TRIB28(qReg28, toTriB[28], data_readRegB);
	my_tri TRIB29(qReg29, toTriB[29], data_readRegB);
	my_tri TRIB30(qReg30, toTriB[30], data_readRegB);
	my_tri TRIB31(qReg31, toTriB[31], data_readRegB);


endmodule
