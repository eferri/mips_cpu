addi $t0, $zero, 1
addi $t1, $zero, 0x0004
sw $t0, 0($t1)
addi $t0, $zero, 4
lw $t2, 0($t1)
add $t3, $t2, $t0
addi $v0, $zero, 10
syscall