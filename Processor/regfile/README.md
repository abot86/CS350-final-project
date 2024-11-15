# Regfile
## Name
Ayush Botke
## Description of Design
Used 32 DFF to create a 32-bit register.

Used a 5 to 32 decoder to enable the selected register from the ctrl_writeReg bits.

Used two 5 to 32 decoders connected to 32 tristate buffers each to select which register to read from. The select bits were ctrl_readRegA and ctrl_readRegB.

## Bugs
Currently no bugs, scored 100 on the autograder in gradescope