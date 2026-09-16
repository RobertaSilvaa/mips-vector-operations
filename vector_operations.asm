# Vector Operations
# Description: Reads two integer vectors with 2 to 32 elements and performs
#              element-wise addition or multiplication.

.data
.align 2
vector_a:      .space 128
vector_b:      .space 128
result_vector: .space 128

operation_prompt:          .asciiz "This program adds or multiplies two vectors.\nEnter 0 for addition or 1 for multiplication: "
invalid_operation_message: .asciiz "Invalid operation. Enter 0 for addition or 1 for multiplication.\n"
size_prompt:               .asciiz "Enter the vector size (2-32): "
invalid_size_message:      .asciiz "Invalid size. Enter an integer from 2 to 32.\n"
input_count_prefix:        .asciiz "Enter the "
vector_a_input_suffix:     .asciiz " elements of vector A:\n"
vector_b_input_suffix:     .asciiz " elements of vector B:\n"
result_prefix:             .asciiz "Result of "
addition_text:             .asciiz "addition"
multiplication_text:       .asciiz "multiplication"
result_suffix:             .asciiz " between the vectors:\n"
continue_prompt:           .asciiz "Enter 0 for another addition, 1 for another multiplication, or any other integer to exit: "
newline_string:            .asciiz "\n"

.text
.globl main

main:
operation_input_loop:
    # Question 1: display the operation menu.
    li $v0, 4
    la $a0, operation_prompt
    syscall

    # Question 2: read and validate the operation.
    li $v0, 5
    syscall
    move $s0, $v0

    beqz $s0, size_input_loop
    li $t0, 1
    beq $s0, $t0, size_input_loop

    li $v0, 4
    la $a0, invalid_operation_message
    syscall
    j operation_input_loop

size_input_loop:
    # Question 3: request the vector size.
    li $v0, 4
    la $a0, size_prompt
    syscall

    # Question 4: read and validate the vector size.
    li $v0, 5
    syscall
    move $s1, $v0

    blt $s1, 2, invalid_size
    bgt $s1, 32, invalid_size

    # Question 5: request vector A.
    li $v0, 4
    la $a0, input_count_prefix
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, vector_a_input_suffix
    syscall

    # Question 6: read vector A.
    la $a0, vector_a
    move $a1, $s1
    jal read_vector

    # Question 7: request vector B.
    li $v0, 4
    la $a0, input_count_prefix
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, vector_b_input_suffix
    syscall

    # Question 8: read vector B.
    la $a0, vector_b
    move $a1, $s1
    jal read_vector

    # Questions 9 and 10: calculate and store the selected element-wise result.
    beqz $s0, perform_addition
    j perform_multiplication

perform_addition:
    la $a0, vector_a
    la $a1, vector_b
    la $a2, result_vector
    move $a3, $s1
    jal add_vectors

    la $s2, addition_text
    j print_result

perform_multiplication:
    la $a0, vector_a
    la $a1, vector_b
    la $a2, result_vector
    move $a3, $s1
    jal multiply_vectors

    la $s2, multiplication_text

print_result:
    li $v0, 4
    la $a0, result_prefix
    syscall

    li $v0, 4
    move $a0, $s2
    syscall

    li $v0, 4
    la $a0, result_suffix
    syscall

    # Question 12: print every element from the result vector.
    la $a0, result_vector
    move $a1, $s1
    jal print_vector

    # Question 13: request another operation or exit.
    li $v0, 4
    la $a0, continue_prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    # Question 14: continue only for operation 0 or 1.
    beqz $t0, continue_with_addition
    li $t1, 1
    beq $t0, $t1, continue_with_multiplication

    li $v0, 10
    syscall

continue_with_addition:
    li $s0, 0
    j size_input_loop

continue_with_multiplication:
    li $s0, 1
    j size_input_loop

invalid_size:
    li $v0, 4
    la $a0, invalid_size_message
    syscall
    j size_input_loop

# Input: $a0 = vector base address, $a1 = number of elements.
read_vector:
    move $t0, $a0
    move $t1, $a1

read_vector_loop:
    beqz $t1, read_vector_done

    li $v0, 5
    syscall
    sw $v0, 0($t0)

    addiu $t0, $t0, 4
    addiu $t1, $t1, -1
    j read_vector_loop

read_vector_done:
    jr $ra

# Input:
#   $a0 = vector A base address
#   $a1 = vector B base address
#   $a2 = result vector base address
#   $a3 = number of elements
add_vectors:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3

add_vectors_loop:
    beqz $t3, add_vectors_done

    lw $t4, 0($t0)
    lw $t5, 0($t1)
    addu $t6, $t4, $t5
    sw $t6, 0($t2)

    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    addiu $t2, $t2, 4
    addiu $t3, $t3, -1
    j add_vectors_loop

add_vectors_done:
    jr $ra

# Input:
#   $a0 = vector A base address
#   $a1 = vector B base address
#   $a2 = result vector base address
#   $a3 = number of elements
multiply_vectors:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3

multiply_vectors_loop:
    beqz $t3, multiply_vectors_done

    lw $t4, 0($t0)
    lw $t5, 0($t1)
    mult $t4, $t5
    mflo $t6
    sw $t6, 0($t2)

    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    addiu $t2, $t2, 4
    addiu $t3, $t3, -1
    j multiply_vectors_loop

multiply_vectors_done:
    jr $ra

# Input: $a0 = vector base address, $a1 = number of elements.
print_vector:
    move $t0, $a0
    move $t1, $a1

print_vector_loop:
    beqz $t1, print_vector_done

    li $v0, 1
    lw $a0, 0($t0)
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    addiu $t0, $t0, 4
    addiu $t1, $t1, -1
    j print_vector_loop

print_vector_done:
    li $v0, 4
    la $a0, newline_string
    syscall
    jr $ra
