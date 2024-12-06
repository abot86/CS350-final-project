.data
OFFSET: .word 94

.text

# Calibrate rest (minimum)

addi $r9, $r0, 2499                 # count = 2500
Wait_btnl:
    bne $r5, $r0, Min_cal
    j Wait_btnl

Min_cal:
    addi $r11, $r0, 0
    blt $r9, $r0, Min_set           # while (count > 0)
    Min_wait_ADC:
        bne $r8, $r0, Min_calc      # while ADC not ready
        j Min_wait_ADC
    Min_calc:
        blt $r1, OFFSET, Min_abs    # if ($r1 > OFFSET)
        sub $r11, $r1, OFFSET       # toAdd = $r1 - OFFSET
    Min_abs:
        sub $r11, OFFSET, $r1       # toAdd = OFFSET - $r1

    add $r10, $r10, $r11
    addi $r9, $r9, 1
    j Min_cal


Min_set:




# Calibrate active (maximum)
Wait_btnr:
    bne $r6, $r0, Max_cal
    j Wait_btnr

Max_cal: