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

    wire [31:0] FD_PC, FD_IR;
    wire [31:0] DX_PC, DX_IR, DX_A, DX_B;
    wire [31:0] XM_IR, XM_O, XM_B;
    wire [31:0] MW_IR, MW_O, MW_D;



// Opcodes --> wires
    wire D_add, X_add, M_add, W_add, D_addi, X_addi, M_addi, W_addi, 
    D_sub, X_sub, M_sub, W_sub, D_and, X_and, M_and, W_and, 
    D_or, X_or, M_or, W_or, D_sll, X_sll, M_sll, W_sll, D_sra, X_sra, M_sra, W_sra, 
    D_mul, X_mul, M_mul, W_mul, D_div, X_div, M_div, W_div, D_sw, X_sw, M_sw, W_sw, 
    D_lw, X_lw, M_lw, W_lw, D_j, X_j, M_j, W_j, D_bne, X_bne, M_bne, W_bne, 
    D_jal, X_jal, M_jal, W_jal, D_jr, X_jr, M_jr, W_jr, D_blt, X_blt, M_blt, W_blt, 
    D_bex, X_bex, M_bex, W_bex, D_setx, X_setx, M_setx, W_setx;

    // R-type
    // add
    assign D_add = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00000);
    assign X_add = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00000);
    assign M_add = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00000);
    assign W_add = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00000);

    // sub
    assign D_sub = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00001);
    assign X_sub = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00001);
    assign M_sub = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00001);
    assign W_sub = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00001);

    // and
    assign D_and = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00010);
    assign X_and = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00010);
    assign M_and = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00010);
    assign W_and = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00010);

    // or
    assign D_or = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00011);
    assign X_or = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00011);
    assign M_or = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00011);
    assign W_or = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00011);

    // sll
    assign D_sll = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00100);
    assign X_sll = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00100);
    assign M_sll = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00100);
    assign W_sll = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00100);

    // sra
    assign D_sra = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00101);
    assign X_sra = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00101);
    assign M_sra = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00101);
    assign W_sra = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00101);

    // mul
    assign D_mul = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00110);
    assign X_mul = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00110);
    assign M_mul = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00110);
    assign W_mul = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00110);

    // div
    assign D_div = (FD_IRout[31:27] == 5'b00000) & (FD_IR[6:2] == 5'b00111);
    assign X_div = (DX_IR[31:27] == 5'b00000) & (DX_IR[6:2] == 5'b00111);
    assign M_div = (XM_IR[31:27] == 5'b00000) & (XM_IR[6:2] == 5'b00111);
    assign W_div = (MW_IR[31:27] == 5'b00000) & (MW_IR[6:2] == 5'b00111);

    // I-type and J-type
    // addi
    assign D_addi = (FD_IRout[31:27] == 5'b00101);
    assign X_addi = (DX_IR[31:27] == 5'b00101);
    assign M_addi = (XM_IR[31:27] == 5'b00101);
    assign W_addi = (MW_IR[31:27] == 5'b00101);

    // sw
    assign D_sw = (FD_IRout[31:27] == 5'b00111);
    assign X_sw = (DX_IR[31:27] == 5'b00111);
    assign M_sw = (XM_IR[31:27] == 5'b00111);
    assign W_sw = (MW_IR[31:27] == 5'b00111);

    // lw
    assign D_lw = (FD_IRout[31:27] == 5'b01000);
    assign X_lw = (DX_IR[31:27] == 5'b01000);
    assign M_lw = (XM_IR[31:27] == 5'b01000);
    assign W_lw = (MW_IR[31:27] == 5'b01000);

    // j
    assign D_j = (FD_IRout[31:27] == 5'b00001);
    assign X_j = (DX_IR[31:27] == 5'b00001);
    assign M_j = (XM_IR[31:27] == 5'b00001);
    assign W_j = (MW_IR[31:27] == 5'b00001);

    // bne
    assign D_bne = (FD_IRout[31:27] == 5'b00010);
    assign X_bne = (DX_IR[31:27] == 5'b00010);
    assign M_bne = (XM_IR[31:27] == 5'b00010);
    assign W_bne = (MW_IR[31:27] == 5'b00010);

    // jal
    assign D_jal = (FD_IRout[31:27] == 5'b00011);
    assign X_jal = (DX_IR[31:27] == 5'b00011);
    assign M_jal = (XM_IR[31:27] == 5'b00011);
    assign W_jal = (MW_IR[31:27] == 5'b00011);

    // jr
    assign D_jr = (FD_IRout[31:27] == 5'b00100);
    assign X_jr = (DX_IR[31:27] == 5'b00100);
    assign M_jr = (XM_IR[31:27] == 5'b00100);
    assign W_jr = (MW_IR[31:27] == 5'b00100);

    // blt
    assign D_blt = (FD_IRout[31:27] == 5'b00110);
    assign X_blt = (DX_IR[31:27] == 5'b00110);
    assign M_blt = (XM_IR[31:27] == 5'b00110);
    assign W_blt = (MW_IR[31:27] == 5'b00110);

    // bex
    assign D_bex = (FD_IRout[31:27] == 5'b10110);
    assign X_bex = (DX_IR[31:27] == 5'b10110);
    assign M_bex = (XM_IR[31:27] == 5'b10110);
    assign W_bex = (MW_IR[31:27] == 5'b10110);

    // setx
    assign D_setx = (FD_IRout[31:27] == 5'b10101);
    assign X_setx = (DX_IR[31:27] == 5'b10101);
    assign M_setx = (XM_IR[31:27] == 5'b10101);
    assign W_setx = (MW_IR[31:27] == 5'b10101);



//FETCH
    wire [31:0] F_PCplus, F_PCin, FD_IRin;
    wire STALL, X_JorB;

	register PC(.q(address_imem), .d(F_PCin), .clk(~clock), .en(~(multdivSTALL | STALL)), .clr(1'b0));  // Store PC

    adder PCplus(.A(address_imem), .B(32'b0), .Cin(1'b1), .S(F_PCplus), .Cout());   // Increment PC by 1

    assign X_JorB = ((X_bne&X_notEqual) | (X_blt&X_lessThan) | (X_bex & (X_inBbypass != 32'b0)) | X_j | X_jal | X_jr);  // Is a branch or jump taken?
    assign F_PCin = X_JorB ? X_target : F_PCplus;

    assign FD_IRin = X_JorB ? 32'b0 : q_imem;

    // Stall when executing lw and (D.RS1 = X.RD or D.RS2 = X.RD or (decoding jr and D.RD = X.RD))
    assign STALL = X_lw & ((FD_IRout[21:17] == DX_IR[26:22]) | ((FD_IRout[16:12] == DX_IR[26:22]) & ~D_sw) | ((D_jr & (FD_IRout[26:22] == DX_IR[26:22]))) |
                    ((D_blt|D_bne) & (FD_IRout[26:22] == DX_IR[26:22] | FD_IRout[21:17] == DX_IR[26:22]))) & 
                    (|DX_IR[26:22]);

//DECODE
    // Define FD latch
    wire [31:0] FD_IRout;
    register FDPC(.q(FD_PC), .d(F_PCplus), .clk(~clock), .en(~(multdivSTALL | STALL)), .clr(1'b0));
    register FDIR(.q(FD_IRout), .d(FD_IRin), .clk(~clock), .en(~(multdivSTALL | STALL)), .clr(1'b0));

    assign FD_IR = (X_JorB | STALL) ? 32'b0 : FD_IRout;

    assign ctrl_readRegA = FD_IR[21:17];
    // Read from $rd if sw, jr, bne, or blt; Read from $r30 if bex
    assign ctrl_readRegB = (D_sw | D_jr | D_bne | D_blt) ? FD_IR[26:22] : 
                            D_bex ? 5'd30 :
                            FD_IR[16:12];
    

//EXECUTE
    wire [31:0] X_inB, X_inBbypass;
    // Define DX latch
    register DXPC(.q(DX_PC), .d(FD_PC), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register DXIR(.q(DX_IR), .d(FD_IR), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register DXA(.q(DX_A), .d(data_readRegA), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register DXB(.q(DX_B), .d(data_readRegB), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));

// Immediate
    wire I;
    assign I = X_addi | X_sw | X_lw | X_bne | X_blt;    // Is instruction an I type?

    wire [31:0] immediate;
    assign immediate [16:0] = DX_IR[16:0];
    assign immediate [31:17] = DX_IR[16] ? 15'b111111111111111 : 15'b0;
    
    // Take WX or MX bypass?
    assign X_inBbypass =    WX_inB ? W_writeReg :
                            MX_inB ? XM_O :
                            DX_B;

    assign X_inB =  I ? immediate : X_inBbypass;


// Opcode
    wire [4:0] X_ALUop;
    assign X_ALUop = I ? 5'b0 : DX_IR[6:2];

// Shamt
    wire [4:0] shamt;
    assign shamt = (X_sra|X_sll) ? DX_IR[11:7] : 5'b0;

// ALU
    wire [31:0] X_aluOUT, X_aluRESULT, X_aluSTATUS;
    wire X_aluOVF;

    wire [31:0] X_inA, X_inAbypass;
    
    assign X_inAbypass = MX ? XM_O :
                        WX ? W_writeReg :
                        DX_A;

    assign X_inA = (X_blt | X_bne) ? DX_PC : X_inAbypass;   // Use PC for target arithmetic (PC + N)

    alu ALU(.data_operandA(X_inA), .data_operandB(X_inB), 
        .ctrl_ALUopcode(X_ALUop), .ctrl_shiftamt(shamt), 
        .data_result(X_aluRESULT), 
        .isNotEqual(), .isLessThan(), .overflow(X_aluOVF));

// Handle ALU exceptions

    assign X_aluSTATUS =    X_add ? 32'd1 :
                            X_addi ? 32'd2 :
                            X_sub ? 32'd3 : 
                            32'b0;
            
    assign X_aluOUT = (X_aluOVF&(X_addi|X_add|X_sub)) ? X_aluSTATUS : X_aluRESULT;

// multdiv
    wire X_multdivRDY, X_multdivEXC;
    wire [31:0] X_multdivOUT, X_multdivRESULT, X_muldivSTATUS;
    wire X_ctrlmult, X_ctrldiv, multdivSTALL;

    assign multdivSTALL = (X_mul | X_div) & ~X_multdivRDY;

    ctrlgen CTRLMULT(.clk(clock), .condition(X_mul & multdivSTALL), .ctrl(X_ctrlmult));    // Generate ctrl_mult and ctrl_div signals
    ctrlgen CTRLDIV(.clk(clock), .condition(X_div & multdivSTALL), .ctrl(X_ctrldiv));

    multdiv MULTDIV(.data_operandA(X_inA), .data_operandB(X_inB), .ctrl_MULT(X_ctrlmult), .ctrl_DIV(X_ctrldiv), .clock(clock), 
	.data_result(X_multdivRESULT), .data_exception(X_multdivEXC), .data_resultRDY(X_multdivRDY));

    assign X_muldivSTATUS = X_mul ? 32'd4 : 32'd5;
    assign X_multdivOUT = X_multdivEXC ? X_muldivSTATUS : X_multdivRESULT;
    
// Choose OUTPUT
    wire [31:0] X_out;

    assign X_out = (X_mul | X_div) ? X_multdivOUT : 
                    X_jal ? DX_PC :
                    X_setx ? d_target :
                    X_aluOUT;


// Change $rd to $rstatus (30) if exception/overflow and $ra (31) if jal
    wire [31:0] X_newIR;

    assign X_newIR[26:22] = X_jal ? 5'd31 : 
                            ((X_aluOVF & (X_add|X_addi|X_sub)) | (X_multdivEXC & X_multdivRDY&(X_mul|X_div)) | X_setx) ? 5'd30 : 
                            DX_IR[26:22];

    assign X_newIR[31:27] = DX_IR[31:27];
    assign X_newIR[21:0] = DX_IR[21:0];


// Jumps
    wire [31:0] X_target, X_jalOUT, d_target;
    assign d_target[26:0] = DX_IR[26:0];
    assign d_target[31:27] = 5'b0;
    assign X_target =   X_jr ? X_inBbypass :
                        X_blt | X_bne ? X_aluOUT :
                        d_target;


// Branches (blt, bne)
    wire X_notEqual, X_lessThan;

    alu LT_NEQ(.data_operandA(X_inBbypass), .data_operandB(X_inAbypass),                     // Reverse order (B-A), where B is $rd and A is $rs
        .ctrl_ALUopcode(5'b00001), .ctrl_shiftamt(), 
        .data_result(), 
        .isNotEqual(X_notEqual), .isLessThan(X_lessThan), .overflow());     //ALU only to compute neq and lt




//MEMORY
    // Define XM latch
    register XMIR(.q(XM_IR), .d(X_newIR), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register XMO(.q(XM_O), .d(X_out), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register XMB(.q(XM_B), .d(X_inBbypass), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));

    assign address_dmem = XM_O;
    assign data = WM ? W_writeReg : XM_B;
    assign wren = M_sw;

//WRITEBACK
    // Define MW latch
    wire [31:0] W_writeReg;
    register MWIR(.q(MW_IR), .d(XM_IR), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register MWO(.q(MW_O), .d(XM_O), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));
    register MWD(.q(MW_D), .d(q_dmem), .clk(~clock), .en(~multdivSTALL), .clr(1'b0));

    assign W_writeReg = W_lw ? MW_D : MW_O;

    // Register file
    assign data_writeReg = W_writeReg;

    assign ctrl_writeEnable = W_add | W_addi | W_sub | W_and | W_or | W_sll | W_sra | W_mul | W_div | W_lw | W_jal | W_setx;

    assign ctrl_writeReg = MW_IR[26:22];

    // Bypass logic signals
    wire MX, WX, MX_inB, WX_inB, WM;
    
    // Never bypass from sw
    assign MX = (((X_newIR[21:17] == XM_IR[26:22])) & 
                (|X_newIR[26:22]) & (|XM_IR[26:22])) & ~M_sw;

    assign WX = (((X_newIR[21:17] == MW_IR[26:22]) & ctrl_writeEnable) |
                ((X_bne | X_blt) & (X_newIR[21:17] == MW_IR[26:22])) & 
                (|X_newIR[26:22]) & (|MW_IR[26:22])) & ~W_sw;

    assign MX_inB = (((X_newIR[16:12] == XM_IR[26:22]) | 
                    ((X_jr | X_bne | X_blt) &  (X_newIR[26:22] == XM_IR[26:22]))) &
                    (|X_newIR[26:22]) & (|XM_IR[26:22]) |
                    (X_bex & M_setx)) & ~M_sw;

    assign WX_inB = (((X_newIR[16:12] == MW_IR[26:22]) | 
                    ((X_jr | X_bne | X_blt) & (X_newIR[26:22] == MW_IR[26:22])) |
                    (X_sw & (X_newIR[26:22] == MW_IR[26:22]))) &
                    (|X_newIR[26:22]) & (|MW_IR[26:22]) |
                    (X_bex & W_setx)) & ~W_sw;

    assign WM = M_sw & ctrl_writeEnable & (MW_IR[26:22] == XM_IR[26:22]);

endmodule
