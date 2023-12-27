# x86 asembly code AT&T
# RUN: gcc -m32 main.s -o main -no-pie && ./main 
# proceduri
// f(x) = 2 * g(x)
// g(x) = x + 1
.data
    x: .long 10
.text
.global main
main:
    // restaureaza stiva
    // %ebx
    // %edi
    // %esi
    // %ebp
    // %esp
    g:
    push %ebp
    mov %esp, %ebp
    mov 8(%ebp), %eax
    add $1, %eax
    pop %ebp
    ret

    f:
    push %ebp
    mov %esp, %ebp
    mov 8(%ebp), %eax
    push %eax
    call g
    add $4, %esp
    mov $2, %ecx
    mul %ecx
    pop %ebp
    ret


    
    
    #return 0
    mov $1, %eax 
    mov $0, %ebx
    int  $0x80
