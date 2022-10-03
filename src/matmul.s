.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    # Error checks
	ble a1, x0, error2
	ble a2, x0, error2
	ble a4, x0, error3
	ble a5, x0, error3
	bne a2, a4, error4

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
	mv s3, a3
	mv s4, a4
	mv s5, a5
	mv s6, a6
	mv s7, zero # i, row iteration
outer_loop_start:
	bge s7, s1, outer_loop_end
	mv s8, zero # j, column iteration


inner_loop_start:
	bge s8, s5, inner_loop_end
	mv a0, s2
	mul a0, a0, s7
	slli a0, a0, 2
	add a0, a0, s0 # pointer to row start
	addi a3, x0, 1 # stride of row
	mv a2, s2 # length
	mv a1, s8
	slli a1, a1, 2
	add a1, a1, s3 # pointer to column start
	mv a4, s5 # stride of column
	jal ra, dot # call dot
	mv t0, s5
	mul t0, t0, s7
	add t0, t0, s8
	slli t0, t0, 2
	add t0, t0, s6
	sw a0, 0(t0)

	addi s8, s8, 1
	j inner_loop_start
inner_loop_end:
	addi s7, s7, 1
	j outer_loop_start


outer_loop_end:

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
error2:
	addi a1, x0, 2
	jal ra, exit2
error3:
	addi a1, x0, 3
	jal ra, exit2
error4:
	addi a1, x0, 4
	jal ra, exit2
