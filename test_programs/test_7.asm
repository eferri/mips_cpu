# Test with data hazards

addi $t0, $zero, 1
addi $t1, $zero, 2
addi $t2, $zero, 3
add $s0, $t0, $t1
add $t3, $s0, $t2
addi $t4, $zero, 0x0000
sw $t3, 0($t4)
lw $s1, 0($t4)
sub $t5, $s1, $t2
addi $v0, $zero, 10
syscall