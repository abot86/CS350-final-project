###################### PART 1: CAN IT SUM

addi $r18, $r0, 94
addi $r19, $r0, 3
addi $r10, $r0, 0                  # ensure sum == 0 initially 

# Calibrate rest (minimum)
add $r9, $r0, $r19                 # count

# Calibrate active (maximum)
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
        add $r10, $r10, $r1            # sum = sum + toAdd
        j Max_cal
Max_set:
    add $r4, $r10, $r0


###################### PART 2: CAN IT SUM 3 WITH OFFSET

# addi $r18, $r0, 94
# addi $r19, $r0, 3
# addi $r10, $r0, 0                  # ensure sum == 0 initially 

# # Calibrate rest (minimum)
# add $r9, $r0, $r19                 # count = 2500

# # Calibrate active (maximum)
# Wait_btnr:
#     bne $r6, $r0, Max_cal
#     j Wait_btnr

# Max_cal:
#     addi $r9, $r9, -1                # count = count - 1
#     addi $r11, $r0, 0               # set toAdd to 0
#     blt $r9, $r0, Max_set           # while (count > 0)
#     Max_wait_ADC:
#         bne $r8, $r0, Max_calc      # while ADC not ready
#         j Max_wait_ADC
#     Max_calc:
#         blt $r1, $r18, Max_abs    # if ($r1 > OFFSET)
#         sub $r11, $r1, $r18       # toAdd = $r1 - OFFSET
#         j End_max_cal
#     Max_abs:
#         sub $r11, $r18, $r1       # toAdd = OFFSET - $r1
#     End_max_cal:
#         add $r10, $r10, $r11            # sum = sum + toAdd
#         j Max_cal

# Max_set:
#     add $r4, $r10, $r0
