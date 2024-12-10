# Multdiv
## Name
Ayush Botke
## Description of Design
**Multiplier**
* Used Modified Booth's logic
    - Initialize P register with multiplier
    - Shift 2 bits at a time
    - Read last 3 bits (bonus bit included), goes into a MUX to decide what to add

**Divider**
* Used non-restoring logic
    - Initialize RQ register with dividend
    - Shift left
    - R += V, R -= V
    - Q[0] = 1 or 0 depending on ~R[31]
* Needed to handle negatives
    - XOR A and B to determine if result needs to be negated
    - Negate A and/or B if operand is negative before running non-restoring algorithm


**Exception Handling**
* Threw exceptions when:
    - Multiplying
        - Top 32 bits in P are not all 1's or 0's
        - Signs of multiplier, multiplicand, and product are misaligned
    - Division by 0
        - NOR bits of B

**Counter**
* Register CHOOSE kept track of which operation is being performed (multORdiv)
* When count = 16 and mult is being performed, result is ready
* WHen count = 32 and div is being performed, result is ready



## Bugs
Currently no bugs, scored 100 on the autograder in gradescope