addi $t0, $zero, 1
addi $t1, $zero, 0x0004
addi $t2, $zero, 0x0008
sw $t0, 0($t1)
addi $t0, $zero, 2
sw $t0, 0($t2)
lw $t3, 0($t1)
sw $t3, 0($t2)
addi $v0, $zero, 10
syscall