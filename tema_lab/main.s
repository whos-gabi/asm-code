# gcc -c main.s -o main.o && gcc -no-pie main.o -o main && ./main < input.txt
# gcc -m32 main.s -o main -no-pie && ./main < input.txt 
# < input.txt
# Life game in assembly
.data
    // define n maximum int(18)
    m: .space 4
    n: .space 4
    p: .space 4
    k: .space 4

    // define x and y
    i: .space 4
    j: .space 4
    // define matrix
    matrix: .space 400 
    //
    lineIdx: .space 4
    colIdx: .space 4
    // define format strings
    formatScanf: .asciz "%d" # Input format string
    formatPrintf: .asciz "%d \n" # Output format string
    mx_printf: .asciz "%d " # Output format string
    formatXuy: .asciz "%d %d %d\n" # Output format string
    endl: .asciz "\n" # Output format string
    output_str: .asciz "Xuinea: %s\n"  # Output format string
.text
.global main
main:
    jmp citire1 # citire brat 



citire1:
    push $m # citire m
    push $formatScanf
    call scanf
    add $8, %esp

    push $n # citire n
    push $formatScanf
    call scanf
    add $8, %esp

fill_matrix:
    // multiply n+2 with m+2
    movl m, %eax
    addl $2, %eax
    movl %eax, %ebx # ebx = m+2

    movl n, %eax
    addl $2, %eax
    imull %ebx, %eax # eax = (n+2)*(m+2)
    movl %eax, %ebx


    movl $0, %ecx
    mov $matrix, %edi
    for_fill_matrix:
        cmpl %ebx, %ecx
        je xuy1 #jg?
        movl $0, matrix(,%ecx,4)
        addl $1, %ecx # i++
        jmp for_fill_matrix

    xuy1:

    push $p # citire p
    push $formatScanf
    call scanf
    add $8, %esp

    #for p times read x and y and set matrix[x][y] = 1 for( int i =0, i<p, i++)
    mov $0, %ecx
    for_fill:
        cmp p, %ecx
        je cirire2
        pusha
        #do xuynea

        # Read x and y
        pusha
        pushl $i
        push $formatScanf
        call scanf
        add $8, %esp
        popa

        pusha
        push $j
        push $formatScanf
        call scanf
        add $8, %esp
        popa
        

        # Calculate the index in the matrix
        movl $0, %eax    # Assuming each element is a 32-bit integer
        movl $0, %edx
        incl i
        movl i, %ebx       # Use movl instead of mov to load the value from variable i
        imull n, %ebx      # Use %ebx instead of ebx
        addl j, %ebx       # Use addl instead of add to perform the addition
        addl $1, %ebx      # Add 1 to the calculated value
        movl %ebx, %edx    # Move the result to %edx (assuming it's the index)

        # Set matrix[x][y] = 1
        movl $1, matrix(,%edx,4)

        popa
        #end xuynea
        add $1, %ecx
        jmp for_fill



cirire2:
    push $k # citire k
    push $formatScanf
    call scanf
    add $8, %esp

   
    jmp print_matrix


cout_for_lines:
    pushl $endl
    call printf
    add $4, %esp
    incl lineIdx
    jmp for_lines

print_matrix:
    // for i<=n*m printf matrix[i]" " and add endl at the end of the line
    movl m, %eax
    movl n, %ebx
    imull %ebx, %eax # eax = n*m
    movl %eax, %ebx

    // pushl %ebx
    // pushl $formatPrintf # print n*m
    // call printf
    // add $8, %esp

    movl $1, lineIdx # lineIdx = 0
    for_lines:
        mov lineIdx, %ecx
        cmp m, %ecx
        jg et_exit
        movl $1, colIdx # colIdx = 0
        for_cols:
            mov colIdx, %ecx
            cmp n, %ecx
            jg cout_for_lines

            mov lineIdx, %eax
            imull n, %eax
            addl colIdx, %eax
            
            pusha
            pushl matrix(,%eax,4)
            pushl $mx_printf
            call printf
            add $8, %esp
            popa

            mov lineIdx, %eax
            imull n, %eax
            addl colIdx, %eax
            incl colIdx
            jmp for_cols


et_exit:
    #exit naxui damoi
    mov  $1,     %eax  # exit = 1
    mov  $0,     %ebx  # exit code = 0
    int  $0x80         # call kernel
