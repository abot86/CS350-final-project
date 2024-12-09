#HARDWIRED INPUTS
# r1 = ADC out
# r5 = BTNL rest
# r6 = BTNR active
# r8 = ADC ready

#HARDWIRED OUTPUTS
# r24 = LED testing
# r2 = PWM_out

#TEMPS
# r3 = minimum (rest)
# r4 = maximum (active)
# r9 = count (sampling)
# r10 = sum
# r11 = toAdd
# r12 = average (sum/sample size)
# r13 = prev_average
# r16 = (x-rest)
# r17 = (active - x)
# r25 = prev_PWM
# r26 = curr_PWM

# CONSTANTS
# r18 = OFFSET
# r19 = ADC_SAMPLE

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


# Main loop
Main_loop:
    add $r9, $r0, $r19           # count = 2500

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
        add $r12, $r10, $r0      # r12 := measured average over 3 periods
        sub $r16, $r12, $r3             # $r16 = x - rest
        sub $r17, $r4, $r12             # $r17 = active - x

        blt $r17, $r16, Set_curr_HIGH    # if (x-rest > active-x)

        Set_curr_LOW:
            addi $r26, $r0, 0       # set PWM register to low (0*)
            j final_PWM_steps

        Set_curr_HIGH:
            addi $r26, $r0, 1       # set PWM register to high (1*)


# TO REDO: (r25=prev and r26=curr)
# NEW:
    final_PWM_steps:
            bne $r25, $r0, case4HL
        case1LL:
            bne $r26, $r0, case3LH
            addi $r2, $r0, 1
            j End
        case2HH:
            addi $r2, $r0, 2
            j End
        case3LH:
            addi $r2, $r0, 3
            j End
        case4HL:
            bne $r26, $r0, case2HH
            addi $r2, $r0, 4
            j End
# OLD:
    #     sub $r20, $r26, $r25        # prev - curr (each is either 0 or 1)
    #     bne $r20, $r0, send_pwm_pulse # if prev =/= curr, send a pulse
    #     j End
    
    # send_pwm_pulse:                 # pulse either 1 or 2 based on active or rest
    #     bne $r26, $r0, active
    #     rest: 
    #         addi $r2, $r0, 2        # set PWM to negative
    #         nop
    #         addi $r2, $r0, 0        # reset PWM to rest
    #         j End
    #     active:
    #         addi $r2, $r0, 1        # set PWM to positive
    #         nop
    #         addi $r2, $r0, 0        # reset PWM to rest

# END OF REDO

    End:
        add $r25, $r0, $r26         # move curr to prev
        addi $r2, $r0, 0            # set PWM to rest
    j Main_loop

# Create new register to store previous, move current into previous at end of each loop

#####
#    PLAN FOR TESTING
# register 24 is (or will be depending on how late I stay up)...
#    hard-wired to LEDs on the FPGA. replace any register with $r24 to see its value mid run.
# NOTE: $r24 is only hard-wired in main branch. please merge changes before doing stuff.
# BTNC is the reset button (always). If BTNC does not reset then life sucks.
#
#####
