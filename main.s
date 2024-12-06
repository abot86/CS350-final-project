.data
OFFSET: .word 94
ADC_SAMPLE: .word 2500
PWM_HIGH: .word 102
PWM_LOW: .word 21

.text

# Calibrate rest (minimum)
addi $r9, $r0, ADC_SAMPLE                 # count = 2500
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
        blt $r1, OFFSET, Min_abs    # if ($r1 > OFFSET)
        sub $r11, $r1, OFFSET       # toAdd = $r1 - OFFSET
    Min_abs:
        sub $r11, OFFSET, $r1       # toAdd = OFFSET - $r1

    add $r10, $r10, $r11            # sum = sum + toAdd
    j Min_cal

Min_set:
    div $r3, $r10, ADC_SAMPLE



# Calibrate active (maximum)
addi $r9, $r0, ADC_SAMPLE                 # count = 2500
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
        blt $r1, OFFSET, Max_abs    # if ($r1 > OFFSET)
        sub $r11, $r1, OFFSET       # toAdd = $r1 - OFFSET
    Max_abs:
        sub $r11, OFFSET, $r1       # toAdd = OFFSET - $r1

    add $r10, $r10, $r11            # sum = sum + toAdd
    j Max_cal

Max_set:
    div $r4, $r10, ADC_SAMPLE


# Main loop
Main_loop:
    addi $r9, $r0, ADC_SAMPLE           # count = 2500

    Data_collect:
        addi $r9, $r9, -1               # count = count - 1
        addi $r11, $r0, 0               # set toAdd to 0
        blt $r9, $r0, Set_pwm           # while (count > 0)
        Wait_ADC:
            bne $r8, $r0, Calc          # while ADC not ready
            j Wait_ADC
        Calc:
            blt $r1, OFFSET, Abs        # if ($r1 > OFFSET)
            sub $r11, $r1, OFFSET       # toAdd = $r1 - OFFSET
        Abs:
            sub $r11, OFFSET, $r1       # toAdd = OFFSET - $r1

        add $r10, $r10, $r11            # sum = sum + toAdd
        j Data_collect
    
    Set_pwm:
        div $r12, $r10, ADC_SAMPLE      # r12 := measured average over 3 periods
        sub $r16, $r12, $r3             # $r16 = x - rest
        sub $r17, $r4, $r12             # $r17 = active - x
        blt $r17, $r16, Set_pwm_HIGH    # if (x-rest > active-x)

        Set_pwm_LOW:
            addi $r2, $r0, PWM_LOW      # set PWM register to low (0*)
            j Main_loop

        Set_pwm_HIGH:
            addi $r2, $r0, PWM_HIGH     # set PWM register to high (0*)
            j Main_loop
    
    j Main_loop