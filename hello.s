.data
  #x86 asembly  code
  #RUN: gcc -c hello.s -o hello.o && gcc -no-pie hello.o -o hello && ./hello
  str: .asciz, "Hello, world\n"
.text
  .global main
main:
  mov  $4,     %eax  # print = 4
  mov  $1,     %ebx  # stdout = 1
  mov  $str,   %ecx  # address of string
  mov  $15,    %edx  # length of string

  int  $0x80         # call kernel
  mov  $1,     %eax  # exit = 1
  mov  $0,     %ebx  # exit code = 0
  int  $0x80         # call kernel
