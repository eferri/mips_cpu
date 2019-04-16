.eqv  MAX_WORD_LEN 16
.eqv  MAX_WORD_LEN_SHIFT 4
.eqv  MAX_NUM_WORDS 10
.eqv  WORD_ARRAY_SIZE 160  # MAX_WORD_LEN * MAX_NUM_WORDS


# Global data

.data
WORD_ARRAY: .ascii "q8hAW02yvD3KArv\0DCja8xzzgT9TtqA\0e1loj9Aoicb0UjV\05WRBvUpHizedjlO\0OT0NyDab6uQj3Dq\0FOQbIFYt8fUdtGl\0zywn8bE54AN7h8f\0xXIprf1coAvGdUM\0RgaihjJCZj5rBGC\0JnR9vUmPLoP8lAP\0"
NUM_WORDS: 	.space 4

# For strcmp testing...
BUFFER_A:	.space MAX_WORD_LEN
BUFFER_B:	.space MAX_WORD_LEN

.text

INIT:
	# Initialize NUM_WORDS to 10.
	la $t0, NUM_WORDS
	li $t1, 10
	sw $t1, 0($t0)
	
CALL_SWP:	
	
	# Assemble arguments
	la   $a0, WORD_ARRAY
	addi $a1, $a0, MAX_WORD_LEN
	la   $t0, NUM_WORDS
	jal  FUNCTION_STRCMP
	move $v1 $v0

EXIT:
	li $v0, 10
	syscall

#
# $a0 contains the address of the first string
# $a1 contains the address of the second string
# $v0 will contain the result of the function.
#

# We use the calling procedure outlined in appendix A of
# the textbook, which says registers $a0-a3 and $t0-$t9 do
# not need to be preserved by the callee. Therefore, no stack
# is necessary here.
FUNCTION_STRCMP:
	lbu $t0, 0($a0)
	lbu $t1, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	beq, $t0, $t1, NEXT_CHAR	
	sltu $t2, $t0, $t1
	beq  $t2, $zero, GREAT
LESS:
	li $v0, -1
	jr $ra
GREAT:
	li $v0, 1
	jr $ra
NEXT_CHAR:
	bne $t0, $zero, FUNCTION_STRCMP
	li $v0, 0
	jr $ra
