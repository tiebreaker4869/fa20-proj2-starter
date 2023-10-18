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
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
argcheck:
    ble a2, zero, exit_75
    ble a3, zero, exit_76
    ble a4, zero, exit_76

init: # initialize before looping
    mv t0, zero # index into vectors
    mv t1, zero # sum of product

loop_start:
    bge t0, a2, loop_end
    
    slli t2, t0, 2
    mul t3, t2, a3
    add t3, t3, a0
    mul t4, t2, a4
    add t4, t4, a1
    lw t3, 0(t3)
    lw t4, 0(t4)
    mul t4, t4, t3
    add t1, t1, t4

loop_continue:
    addi t0, t0, 1
    j loop_start

loop_end:


    # Epilogue
    mv a0, t1
    
    ret

exit_75:
    li a1, 75
    j exit2

exit_76:
    li a1, 76
    j exit2