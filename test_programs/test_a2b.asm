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
	li 	 $a2, MAX_WORD_LEN
	la   $t0, NUM_WORDS
	jal  FUNCTION_SWAP

EXIT:
	li $v0, 10
	syscall


# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
FUNCTION_SWAP:
	# Make room for temporary string on stack
	sub $sp, $sp, $a2
	# Configure pointers for three copy loops
	# We use two for each to avoid extra labels below
	move $t0, $a0 # Pointer1 to current byte in first string 
	move $t1, $a1 # Pointer1 to current byte in second string
	move $t2, $sp # Pointer1 to current byte in temp string
	move $t7, $a0 # Pointer2 to current byte in first string 
	move $t8, $a1 # Pointer2 to current byte in second string
	move $t9, $sp # Pointer2 to current byte in temp string
COPY_FIRST:
	lbu $t3, 0($t0)
	sb $t3, 0($t2)
	beq $t3, $zero, COPY_SECOND
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j COPY_FIRST
COPY_SECOND:
	lbu $t3, 0($t1)
	sb $t3, 0($t7)
	beq $t3, $zero, COPY_TEMP
	addi $t1, $t1, 1
	addi $t7, $t7, 1
	j COPY_SECOND
COPY_TEMP:
	lbu $t3, 0($t9)
	sb $t3, 0($t8)
	beq $t3, $zero, CLEAN_UP
	addi $t9, $t9, 1
	addi $t8, $t8, 1
	j COPY_TEMP
CLEAN_UP:
	# Remove temporary space on stack
	add $sp, $sp, $a2 
	jr $ra
