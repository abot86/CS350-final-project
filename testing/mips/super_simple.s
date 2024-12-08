Wait_btnl:
    bne $r5, $r0, Min_cal       # BTNL
    j Wait_btnl

Min_cal:
    addi $r3, $r0, $r1
# IF LEDs CONNECTED TO R3, SHOULD DISPLAY WHEN BTNL PRESSED
End:
    nop
    nop
    nop
    j End