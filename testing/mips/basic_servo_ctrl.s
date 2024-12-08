# test uses buttons to control servo

addi $r22, $r0, 100

Wait_btnl1:
    bne $r5, $r0, Min_cal       # BTNL 1
    j Wait_btnl1

Min_cal:
    addi $r21, $r1, 0
    blt $r21, $r22, release_

grab_:
    addi $r2, $r0, 1        # set PWM to positive
    nop
    addi $r2, $r0, 0        # reset PWM to rest
    j end
release_:
    addi $r2, $r0, 2        # set PWM to negative
    nop
    addi $r2, $r0, 0        # reset PWM to rest
end:
    nop
    nop
    nop
    j end
