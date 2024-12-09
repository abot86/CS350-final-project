
# Define constants
addi $r18, $r0, 94
addi $r19, $r0, 2500
addi $r10, $r10, 0                  # ensure sum == 0 initially 

# Calibrate rest (minimum)
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
    add $r3, $r10, $r0


# Calibrate active (maximum)
addi $r10, $r10, 0                  # reset sum to 0 
add $r9, $r0, $r19                  # count = 2500
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
    add $r4, $r10, $r0

Main_loop:
    add $r9, $r0, $r19           # count = 2500
    addi $r12, $r0, 0                                                       # CHANGE FROM WHAT WORKED BEFORE
    Data_collect:
        addi $r9, $r9, -1               # count = count - 1
        addi $r11, $r0, 0               # set toAdd to 0
        blt $r9, $r0, Set_pwm_curr      # while (count > 0)
        Wait_ADC:
            bne $r8, $r0, Calc          # while ADC not ready
            j Wait_ADC
        Calc:
            blt $r1, $r18, Abs          # if ($r1 > OFFSET)
            sub $r11, $r1, $r18         # toAdd = $r1 - OFFSET
            j End_data_collect
        Abs:
            sub $r11, $r18, $r1         # toAdd = OFFSET - $r1
        End_data_collect:
            add $r10, $r10, $r11        # sum = sum + toAdd
            j Data_collect
    
    Set_pwm_curr:
        add $r12, $r10, $r0             # r12 := sum over 3 periods
        sub $r16, $r12, $r3             # $r16 = x - rest
        sub $r17, $r4, $r12             # $r17 = active - x

        blt $r17, $r16, Set_curr_HIGH    # if (x-rest > active-x)

        Set_curr_LOW:
            addi $r26, $r0, 0       # set PWM register to low (0*)
            j Main_loop                                                       # CHANGE FROM WHAT WORKED BEFORE

        Set_curr_HIGH:
            addi $r26, $r0, 1       # set PWM register to high (1*)
    j Main_loop                                                               # CHANGE FROM WHAT WORKED BEFORE
End:
    nop
    nop
    j End