# gcc -m32 main.s -o main -no-pie && ./main
.data
inputFilename: .asciz "in.txt"
readMode: .asciz "r"
formatStr: .asciz "%d"
outputStr: .asciz "%d\n"
fin: .long 0
n: .space 4

.text
.global main
main:
     # Open input file for reading
    pushl $readMode
    pushl $inputFilename
    call fopen
    add $8, %esp
    mov %eax, fin           # Save file pointer
  
    # Read digit from file
    pushl $n
    pushl $formatStr
    pushl fin
    call fscanf
    add $12, %esp

    # Increment n
    movl n, %eax
    addl $1, %eax
    movl %eax, n

    # Print n+1 to console
    push %eax
    push $outputStr
    call printf
    add $8, %esp

exit:
    # Close file
    push fin #also add fout if used
    call fclose
    add $4, %esp

    # Exit
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80