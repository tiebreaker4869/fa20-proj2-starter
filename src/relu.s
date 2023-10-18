.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue

argcheck:
    li t1, 1 # t1 =1 
    bge a1, t1, init # if a1 >= 1 init
    li a1, 78 # a1 =78 
    j exit2

init:
    mv t1, zero
loop_start:
    bge t1, a1, loop_end # if t1 >a1 then loop_end
    slli t0, t1, 2
    add t0, t0, a0 
    lw t2, 0(t0) #load array element
    bge t2, zero, loop_continue # if t2 >=zero then loop_continue
    
set_zero:
    sw zero, 0(t0) # set back zero if array element is negative 
loop_continue:
    addi t1, t1, 1
    j loop_start  # jump to loop_start
loop_end:
    # Epilogue
	ret
