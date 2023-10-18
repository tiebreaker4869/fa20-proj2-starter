.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
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
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

init:
    mv s0, a0
    mv s1, a1
    mv s2, a2

open_file:
    mv a1, s0
    li a2, 0
    jal fopen
check_open_status:
    blt a0, zero, exit_90
    mv s3, a0 # s3 = fd

read_size:
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    blt a0, t0, exit_91

    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    blt a0, t0, exit_91

calculate_allocate_size:
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1
    slli t0, t0, 2

allocate_array:
    mv a0, t0
    jal malloc

check_malloc_status:
    ble a0, zero, exit_88
    mv s4, a0

read_content:
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1
    li t1, 0
read_loop:
    bge t1, t0, end
    slli t2, t1, 2
    add t2, t2, s4
    mv a1, s3
    mv a2, t2
    li a3, 4
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    jal fread
    li t2, 4
    blt a0, t2, exit_91
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12
    addi t1, t1, 1
    j read_loop
    
end:
    
    mv a1, s3
    jal fclose
    blt a0, zero, exit_92
    mv a0, s4
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret

exit_88:
    li a1, 88
    j exit2

exit_90:
    li a1, 90
    j exit2

exit_91:
    li a1, 91
    j exit2

exit_92:
    li a1, 92
    j exit2