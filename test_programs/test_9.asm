# test loop
addi $t0, $zero, 5
addi $t1, $zero, 0
addi $t2, $zero, 0x0000
LOOP:
    sw $t1, 0($t2)
    addi $t2, $t2, 4
    addi $t1, $t1, 1
    beq $t0, $t1, DONE
    j LOOP

DONE:
addi $v0, $zero, 10
syscall