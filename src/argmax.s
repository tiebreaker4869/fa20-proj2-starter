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
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue

argcheck:
    li t1, 1 # t1 =1 
    bge a1, t1, init # if a1 >= 1 init
    li a0, 77 
    jal exit2

init:
    mv t0, zero
    li t1, -2147483648 # max result in t1
    mv t2, zero # max result index in t2
    
loop_start:
    bge t0, a1, loop_end
    slli t3, t0, 2
    add t3, t3, a0
    lw t3, 0(t3) 
    ble t3, t1, loop_continue

update_result:
    mv t1, t3
    mv t2, t0

loop_continue:
    addi t0, t0, 1
    j loop_start  # jump to loop_start

loop_end:
    
    mv a0, t2 # store result
    # Epilogue


    ret
