/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    wire not_clock;
    assign not_clock = !clock;
    wire [31:0] nop;
    assign nop = 32'd0;

    ////////// START OF FETCH //////////

    wire [31:0] pc_in, pc_plus_one;
    wire [4:0] stall_logic;
    wire [1:0] pc_branch_control;
    
	register program_counter(.out(address_imem), .in(pc_in), .clk(not_clock), .en(!stall_logic[0]), .clr(reset));
    alu_cla_outer pc_plus_one_adder(.data_operandA(address_imem), .data_operandB(32'd1), .Cin(1'd0), .data_result(pc_plus_one), .Cout());
    

    // next PC calculation [SEE branching IN EXECUTE FOR LOGIC/DESTINATION CALCULATION]
    mux4 pc_branch_control_mux(.out(pc_in), .select(pc_branch_control), .in0(pc_plus_one), .in1(pc_plus_N), .in2(execute_true_B), .in3(pc_T));
    /*      PC+1:       pc_plus_one
            PC+1+N:     pc_plus_N
            $rd:        decode_B_out
            T:          pc_T
    */

    // flush logic
    assign fetch_INSN_in = |pc_branch_control ? nop : q_imem;

    ////////// END OF FETCH //////////
    wire [31:0] fetch_PC_out, fetch_INSN_out_raw, fetch_INSN_in;
    register fetch_PC(.out(fetch_PC_out), .in(pc_in), .clk(not_clock), .en(!stall_logic[1]), .clr(reset));
    register fetch_INSN(.out(fetch_INSN_out_raw), .in(fetch_INSN_in), .clk(not_clock), .en(!stall_logic[1]), .clr(reset));
    ////////// START OF DECODE //////////
    // flush logic 
    wire [31:0] fetch_INSN_out; // does this break my code? ans: yes ( || stall_logic[1])
    assign fetch_INSN_out = (|pc_branch_control) ? nop : fetch_INSN_out_raw;
    
    wire ctrl_readRegB_logic;
    assign ctrl_readRegB_logic = !(|(fetch_INSN_out[31:27]^5'b00110)) || !(|(fetch_INSN_out[31:27]^5'b00010))
            || !(|(fetch_INSN_out[31:27]^5'b00111)) || !(|(fetch_INSN_out[31:27]^5'b00010))
            || !(|(fetch_INSN_out[31:27]^5'b00100));

    /* ONLY INTERRACT WITH REGFILE VIA I/O OF PROCESSOR, NOT BY DIRECT INSTANTIAION */
    // assign ctrl_writeEnable IS DONE IN WRITEBACK STAGE
    // assign ctrl_writeReg IS DONE IN WRITEBACK STAGE
    assign ctrl_readRegA = !(|(fetch_INSN_out[31:27]^5'b10110)) ? 5'b11110 : fetch_INSN_out[21:17];
    assign ctrl_readRegB = ctrl_readRegB_logic ? fetch_INSN_out[26:22] : fetch_INSN_out[16:12]; 
	// assign data_writeReg IS DONE IN WRITEBACK STAGE

    wire [31:0] decode_INSN_in;
    assign decode_INSN_in = lw_stall ? nop : fetch_INSN_out;
    ////////// END OF DECODE //////////
    wire [31:0] decode_PC_out, decode_A_out, decode_B_out, decode_INSN_out;  
    register decode_PC(.out(decode_PC_out), .in(fetch_PC_out), .clk(not_clock), .en(!stall_logic[2]), .clr(reset));
    register decode_A(.out(decode_A_out), .in(data_readRegA), .clk(not_clock), .en(!stall_logic[2]), .clr(reset));
    register decode_B(.out(decode_B_out), .in(data_readRegB), .clk(not_clock), .en(!stall_logic[2]), .clr(reset));
    register decode_INSN(.out(decode_INSN_out), .in(decode_INSN_in), .clk(not_clock), .en(!stall_logic[2]), .clr(reset));
    ////////// START OF EXECUTE //////////

    // true A, true B
    wire [31:0] execute_true_A, execute_true_B;
    // bypass 4: M->X A AND bypass 1: W->X A   
    assign execute_true_A = 
        ((!(|(decode_INSN_out[21:17]^execute_INSN_out[26:22])) && |execute_INSN_out[26:22] && execute_INSN_out[31:27]!=5'b00111)
        ? execute_O_out : 
            ((!(|(decode_INSN_out[21:17]^memory_INSN_out[26:22])) && |memory_INSN_out[26:22] && ctrl_writeEnable) 
            ? data_writeReg :
            (((!(|(decode_INSN_out[31:27]^5'b10110)) || !(|(decode_INSN_out[21:17]^5'b11110)))) && !(|(execute_INSN_out[31:27]^5'b10101))) 
                ? {{5{execute_INSN_out[26]}},execute_INSN_out[26:0]} 
                : (((!(|(decode_INSN_out[21:17]^5'b11110)) || !(|(decode_INSN_out[31:27]^5'b10110))) && !(|(memory_INSN_out[31:27]^5'b10101))) ? setx_T_extended : decode_A_out)));
    
    // bypass 5: M->X B AND bypass 2: W->X B 
    assign execute_true_B = 
    (((!(|(decode_INSN_out[16:12]^memory_INSN_out[26:22])) && |memory_INSN_out[26:22] && ctrl_writeEnable)
            || (!(|(decode_INSN_out[26:22]^memory_INSN_out[26:22])) && (!(|(decode_INSN_out[31:27]^5'b00010)) || !(|(decode_INSN_out[31:27]^5'b00110)) || !(|(decode_INSN_out[31:27]^5'b00100))))
            || (decode_INSN_out[26:22]==memory_INSN_out[26:22] && decode_INSN_out[31:27]==5'b00111 && ctrl_writeEnable))
        ? data_writeReg 
        : (((!(|(decode_INSN_out[16:12]^execute_INSN_out[26:22])) && |execute_INSN_out[26:22]) || (!(|(decode_INSN_out[31:27]^5'b00100)) && !(|(execute_INSN_out[26:22]^decode_INSN_out[26:22])))
                    || (!(|(decode_INSN_out[26:22]^execute_INSN_out[26:22])) && (!(|(decode_INSN_out[31:27]^5'b00010)) || !(|(decode_INSN_out[31:27]^5'b00110)))) 
                    || (decode_INSN_out[26:22]==execute_INSN_out[26:22] && decode_INSN_out[31:27]==5'b00111 && execute_INSN_out[31:27]!=5'b00111)) 
            ? execute_O_out :
            (((!(|(decode_INSN_out[16:12]^5'b11110))) && !(|(execute_INSN_out[31:27]^5'b10101)))
                ? {{5{execute_INSN_out[26]}},execute_INSN_out[26:0]} : 
                    (((!(|(decode_INSN_out[16:12]^5'b11110))) && !(|(memory_INSN_out[31:27]^5'b10101))) ? setx_T_extended : decode_B_out))));

    /// MUX for B input
    wire use_sign_extend_execute;
    assign use_sign_extend_execute = !(|(decode_INSN_out[31:27]^5'b00101)) || !(|(decode_INSN_out[31:27]^5'b00111)) || !(|(decode_INSN_out[31:27]^5'b01000));
    wire [31:0] sign_extend_immed_out;
    sign_extend_17_32 extender(.out(sign_extend_immed_out), .in(decode_INSN_out[16:0]));

    // ALU opcode -> account for addi insn needing opcode to be 00000. also sw 
    wire [4:0] execute_alu_opc;
    wire [1:0] alu_opc_is_diff;
    assign alu_opc_is_diff[0] = !(|(decode_INSN_out[31:27]^5'b00101))  || !(|(decode_INSN_out[31:27]^5'b00111)) || !(|(decode_INSN_out[31:27]^5'b01000)); // is addi OR sw/lw
    assign alu_opc_is_diff[1] = !(|(decode_INSN_out[31:27]^5'b00010)) || !(|(decode_INSN_out[31:27]^5'b00110)); // is branch
    mux4 #(5) execute_alu_opc_mux(.out(execute_alu_opc), .select(alu_opc_is_diff), .in0(decode_INSN_out[6:2]), .in1(5'b00000), .in2(5'b00001), .in3(5'b00000));

    // ALU
    wire [31:0] alu_out, alu_B_in;
    wire alu_isNE, alu_isLT, alu_ovf;
    assign alu_B_in = use_sign_extend_execute ? sign_extend_immed_out : execute_true_B; // specifically for sw case to allow bypassing
    alu execute_alu(
            .data_operandA(execute_true_A), .data_operandB(alu_B_in),
            .ctrl_ALUopcode(execute_alu_opc), .ctrl_shiftamt(decode_INSN_out[11:7]),
            .data_result(alu_out),
            .isNotEqual(alu_isNE), .isLessThan(alu_isLT), .overflow(alu_ovf));    

    // branching: destination calculation
    wire [31:0] pc_plus_N, pc_T;
    alu_cla_outer pc_plus_N_alu(.data_operandA(decode_PC_out), .data_operandB(sign_extend_immed_out), .Cin(1'b0), .data_result(pc_plus_N), .Cout());
    assign pc_T[26:0] = decode_INSN_out[26:0];
    assign pc_T[31:27] = {5{decode_INSN_out[26]}};

    // branching: logic calculation
    wire [4:0] decode_out_opcode;
    wire take_pc_N, take_T, take_rd;
    assign decode_out_opcode = decode_INSN_out[31:27]; 
    assign take_pc_N = (!(|(decode_out_opcode^5'b00010)) && (alu_isNE)) || (!(|(decode_out_opcode^5'b00110)) && (!alu_isLT) && alu_isNE);
    assign take_T = (!(|(decode_out_opcode^5'b00011))) || (!(|(decode_out_opcode^5'b10110)) && (|(execute_true_A))) || (!(|(decode_out_opcode^5'b00001)));
    assign take_rd = (!(|(decode_out_opcode^5'b00100)));

    // mux assignment: {00,01,10,11} = {+1, +N+1, T, $rd}
    assign pc_branch_control[0] = take_pc_N || take_T;
    assign pc_branch_control[1] = take_rd || take_T;

    //// MULTIPLICATION / DIVISION
    wire [31:0] multdiv_out;
    wire is_mult, is_div, multdiv_exception, multdiv_RDY;
    assign is_mult = !(|decode_out_opcode) && !(|(decode_INSN_out[6:2]^5'b00110));
    assign is_div = !(|decode_out_opcode) && !(|(decode_INSN_out[6:2]^5'b00111));

    // positive edge-triggered pulse generator 
    wire ctrl_MULT, ctrl_DIV, is_mult_delayed, is_div_delayed;
    dffe_ref ctrl_MULT_delayed(.q(is_mult_delayed), .d(is_mult), .clk(not_clock), .en(1'b1), .clr(reset));
    assign ctrl_MULT = (!is_mult_delayed && is_mult) || mult_RDY_neg_edge;
    dffe_ref ctrl_DIV_delayed(.q(is_div_delayed), .d(is_div), .clk(not_clock), .en(1'b1), .clr(reset));
    assign ctrl_DIV = (!is_div_delayed && is_div) || div_RDY_neg_edge;
    // account for case of successive M/D
    wire mult_RDY_neg_edge, div_RDY_neg_edge, multdiv_RDY_delayed;
    dffe_ref ctrl_MD_neg_edge(.q(multdiv_RDY_delayed), .d(multdiv_RDY), .clk(not_clock), .en(1'b1), .clr(reset));
    assign mult_RDY_neg_edge = (!multdiv_RDY) && (multdiv_RDY_delayed) && is_mult;
    assign div_RDY_neg_edge = (!multdiv_RDY) && (multdiv_RDY_delayed) && is_div;

    multdiv multdiv_module(
        .data_operandA(execute_true_A), .data_operandB(execute_true_B), 
        .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), 
        .clock(not_clock), 
        .data_result(multdiv_out), .data_exception(multdiv_exception), .data_resultRDY(multdiv_RDY));
    
    // stall for when (is_mult OR is_div) AND (not ready)
    wire multdiv_stall;
    assign multdiv_stall = (is_mult || is_div) && (!multdiv_RDY);
    // stall logic assigned at bottom
    
    // \\  // \\ output selector
    wire [31:0] execute_O_in;
    wire [1:0] execute_output_selector;
    wire execute_overflow;
    assign execute_overflow = (alu_ovf && (!(|(decode_out_opcode^5'b00000)) || !(|(decode_out_opcode^5'b00101)))) ||
        (multdiv_exception && !(|(decode_out_opcode^5'b00000)) && (!(|(decode_INSN_out[6:2]^5'b00110)) || !(|(decode_INSN_out[6:2]^5'b00111))));
    assign execute_output_selector[0] = (is_mult || is_div) || execute_overflow;
    assign execute_output_selector[1] = !(|(decode_out_opcode^5'b00011)) || execute_overflow;

    // mux8 for rstatus overwrite
    wire ovw_add, ovw_addi, ovw_sub, ovw_mul, ovw_div; 
    assign ovw_add = !(|(decode_INSN_out[31:27]^5'b00000)) && !(|(decode_INSN_out[6:2]^5'b00000));
    assign ovw_addi = !(|(decode_INSN_out[31:27]^5'b00101));
    assign ovw_sub = !(|(decode_INSN_out[31:27]^5'b00000)) && !(|(decode_INSN_out[6:2]^5'b00001));
    assign ovw_mul = !(|(decode_INSN_out[31:27]^5'b00000)) && !(|(decode_INSN_out[6:2]^5'b00110));
    assign ovw_div = !(|(decode_INSN_out[31:27]^5'b00000)) && !(|(decode_INSN_out[6:2]^5'b00111));

    // use high impedance
    wire [26:0] setx_T_insn; 
    assign setx_T_insn = ovw_add ? {27'd1} : {27{1'bZ}}; 
    assign setx_T_insn = ovw_addi ? {27'd2} : {27{1'bZ}}; 
    assign setx_T_insn = ovw_sub ? {27'd3} : {27{1'bZ}}; 
    assign setx_T_insn = ovw_mul ? {27'd4} : {27{1'bZ}}; 
    assign setx_T_insn = ovw_div ? {27'd5} : {27{1'bZ}}; 

    // {00,01,10,11} = {alu,multdiv,PC(jal),setx override}
    mux4 execute_output_select(.out(execute_O_in), .select(execute_output_selector), .in0(alu_out), .in1(multdiv_out), .in2(decode_PC_out), .in3(32'd0));

    ////////// END OF EXECUTE //////////
    wire [31:0] execute_pc_out, execute_O_out, execute_B_out, execute_INSN_out, execute_INSN_in;
    wire execute_overflow_ex;
    assign execute_INSN_in = execute_overflow ? {5'b10101,setx_T_insn} : decode_INSN_out;
    register execute_O(.out(execute_O_out), .in(execute_O_in), .clk(not_clock), .en(!stall_logic[3]), .clr(reset));
    register execute_B(.out(execute_B_out), .in(execute_true_B), .clk(not_clock), .en(!stall_logic[3]), .clr(reset));
    register execute_INSN(.out(execute_INSN_out), .in(execute_INSN_in), .clk(not_clock), .en(!stall_logic[3]), .clr(reset));
    dffe_ref execute_overflow_dff_ex(.q(execute_overflow_ex), .d(execute_overflow), .clk(not_clock), .en(!stall_logic[4]), .clr(reset));
    ////////// START OF MEMORY //////////
        
    assign address_dmem = execute_O_out;
    assign wren = !(|(execute_INSN_out[31:27]^5'b00111));

    // bypass 3: W->M B [logic: doing SW AND need to writeback reg value]
    assign data = (!(|(execute_INSN_out[31:27]^5'b00111)) && !(|(execute_INSN_out[26:22]^memory_INSN_out[26:22])) && (ctrl_writeEnable))
        ? ((|(memory_INSN_out[31:27]^5'b01000)) ? data_writeReg : memory_D_out) : execute_B_out; 
    

    ////////// END OF MEMORY //////////
    wire [31:0] memory_O_out, memory_D_out, memory_INSN_out;
    wire execute_overflow_mem;
    register memory_O(.out(memory_O_out), .in(execute_O_out), .clk(not_clock), .en(!stall_logic[4]), .clr(reset));
    register memory_D(.out(memory_D_out), .in(q_dmem), .clk(not_clock), .en(!stall_logic[4]), .clr(reset));
    register memory_INSN(.out(memory_INSN_out), .in(execute_INSN_out), .clk(not_clock), .en(!stall_logic[4]), .clr(reset));
    dffe_ref execute_overflow_dff_mem(.q(execute_overflow_mem), .d(execute_overflow_ex), .clk(not_clock), .en(!stall_logic[4]), .clr(reset));
    ////////// START OF WRITEBACK //////////
    
    wire [4:0] wb_opc;
    assign wb_opc = memory_INSN_out[31:27];
    assign ctrl_writeEnable =   !(|(wb_opc^5'b00000) || !(|memory_INSN_out)) || !(|(wb_opc^5'b00101)) || !(|(wb_opc^5'b01000)) 
                                || !(|(wb_opc^5'b00011)) || !(|(wb_opc^5'b10101));
    mux4 data_writeReg_mux(.out(data_writeReg), .select(data_writeReg_controller),
            .in0(memory_O_out), .in1(memory_D_out), .in2(setx_T_extended), .in3(32'd0));    
    mux4 #(5) ctrl_writeReg_mux(.out(ctrl_writeReg), .select(ctrl_writeReg_controller), .in0(memory_INSN_out[26:22]), .in1(5'b11110), .in2(5'b11111), .in3(5'd0));

    // ctrls for ctrl_writeReg
    wire ctrl_writeReg_rstatus, ctrl_writeReg_r31;
    wire [1:0] ctrl_writeReg_controller; 
    assign ctrl_writeReg_rstatus = !(|(wb_opc^5'b10101)) || (execute_overflow_mem && !(|(wb_opc^5'b00000))); // setx,ovf
    assign ctrl_writeReg_r31 = !(|(wb_opc^5'b00011)); // JAL
    assign ctrl_writeReg_controller = {ctrl_writeReg_r31, ctrl_writeReg_rstatus};

    // ctrls for data_writeReg
    wire [1:0] data_writeReg_controller;
    wire [31:0] setx_T_extended;
    assign data_writeReg_controller[0] = !(|(wb_opc^5'b01000));
    assign data_writeReg_controller[1] = !(|(wb_opc^5'b10101));
    assign setx_T_extended[26:0] = memory_INSN_out[26:0];
    assign setx_T_extended[31:27] = {5{memory_INSN_out[26]}};
 
    ////////// END OF WRITEBACK //////////
    ////////// START OF STALL LOGIC AND HAZARD DETECTION //////////

    // stall logic == 1 WHEN NEED TO STALL; 
    assign stall_logic[0] = multdiv_stall || lw_stall;
    assign stall_logic[1] = multdiv_stall || lw_stall;
    assign stall_logic[2] = multdiv_stall;
    assign stall_logic[3] = multdiv_stall;
    assign stall_logic[4] = multdiv_stall;

    // stalling condition 
    wire lw_stall;
    assign lw_stall = (!(|(ctrl_readRegA^decode_INSN_out[26:22])) && !(|(decode_INSN_out[31:27]^5'b01000))) 
                || (!(|(ctrl_readRegB^decode_INSN_out[26:22])) && !(|(decode_INSN_out[31:27]^5'b01000)) && (|(fetch_INSN_out[31:27]^5'b00111)))
        // or branching condition too
                || (!(|(fetch_INSN_out[26:22]^decode_INSN_out[26:22])) && !(|(decode_INSN_out[31:27]^5'b01000)) && (!(|(fetch_INSN_out[31:27]^5'b00010)) || !(|(fetch_INSN_out[31:27]^5'b00110))));

    /* END CODE */

endmodule