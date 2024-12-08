# Calibrate rest (minimum)
# Define constants
addi $r18, $r0, 94
addi $r19, $r0, 2500


# TO WIRE: SET TESTING (REGFILE) = qReg3 and then qReg4


add $r9, $r0, $r19                 # count = 2500
Wait_btnl:
    bne $r5, $r0, Min_cal
    j Wait_btnl

Min_cal:
    addi $r9, $r9, -1                # count = count - 1
    addi $r11, $r0, 0               # set toAdd to 0
    blt $r9, $r0, Min_set           # while (count > 0)
    Min_wait_ADC:
        bne $r8, $r0, Min_calc      # while ADC not ready
        j Min_wait_ADC
    Min_calc:
        blt $r1, $r18, Min_abs    # if ($r1 > OFFSET)
        sub $r11, $r1, $r18       # toAdd = $r1 - OFFSET
    Min_abs:
        sub $r11, $r18, $r1       # toAdd = OFFSET - $r1

    add $r10, $r10, $r11            # sum = sum + toAdd
    j Min_cal

Min_set:
    div $r3, $r10, $r19


# Calibrate active (maximum)
add $r9, $r0, $r19                 # count = 2500
Wait_btnr:
    bne $r6, $r0, Max_cal
    j Wait_btnr

Max_cal:
    addi $r9, $r9, -1                # count = count - 1
    addi $r11, $r0, 0               # set toAdd to 0
    blt $r9, $r0, Max_set           # while (count > 0)
    Max_wait_ADC:
        bne $r8, $r0, Max_calc      # while ADC not ready
        j Max_wait_ADC
    Max_calc:
        blt $r1, $r18, Max_abs    # if ($r1 > OFFSET)
        sub $r11, $r1, $r18       # toAdd = $r1 - OFFSET
    Max_abs:
        sub $r11, $r18, $r1       # toAdd = OFFSET - $r1

    add $r10, $r10, $r11            # sum = sum + toAdd
    j Max_cal

Max_set:
    div $r4, $r10, $r19

Infinite_Loop:
    nop
    nop
    nop
    nop
    j Infinite_Loop