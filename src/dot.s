.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
	ble a2, x0, length_illegal
	ble a3, x0, stride_illegal
	ble a4, x0, stride_illegal

	addi t0, x0, 0 # t0: result
	addi t6, x0, 0 # t6: i
loop_start:
	bge t6, a2, loop_end
	mul t1, t6, a3
	slli t1, t1, 2
	add t1, t1, a0 # t1: a0_position
	mul t2, t6, a4
	slli t2, t2, 2
	add t2, t2, a1 # t2: a1_position
	lw t3, 0(t1) # value_0
	lw t4, 0(t2) # value_1
	mul t5, t3, t4 # value
	add t0, t0, t5
	addi t6, t6, 1
	j loop_start

loop_end:
	addi a0, t0, 0    
    ret
length_illegal:
	addi a1, x0, 5
	jal ra, exit2
stride_illegal:
	addi a1, x0, 6
	jal ra, exit2
