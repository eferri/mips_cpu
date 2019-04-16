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
	
CALL_QUICKSORT:	
	
	# Assemble arguments
	la $a0, WORD_ARRAY
	li $a1, 0
	la $t0, NUM_WORDS
	lw $a2, 0($t0)
	addi $a2, $a2, -1
	jal FUNCTION_HOARE_QUICKSORT

EXIT:
	li $v0, 10
	syscall

#
# $a0 contains the starting address of the array of strings,
#    where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the partition
# $a2 contains the ending index for the partition
# $v0 contains the index that is to be returned by the
#    partition algorithm
#

FUNCTION_PARTITION:
	# Save registers
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	# Space for pivot value on stack
	addi $sp, $sp, -MAX_WORD_LEN
	
	# Move arguments to save registers
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# Calculate pivot
	addu $t0, $s1, $s2
	srl $t0, $t0, 1
	sll $t0, $t0, MAX_WORD_LEN_SHIFT
	addu $t0, $s0, $t0 # Address of pivot in array
	
	# Copy pivot to temp storage
	move $t1, $sp # Pointer to current byte in stack pivot
	
COPY_PIVOT:
	lbu $t2, 0($t0)
	sb $t2, 0($t1)
	beq $t2, $zero, DONE_COPY
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j COPY_PIVOT

DONE_COPY:
	addi $s1, $s1, -1  # i
	addi $s2, $s2, 1   # j
	
PARTITION_LOOP_1:
	addi $s1, $s1, 1
	move $s3, $s1
	sll $s3, $s3, MAX_WORD_LEN_SHIFT
	addu $s3, $s3, $s0 # Address of element i
	move $a0, $s3
	move $a1, $sp
	jal FUNCTION_STRCMP
	li $t0, -1
	beq $v0, $t0, PARTITION_LOOP_1

PARTITION_LOOP_2:
	addi $s2, $s2, -1
	move $s4, $s2
	sll $s4, $s4, MAX_WORD_LEN_SHIFT
	addu $s4, $s4, $s0 # Address of element j
	move $a0, $s4
	move $a1, $sp
	jal FUNCTION_STRCMP
	li $t0, 1
	beq $v0, $t0, PARTITION_LOOP_2
	
	# if i >= j, return j
	bge $s1, $s2, RETURN_PARTITION
	
	#swap A[i], A[j]
	move $a0, $s3
	move $a1, $s4
	li $a2, MAX_WORD_LEN
	jal FUNCTION_SWAP
	j PARTITION_LOOP_1

RETURN_PARTITION:
	move $v0, $s2
	
	# Remove temporary storage space
	addi $sp, $sp, MAX_WORD_LEN
	
	# restore registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
	
#
# $a0 contains the starting address of the array of strings,
#    where each string occupies up to MAX_WORD_LEN chars.
# $a1 contains the starting index for the quicksort
# $a2 contains the ending index for the quicksort
#
# THIS FUNCTION MUST BE WRITTEN IN A RECURSIVE STYLE.
#

FUNCTION_HOARE_QUICKSORT:
	# Return quickly if possible
	bgeu $a1, $a2, QUICK_RETURN
	
	# Save registers
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0 # A
	move $s1, $a1 # lo
	move $s2, $a2 # hi
	
	# Argument registers are already set
	jal FUNCTION_PARTITION
	move $s3, $v0 # p
	
	# Set arguments for recursive call
	move $a0, $s0
	move $a1, $s1
	move $a2, $s3
	jal FUNCTION_HOARE_QUICKSORT
	
	move $a0, $s0
	move $a1, $s3
	move $a2, $s2
	addiu $a1, $a1, 1
	jal FUNCTION_HOARE_QUICKSORT

	#restore registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
QUICK_RETURN:
	jr $ra


#
# $a0 contains the address of the first string array
# $a1 contains the address of the second string array
# $a2 contains the maximum length of the arrays
# 

# As before, we assume argument and temporary registers 
# do not need to be preserved across a call	
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
