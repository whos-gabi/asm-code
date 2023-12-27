# x86 asembly code AT&T
# RUN: gcc -m32 main.s -o main -no-pie && ./main < input.txt
# task: produsul elementelor impare dintr-un vector de lung n
.data
    n: .space 4
    i: .space 4
    x: .space 4
    prod: .space 4
    v: .space 400
    fScanf: .asciz "%d"
    fPrintf: .asciz "%d\n"
.text
.global main
    main:
    movl $1, prod
    jmp citire
    
    
    citire:
    push $n
    push $fScanf
    call scanf
    add $8, %esp
    movl $0, i
    loop_citire_v:
        movl i, %ecx
        cmp %ecx, n
        je afis

        //citire element v[%ecx] vector
        pusha
        pushl $x
        pushl $fScanf
        call scanf
        add $8, %esp
        popa

        // if x % 2 == 0
        // prod *= x
        movl x, %eax
        movl $2, %ebx
        movl $0, %edx
        divl %ebx
        cmp $0, %edx
        je continue
        movl x, %eax
        imull prod, %eax
        movl %eax, prod
        
        pusha
        pushl x
        pushl $fPrintf
        call printf
        add $8, %esp
        popa

        
        movl $x, v(, %ecx, 4)
        continue:

        incl i
        jmp loop_citire_v


    afis:
        pusha
        pushl prod
        pushl $fPrintf
        call printf
        add $8, %esp
        popa
        jmp et_exit
    

    et_exit:
    #return 0
    mov $1, %eax 
    mov $0, %ebx
    int  $0x80
