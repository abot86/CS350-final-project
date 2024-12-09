# What this test does is:
# ensures the buttons can 'catch' values, and test it's division abilities
# LEDs should show the average of the three values.
# TEST 1: 2, 2, 2. Res: 2
# TEST 2: 0, 0, 3. Res: 1
# TEST 3: R, R, R. Res: R

# PASSES ALL 3
addi $r10, $r0, 100             # CONST: 100 (r10)

Wait_btnl1:
    bne $r5, $r0, Min_cal       # BTNL 1 <- PREV
    j Wait_btnl1

Min_cal:
    addi $r25, $r1, 0

Wait_btnl2:
    bne $r6, $r0, Min_cal2       # BTNR 2 <- CURR
    j Wait_btnl2

Min_cal2:
    add $r26, $r1, $r0

prepare_for_PWM_1:
    blt $r25, $r10, set_prev_low
    addi $r25, $r0, 1
    j prepare_for_PWM_2
set_prev_low:
    addi $r25, $r0, 0

prepare_for_PWM_2:
    blt $r26, $r10, set_curr_low
    addi $r26, $r0, 1
    j final_PWM_steps
set_curr_low:
    addi $r26, $r0, 0

    final_PWM_steps:
            bne $r25, $r0, case3HL
        case0LL:
            bne $r26, $r0, case2LH
            addi $r2, $r0, 1
            j End
        case1HH:
            addi $r2, $r0, 2
            j End
        case2LH:
            addi $r2, $r0, 3
            j End
        case3HL:
            bne $r26, $r0, case1HH
            addi $r2, $r0, 4
            j End

End:
    nop
    j End
## CONNECT LEDs TO $R25
