nop
nop
nop
nop
nop
nop

addi $1, $0, 10      # $1 = 10
addi $2, $0, 20      # $2 = 20
nop
nop
nop
nop
nop

# Test add
add $3, $1, $2       # $3 = $1 + $2 = 10 + 20 = 30

# Test sub
sub $4, $2, $1       # $4 = $2 - $1 = 20 - 10 = 10

# Test and
and $5, $1, $2       # $5 = $1 & $2 = 10 & 20 = 0 (bitwise AND)

# Test or
or $6, $1, $2        # $6 = $1 | $2 = 10 | 20 = 30 (bitwise OR)

# Test sll (shift left logical)
sll $7, $1, 2        # $7 = $1 << 2 = 10 << 2 = 40

# Test sra (shift right arithmetic)
addi $8, $0, -16     # $8 = -16 (for testing sign extension with sra)
nop
nop
nop
nop
sra $9, $8, 2        # $9 = $8 >> 2 = -16 >> 2 = -4 (arithmetic shift right)

# Test sw and lw
sw $1, 0($0)         # mem1 = $1 = 10
sw $2, 4($0)         # mem2 = $2 = 20
lw $10, 0($0)        # $10 = mem1 = 10
lw $11, 4($0)        # $11 = mem2 = 20

# Test mul and div
mul $12, $1, $2     # $12 = $1 * $2 = 200
div $13, $2, $1     # $13 = $2 / $1 = 2
