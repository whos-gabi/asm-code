# x86 asembly code 
# RUN: gcc -c hello.s -o hello.o && gcc -no-pie hello.o -o hello && ./hello
#
.data
	str: .asciz "Hello world\n"
.text
.global main
main:
    mov $4, %eax 
    mov $1, %ebx
    mov $str, %ecx
    mov $15, %edx
    int  $0x80

    mov $1, %eax 
    mov $0, %ebx
    int  $0x80
