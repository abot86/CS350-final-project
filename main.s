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
nop
nop
nop
addi $r19, $r0, 2500
nop
nop
nop
addi $r10, $r0, 0                  # ensure sum == 0 initially 
nop
nop
nop

# Calibrate rest (minimum)
add $r9, $r0, $r19                 # count = 2500
nop
nop
nop

# Calibrate active (maximum)
Wait_btnr:
    bne $r6, $r0, Max_cal
    nop
    nop
    nop
    j Wait_btnr
    nop
    nop
    nop

Max_cal:
    addi $r9, $r9, -1                # count = count - 1
    nop
    nop
    nop
    addi $r11, $r0, 0               # set toAdd to 0
    nop
    nop
    nop
    blt $r9, $r0, Max_set           # while (count > 0)
    nop
    nop
    nop                                         
    Max_wait_ADC:
        bne $r8, $r0, Max_calc      # while ADC not ready
        nop
        nop
        nop
        j Max_wait_ADC
        nop
        nop
        nop
    Max_calc:
        blt $r1, $r18, Max_abs    # if ($r1 > OFFSET)
        nop
        nop
        nop
        sub $r11, $r1, $r18       # toAdd = $r1 - OFFSET
        nop
        nop
        nop
        j End_max_cal
        nop
        nop
        nop
    Max_abs:
        sub $r11, $r18, $r1       # toAdd = OFFSET - $r1
        nop
        nop
        nop
    End_max_cal:
        add $r10, $r10, $r11            # sum = sum + toAdd
        nop
        nop
        nop
        j Max_cal
        nop
        nop
        nop

Max_set:
    add $r4, $r10, $r0
    nop
    nop
    nop

addi $r10, $r0, 0                  # reset sum to 0 
nop
nop
nop
add $r9, $r0, $r19                  # count = 2500
nop
nop
nop

Wait_btnl:
    bne $r5, $r0, Min_cal
    nop
    nop
    nop
    j Wait_btnl
    nop
    nop
    nop

Min_cal:
    addi $r9, $r9, -1                # count = count - 1
    nop
    nop
    nop
    addi $r11, $r0, 0               # set toAdd to 0
    nop
    nop
    nop
    blt $r9, $r0, Min_set           # while (count > 0)
    nop
    nop
    nop
    Min_wait_ADC:
        bne $r8, $r0, Min_calc      # while ADC not ready
        nop
        nop
        nop                             
        j Min_wait_ADC
        nop
        nop
        nop
    Min_calc:
        blt $r1, $r18, Min_abs    # if ($r1 > OFFSET)
        nop
        nop
        nop
        sub $r11, $r1, $r18       # toAdd = $r1 - OFFSET
        nop
        nop
        nop
        j End_min_cal
        nop
        nop
        nop
    Min_abs:
        sub $r11, $r18, $r1       # toAdd = OFFSET - $r1
        nop
        nop
        nop
    End_min_cal:
        add $r10, $r10, $r11            # sum = sum + toAdd
        nop
        nop
        nop
        j Min_cal
        nop
        nop
        nop

Min_set:
    add $r3, $r10, $r0
    nop
    nop
    nop

sub $r30, $r4, $r3                  # difference btw max and min
nop
        nop
        nop

## BELOW IS NOT WORKING 
# Main loop
Main_loop:
    add $r9, $r0, $r19           # count = 2500
    nop
        nop
        nop
    addi $r12, $r0, 0            # r12 reset
    nop
        nop
        nop
    addi $r10, $r0, 0
    nop
        nop
        nop

    Data_collect:
        addi $r9, $r9, -1               # count = count - 1
        nop
        nop
        nop
        addi $r11, $r0, 0               # set toAdd to 0
        nop
        nop
        nop
        blt $r9, $r0, Set_pwm_curr      # while (count > 0)
        nop
        nop
        nop
        Wait_ADC:
            bne $r8, $r0, Calc          # while ADC not ready
            nop
        nop
        nop
            j Wait_ADC
            nop
        nop
        nop
        Calc:
            blt $r1, $r18, Abs          # if ($r1 > OFFSET)
            nop
        nop
        nop
            sub $r11, $r1, $r18         # toAdd = $r1 - OFFSET
            nop
        nop
        nop
            j End_data_collect
            nop
        nop
        nop
        Abs:
            sub $r11, $r18, $r1         # toAdd = OFFSET - $r1
            nop
        nop
        nop
        End_data_collect:
            add $r10, $r10, $r11        # sum = sum + toAdd
            nop
        nop
        nop
            j Data_collect
            nop
        nop
        nop
    
    Set_pwm_curr:
        add $r12, $r10, $r0             # r12 := sum over 3 periods
        nop
        nop
        nop
        sub $r16, $r12, $r3             # $r16 = x - rest
        nop
        nop
        nop
        sub $r17, $r4, $r12             # $r17 = active - x
        nop
        nop
        nop
        addi $r17, $r17, 20000      # WHAT VALUES WERE WE GETTING FOR R3 AND R4 FOR NORMAL SIGNAL?  
        nop
        nop
        nop


        blt $r17, $r16, Set_curr_HIGH    # if (x-rest > active-x)
        nop
        nop
        nop

        Set_curr_LOW:
            sll $r26, $26, 1
            nop
            nop
            nop
            addi $r26, $r26, 0       # set PWM register to low (0*)
            nop
        nop
        nop
            j End
            nop
        nop
        nop

        Set_curr_HIGH:
            sll $r26, $26, 1
            nop
            nop
            nop
            addi $r26, $r26, 1       # set PWM register to high (1*)
            nop
        nop
        nop
            j End
            nop
        nop
        nop


# # TO REDO: (r25=prev and r26=curr)
# # NEW:
#     final_PWM_steps:
#             bne $r25, $r0, case4HL
#         case1LL:
#             bne $r26, $r0, case3LH
#             addi $r2, $r0, 0
#             j End
#         case2HH:
#             addi $r2, $r0, 1
#             j End
#         case3LH:
#             addi $r2, $r0, 2
#             j End
#         case4HL:
#             bne $r26, $r0, case2HH
#             addi $r2, $r0, 3
#             j End
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
        # add $r25, $r0, $r26         # move curr to prev
        # addi $r26, $r0, 0            # set PWM to rest
    nop
    nop
    nop
    j Main_loop
    nop
    nop
    nop

# Create new register to store previous, move current into previous at end of each loop

#####
#    PLAN FOR TESTING
# register 24 is (or will be depending on how late I stay up)...
#    hard-wired to LEDs on the FPGA. replace any register with $r24 to see its value mid run.
# NOTE: $r24 is only hard-wired in main branch. please merge changes before doing stuff.
# BTNC is the reset button (always). If BTNC does not reset then life sucks.
#
#####
