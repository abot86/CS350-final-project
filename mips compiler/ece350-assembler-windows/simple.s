Wait_btnl:
    bne $r5, $r0, Min_cal       # BTNL
    j Wait_btnl

Min_cal:
    addi $r3, $r1, 0
# IF LEDs CONNECTED TO R3, SHOULD DISPLAY WHEN BTNL PRESSED

Wait_btnr:
    bne $r6, $r0, Max_cal       # BTNR
    j Wait_btnr

Max_cal:
    addi $r4, $r1, 0
# IF LEDs CONNECTED TO R4, SHOULD DISPLAY WHEN BTNR PRESSED
