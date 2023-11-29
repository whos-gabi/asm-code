.data
    n:           .space 4
    v:           .space 400
    formatScanf: .asciz "%d"
    x:           .space 4

.text
.global main


main:
    # read n
    push $formatScanf  # push format string
    push $n
    call scanf
    add $8, %esp  # Adjust the stack pointer to remove the pushed values

    # print debug message
    mov $formatScanf, %edi
    call printf
    add $4, %esp  # Adjust the stack pointer to remove the pushed value

    # read v
    movl $0, %ecx
    movl $n, %edi
    
    et_loop:
    cmp (%edi), %ecx
    je exit

    # print debug message
    mov $formatScanf, %edi
    call printf
    add $4, %esp  # Adjust the stack pointer to remove the pushed value

    push $formatScanf  # push format string
    push $x
    call scanf
    add $8, %esp  # Adjust the stack pointer to remove the pushed values

    # print debug message
    mov $formatScanf, %edi
    call printf
    add $4, %esp  # Adjust the stack pointer to remove the pushed value

    movl %eax, v(, %ecx, 4)
    inc %ecx
    jmp et_loop

exit:
    mov $1, %eax  # exit = 1
    mov $0, %ebx  # exit code = 0
    int $0x80     # call kernel
