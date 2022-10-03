.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	li t0, 5
	bne a0, t0, error49
	#prologue
	addi sp, sp, -44
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	sw s7, 28(sp)
	sw s8, 32(sp)
	sw s9, 36(sp)
	sw ra, 40(sp)

	mv s0, a0
	mv s1, a1
	mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================

	addi sp, sp, -24
    # Load pretrained m0
	lw a0, 4(s1)
	mv a1, sp
	addi a2, sp, 4
	jal ra, read_matrix
	mv s3, a0 # ptr to m0
	
    # Load pretrained m1
	lw a0, 8(s1)
	addi a1, sp, 8
	addi a2, sp, 12
	jal ra, read_matrix
	mv s4, a0 # ptr to m1

    # Load input matrix
	lw a0, 12(s1)
	addi a1, sp, 16
	addi a2, sp, 20
	jal ra, read_matrix
	mv s5, a0 # ptr to input

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
	lw t0, 0(sp)
	lw t1, 20(sp)
	mul s6, t0, t1 # elements num of hidden layer
	mv a0, s6
	slli a0, a0, 2
	jal ra, malloc
	beq a0, zero, error56
	mv s7, a0 # ptr to hidden layer
	mv a0, s3
	lw a1, 0(sp)
	lw a2, 4(sp)
	mv a3, s5
	lw a4, 16(sp)
	lw a5, 20(sp)
	mv a6, s7
	jal ra, matmul
	mv a0, s7
	mv a1, s6
	jal ra, relu
	lw t0, 8(sp)
	lw t1, 20(sp)
	mul s8, t0, t1 # elements num of scores
	mv a0, s8
	slli a0, a0, 2
	jal ra, malloc
	beq a0, zero, error56
	mv s9, a0 # ptr to scores
	mv a0, s4
	lw a1, 8(sp)
	lw a2, 12(sp)
	mv a3, s7
	lw a4, 0(sp)
	lw a5, 20(sp)
	mv a6, s9
	jal ra, matmul

	bne s2, zero, write_output
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0, s9
	mv a1, s8
	jal ra, argmax

    # Print classification
	mv a1, a0   
	jal ra, print_int

    # Print newline afterwards for clarity
	li a1, '\n'
	jal ra, print_char

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
write_output:
	lw a0, 16(s1)
	mv a1, s9
	lw a2, 8(sp)
	lw a3, 20(sp)
	jal ra, write_matrix

	addi sp, sp, 24
	# mv a0, s3
	# jal ra, free
	# mv a0, s4
	# jal ra, free
	# mv a0, s5
	# jal ra, free
	# mv a0, s7
	# jal ra, free
	# mv a0, s9
	# jal ra, free

	#epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)
	lw s7, 28(sp)
	lw s8, 32(sp)
	lw s9, 36(sp)
	lw ra, 40(sp)
	addi sp, sp, 44

    ret
error49:
	li a1, 49
	jal ra, exit2
error56:
	li a1, 56
	jal ra, exit2
