.data
	str: .asciz "Hello world\n"
.text
.global main
main:
    #cout
    mov $4, %eax 
    mov $1, %ebx
    mov $str, %ecx
    mov $15, %edx
    int  $0x80

    #return 0
    mov $1, %eax 
    mov $0, %ebx
    int  $0x80
