# Processor
## Ayush Botke (ab973)

## Description of Design
Had a PC register and 4 latches (FD, DX, XM, and MW).   
These 4 latches split up the CPU into 5 pipelined stages: Fetch, Decode, eXecute, Memory, Writeback.     
1-bit wires at each stage decoded the opcode at each stage (e.g X_sw meant that the instruction currently in the eXecute stage is a sw). This was used for control signals.


**Instructions:**
* add, addi, sub, and, or, sll, sra
    - Uses ALU module
    - Outputs a result or exception to XM_O
* mul, div
    - Used modified booth's algorithm and non-restoring division
    - Created ctrl_mult and ctrl_div signals with a positive edge detector (ctrlgen.v)
* sw, lw
    - Computed MEM[$rs + N] in ALU
    - For sw, data goes into XM_B; for lw, data goes into MW_D
* j, jal, jr
    - Target T from these instructions is sent into PC register
* blt, bne
    - ALU calculates DX_PC (A) + N (B)
    - A separate ALU (LT_NEQ) calculates B-A and outputs signal isLessThan and isNotEqual
    - If a branch is occuring and its respective signal is on, then load PC+1+N into PC register
* bex, setx
    - bex loads value of $r30 into B and checks if it's non-zero; if not, it takes the branch
    - setx loads a specified values T into $r30

**General flushing:**
* If a jump or branch is taken, a nop is inserted into DX_IR and FD_IR

**Outputs and exceptions:**
* A mux at the end of the eXecute stage decides which output to push to XM_O
* If an exception is present, this exception is pushed to XM_O and $rd is changed to 30 before it goes to XM_IR

## Bypassing
Bypassing was done in 5 stages: MX (A), WX (A), MX (B), WX (B), and WM

No bypassing was allowed from a sw instruction OR when a nop was present in one of the stages!

**MX (A)**
* Bypass from the output of XM_O (memory stage) into input A (execute stage)
* Conditions
    - X.rs1 = M.rd

**WX (A)**
* Bypass from W_writeReg (the wire going into the regfile) into input A (execute stage)
* Conditions
    - X.rs1 = W.rd and intend to write to regfile
    - X.rs1 = W.rd and branch

**MX (B)**
* Bypass from the output of XM_O (memory stage) into input B (execute stage)
* Conditions
    - X.rs2 = M.rd
    - jr or branch and X.rd = M.rd

**WX (B)**
* Bypass from W_writeReg (the wire going into the regfile) into input B (execute stage)
* Conditions
    - X.rs2 = W.rd
    - jr or branch and X.rd = W.rd
    - sw and X.rd = W.rd
    - X.bex and W.setx

## Stalling
When a stall condition is met
1. A nop is inserted into DX_IR
2. FD latch and PC register are disabled

Conditions
- Executing lw and:
    - D.rs1 = X.rd or D.rs2 = X.rd
    - D.jr and D.rd = X.rd
    - D.branch and D.rs1 = X.rd or D.rd = X.rd

## Optimizations
None

## Bugs
# CPU
