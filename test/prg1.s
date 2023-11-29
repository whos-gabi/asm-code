# x86 asembly code 
# RUN: gcc -c prg1.s -o prg1.o && gcc -no-pie prg1.o -o prg1 && ./prg1
#
.data
    a: .long 10
    b: .byte 50
    c: .asciz "Sirul de caractere:\n"
	d: .space 20
.text
.global main
main:
    mov a, %eax
    mov b, %eax
    mov c, %eax
    mov d, %eax   
    #clear eax
    xor %eax, %eax
    jmp exit


    // mov $4, %eax  # print = 4
    // mov $1, %ebx  # stdout = 1
    // mov $str, %ecx  # address of string
    // mov $15, %edx # length of string
    // int  $0x80   # call kernel

exit:
    mov $1, %eax  # exit = 1
    mov $0, %ebx # exit code = 0
    int  $0x80  # call kernel
