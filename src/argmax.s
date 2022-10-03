.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
	# check input param
	ble a1, x0, illegal_input

	addi t0, x0, 0 # t0: index
	lw t1, 0(a0) # t1: current max value
	addi t2, x0, 1 # t2: i, for-loop counter
loop_start:
	bge t2, a1, loop_end
	slli t3, t2, 2 # t3: i * s
	add t3, t3, a0 # pointer to current array position
	lw t4, 0(t3) # t4: a0[i * s]
	ble t4, t1, loop_continue
	addi t0, t2, 0
	addi t1, t4, 0

loop_continue:
	addi t2, t2, 1
	j loop_start

loop_end:
    addi a0, t0, 0
    ret

illegal_input:
	addi a1, x0, 7
	jal ra, exit2
