# test loop
addi $t0, $zero, 0x100
addi $t1, $zero, 0x30
addi $t2, $zero, 0x0000
addi $t4, $zero, 0x100

LOOP:
    sb  $t1, 0($t2)
    lbu $t3, 0($t2)
    sb  $t3, 0($t4)
    addi $t2, $t2, 1
    addi $t4, $t4, 1
    addi $t1, $t1, 15
    bne $t0, $t2, LOOP

DONE:
addi $s0, $zero, 0x12
addi $v0, $zero, 10
syscall