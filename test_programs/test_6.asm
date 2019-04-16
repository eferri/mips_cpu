# test loop
addi $t0, $zero, 0x1FFF
addi $t1, $zero, 0x4222
and $t2, $t1, $t0
addi $t3, $zero, 0x3333
add $t4, $t2, $t3
addi $t7, $zero, 0x0000
nor $t8, $t4, $t7
addi $t3, $zero, 0x0000
addi $s1, $zero, 0x80

LOOP_1:
    sw $t8, 0($t3)
    addi $t3, $t3, 4
    addi $t2, $t2, 3
    addi $t8, $t8, 1
    nop
    nop
    beq $t3, $s1, DONE
    j LOOP_1

DONE:
    addi $t3, $zero, 0x0000
    addi $s2, $zero, 0
    
LOOP_2:
    lw $t9, 0($t3)
    addi $t3, $t3, 4
    add $s2, $s2, $t9
    beq $t3, $s1, FINISHED
    j LOOP_2

FINISHED:

addi $v0, $zero, 10
syscall