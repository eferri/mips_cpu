# Boilerplate test for simple subset of instructions
addi $t0, $zero, 3
addi $t1, $zero, 1
or $t2, $t1, $t0
addi $t3, $zero, 0xFFF
and $s4, $t2, $t3
addi $v0, $zero, 10
syscall