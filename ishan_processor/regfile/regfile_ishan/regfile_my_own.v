module regfile_my_own (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire [31:0] out_reg;

	// module register(out, in, clk, en, clr);
	// module dffe_ref (q, d, clk, en, clr);
	// module decoder32(out, select, enable);

	// create necessary decoders
	wire [31:0] RDbus, RS1bus, RS2bus;
	decoder32 RD(RDbus,ctrl_writeReg,1'b1);
	decoder32 RS1(RS1bus, ctrl_readRegA,1'b1);
	decoder32 RS2(RS2bus, ctrl_readRegB,1'b1);


	// makes each individual register. Output is 32x32 bus array stored as 1024x1 bus array.
	wire [1023:0] reg_out;
	wire [31:0] reg_in_enable;
	genvar regn;
	genvar tri_state;
	// make 0th register
	and register_enable_and0(reg_in_enable[0], ctrl_writeEnable, RDbus[0]);
	register regfile0(.out(reg_out[(31):(0)]), .in(data_writeReg), .clk(clock), .en(1'b0), .clr(ctrl_reset));
	// before, above was the following: .en(reg_in_enable[0])
	generate 
		for (tri_state=0;tri_state<32;tri_state = tri_state + 1) begin: tri_state_buffers0
				assign data_readRegA[tri_state] = RS1bus[0] ? 1'b0 : 1'bZ;
				assign data_readRegB[tri_state] = RS2bus[0] ? 1'b0 : 1'bZ;
			end
	endgenerate
	generate 
        for (regn=1; regn<32; regn = regn + 1) begin : registers
			and register_enable_ands(reg_in_enable[regn], ctrl_writeEnable, RDbus[regn]);
            register regfiles(.out(reg_out[(32*regn+31):(32*regn)]), 
				.in(data_writeReg), .clk(clock), .en(reg_in_enable[regn]), .clr(ctrl_reset));
			for (tri_state=0;tri_state<32;tri_state = tri_state + 1) begin: tri_state_buffers
				assign data_readRegA[tri_state] = RS1bus[regn] ? reg_out[32*regn+tri_state] : 1'bZ;
				assign data_readRegB[tri_state] = RS2bus[regn] ? reg_out[32*regn+tri_state] : 1'bZ;
			end
        end
    endgenerate



endmodule
