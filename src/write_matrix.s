.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

open_file:
    mv a1, s0
    li a2, 1
    jal fopen
check_open_status:
    blt a0, zero, exit_93
    mv s4, a0 # s4 = fd
malloc_for_size:
    li a0, 8
    jal malloc
    mv s5, a0
write_size:
    sw s2, 0(s5)
    sw s3, 4(s5)
    mv a1, s4
    mv a2, s5
    li a3, 2
    li a4, 4
    jal fwrite
    li t0, 2
    bne a0, t0, exit_94
    
write_elements:
    mul t0, s2, s3
    mv a1, s4
    mv a2, s1
    mv a3, t0
    li a4, 4
    addi sp, sp, -4
    sw t0, 0(sp)
    jal fwrite
    lw t0, 0(sp)
    addi sp, sp, 4
    bne a0, t0, exit_94 

end:
    mv a0, s5
    jal free
    mv a1, s4
    jal fclose
    blt a0, zero, exit_95
    
    # Epilogue

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    ret

exit_93:
    li a1, 93
    j exit2

exit_94:
    li a1, 94
    j exit2

exit_95:
    li a1, 95
    j exit2