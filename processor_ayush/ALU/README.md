# ALU
## Name
Ayush Botke
## Description of Design
**Adder**
* Created a two-level carry lookahead
* Calculated carries for 8-bit adder with combinational logic from propagate and generate bits
* Strung together 4 8-bit adder blocks and used G and P to calculate carries between them  

**Subtracter**
* Added logic in ALU to:
    - Look at LSB of opcode (0 - add, 1 - subtract)
    - Negate B, then use the LSB as select bit of a mux that chooses between B and B'
    - LSB becomes carry in bit (2's complement is flip bits and add 1)  

**Overflow**  
* Created a truth table and used sum of products to generate the overflow bit
* Overflow was a function of the MSBs of A, B (after mux), and the result
* (A'B'R) + (ABR')  
  
**isNotEqual**
* OR together all of the bits of the result
* Since it only needs to be correct after a subtract, and a subtract of two numbers equal to each other will be 0, just need to check if result = 0

**isLessThan**
* Always 1 if A is negative and B is positive
* Always 0 if A is positive and B is negative
* Use MSB of result if A and B are the same sign
* Create a mux using A and B MSB as the select bits, then select from the above options  

**Bitwise AND/OR**
* ANDed or ORed every bit of each input

**SLL and SRA**
* Same logic for both, except needed to shift in MSB for SRA
* Muxes in between each shifter decide whether to use shifted version (4 bit input, each input corresponds to a select bit on a mux)


## Bugs
Currently no bugs, scored 100 on the autograder in gradescope