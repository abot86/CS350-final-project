# What this test does is:
# ensures the buttons can 'catch' values, and test it's division abilities
# LEDs should show the average of the three values.
# TEST 1: 2, 2, 2. Res: 2
# TEST 2: 0, 0, 3. Res: 1
# TEST 3: R, R, R. Res: R

Wait_btnl1:
    bne $r5, $r0, Min_cal       # BTNL 1
    j Wait_btnl1

Min_cal:
    addi $r21, $r1, 0

Wait_btnl2:
    bne $r5, $r0, Min_cal2       # BTNL 2
    j Wait_btnl2

Min_cal2:
    add $r21, $r21, $r1

Wait_btnl3:
    bne $r5, $r0, Min_cal3
    j Wait_btnl3

Min_cal3:
    add $r21, $r21, $r1         # BTNL 3
Final:
    addi $r22, $r0, 3
    div $r3, $r21, $r22

## CONNECT LEDs TO $R3
