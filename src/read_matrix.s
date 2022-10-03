.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -40
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	sw s7, 28(sp)
	sw s8, 32(sp)
	sw ra, 36(sp)

	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv a1, s0
	mv a2, zero
	jal ra, fopen
	mv s3, a0 # descriptor
	li t0, -1
	beq s3, t0, error50
	addi sp, sp, -8
	mv a1, s3
	mv a2, sp
	addi a3, zero, 4
	jal ra, fread
	addi t0, zero, 4
	bne a0, t0, error51
	mv a1, s3
	addi a2, sp, 4
	addi a3, zero, 4
	jal ra, fread
	addi t0, zero, 4
	bne a0, t0, error51
	lw s4, 0(sp) # row
	lw s5, 4(sp) # column
	addi sp, sp, 8
	mul s6, s4, s5
	slli s6, s6, 2 # bytes to read and store
	mv a0, s6
	jal ra, malloc
	mv s7, a0 # ptr to mat
	beq s7, zero, error48
	mv a1, s3
	mv a2, s7
	mv a3, s6
	jal ra, fread
	bne a0, s6, error51
	mv a1, s3
	jal ra, fclose
	bne a0, zero, error52
	sw s4, 0(s1)
	sw s5, 0(s2)
	mv a0, s7

    # Epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)
	lw s7, 28(sp)
	lw s8, 32(sp)
	lw ra, 36(sp)
	addi sp, sp, 40

    ret

error1:
	addi a1, zero, 1
	jal exit2
error48:
	addi a1, zero, 48
	jal exit2
error50:
	addi a1, zero, 50
	jal exit2
error51:
	addi a1, zero, 51
	jal exit2
error52:
	addi a1, zero, 52
	jal exit2
