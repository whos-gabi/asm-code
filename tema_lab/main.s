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
    cp_matrix: .space 400
    // define 
    element: .space 4
    vecini: .space 4
    //lineIdx and colIdx
    lineIdx: .space 4
    colIdx: .space 4
    // define format strings
    formatScanf: .asciz "%d"
    mx_printf: .asciz "%d " 
    endl: .asciz "\n" 
    fPrintf: .asciz "%d " 
    
    dead: .asciz "dead\n"
    alive: .asciz "alive\n"
    testPrint: .asciz "element %d : %d \n"
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
    // mov $matrix, %edi
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
        je citire2

        # Read i
        pusha
        push $i
        push $formatScanf
        call scanf
        add $8, %esp
        popa

        # Read j
        pusha
        push $j
        push $formatScanf
        call scanf
        add $8, %esp
        popa

        # Calculate the index in the matrix

        movl i, %eax
        addl $1, %eax            # Adjust i for boundary

        movl n, %ebx
        addl $2, %ebx
        imull %ebx, %eax         # Calculate row offset

        movl j, %ebx
        addl $1, %ebx            # Adjust j for boundary
        addl %ebx, %eax          # Add column offset

        # Set the cell in the matrix to 1
        lea matrix, %edi
        movl $1, (%edi,%eax,4)
        


        #print %eax 
        // pusha
        // pushl %eax
        // pushl $fPrintf
        // call printf
        // add $8, %esp
        // popa



        add $1, %ecx
        jmp for_fill


citire2:
    push $k # citire k
    push $formatScanf
    call scanf
    add $8, %esp
   
    jmp evolution


copy_matrix:
    movl n, %eax
    addl $2, %eax
    movl %eax, %ebx  # store (n+2) in %ebx
    movl m, %eax
    addl $2, %eax    # calculate (m+2)
    imull %ebx, %eax

    movl %eax, %ecx  # counter
    movl $matrix, %esi    # source matrix address
    movl $cp_matrix, %edi # destination matrix address
for_elem_in_matrix:
    movl (%esi), %eax          # load value from source matrix
    movl %eax, (%edi)          # store value into destination matrix
    addl $4, %esi              # increment source address
    addl $4, %edi              # increment destination address
    decl %ecx                  # decrement counter
    jnz for_elem_in_matrix    # if counter is not zero, loop again
    ret

copy_matrix_back:
    movl n, %eax
    addl $2, %eax
    movl %eax, %ebx  # store (n+2) in %ebx
    movl m, %eax
    addl $2, %eax    # calculate (m+2)
    imull %ebx, %eax

    movl %eax, %ecx  # counter
    movl $cp_matrix, %esi    # source matrix address
    movl $matrix, %edi # destination matrix address
for_elem_in_matrix_back:
    movl (%esi), %eax          # load value from source matrix
    movl %eax, (%edi)          # store value into destination matrix
    addl $4, %esi              # increment source address
    addl $4, %edi              # increment destination address
    decl %ecx                  # decrement counter
    jnz for_elem_in_matrix_back    # if counter is not zero, loop again
    ret



count_vecini:
    movl $0, %eax                # Initialize sum to 0
    movl lineIdx, %ebx           # Load lineIdx into %ebx
    movl colIdx, %ecx            # Load colIdx into %ecx
    movl $0, vecini              # Initialize vecini to 0

    # Calculate base index for the current cell in %eax
    mov lineIdx, %eax        
    movl n, %ebx             
    addl $2, %ebx            
    imull %ebx, %eax         
    movl colIdx, %ebx        
    addl %ebx, %eax 


    // # Neighbor [i-1][j-1]
    movl %eax, %ebx
    subl n, %ebx
    subl $3, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    
    // # Neighbor [i-1][j]
    //get element eax - n - 2
    movl %eax, %ebx
    subl n, %ebx
    subl $2, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini

    // # Neighbor [i-1][j+1]
    //get element eax - n - 1
    movl %eax, %ebx
    subl n, %ebx
    subl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    // # Neighbor [i][j-1]
    //get element eax - 1
    movl %eax, %ebx
    subl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini

    // # Neighbor [i][j+1]
    //get element eax + 1
    movl %eax, %ebx
    addl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini

    // # Neighbor [i+1][j-1]
    //get element eax + n + 1
    movl %eax, %ebx
    addl n, %ebx
    addl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    // # Neighbor [i+1][j]
    //get element eax + n + 2
    movl %eax, %ebx
    addl n, %ebx
    addl $2, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini

    // # Neighbor [i+1][j+1]
    //get element eax + n + 3
    movl %eax, %ebx
    addl n, %ebx
    addl $3, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini

    ret



cout_forcv_lines:
    incl lineIdx
    jmp for_cv_lines

evolution:
    // print endl
    pusha
    pushl $endl
    call printf
    add $4, %esp
    popa




    // loop k times
    mov $0, %edx
    for_k:
        cmp k, %edx
        je print_matrix
        

        pusha
        pushl $endl
        call printf
        add $4, %esp
        popa


        // pusha
        call copy_matrix
        // popa
        

        movl $1, lineIdx              # Initialize lineIdx to 0
        for_cv_lines:
            mov lineIdx, %ecx             # Load lineIdx into %ecx
            movl m, %ebx                  # Load m into %ebx
            addl $1, %ebx                 # m + 2 for boundary rows
            cmpl %ebx, %ecx               # Compare with m + 2
            jge exit_ev_loop                   # Jump to exit if lineIdx >= m + 2

            
            movl $1, colIdx               # Reset colIdx to 0   
            for_cv_cols:
                mov colIdx, %ecx              # Load colIdx into %ecx
                movl n, %ebx                  # Load n into %ebx
                addl $1, %ebx                 # n + 2 for boundary columns
                cmpl %ebx, %ecx               # Compare with n + 2
                jge cout_forcv_lines            # Jump if colIdx >= n + 2 

                # Calculate linear index for printing
                mov lineIdx, %eax        
                movl n, %ebx             
                addl $2, %ebx            
                imull %ebx, %eax         
                movl colIdx, %ebx        
                addl %ebx, %eax  

                // pusha
                leal matrix(,%eax,4), %edi    
                movl (%edi), %eax
                movl %eax, element
                // popa
    
                pusha
                call count_vecini
                popa
                
                // print vecini
                // pusha
                // pushl vecini
                // pushl $fPrintf
                // call printf
                // add $8, %esp
                // popa

                pusha
                    movl element, %eax
                    cmp $0, %eax            # Compare cell value with 0          
                    je cell_is_dead  # Jump if cell is dead

                    # Cell is alive: Apply Game of Life rules
                    movl vecini, %eax
                    cmp $2, %eax
                    jl kill_cell
                    cmp $3, %eax
                    jg kill_cell
                    
                 
                    jmp next_cell
                popa
               
                cell_is_dead:
                    # Cell is dead: Apply Game of Life rules
                    movl vecini, %eax
                    cmp $3, %eax
                    je make_alive

                    # Keep the cell dead
                    jmp next_cell
                kill_cell:
                    mov lineIdx, %eax        
                    movl n, %ebx             
                    addl $2, %ebx            
                    imull %ebx, %eax         
                    movl colIdx, %ebx        
                    addl %ebx, %eax  


                    leal cp_matrix(,%eax,4), %edi
                    movl $0, (%edi)

                    jmp next_cell

                make_alive:
                    mov lineIdx, %eax        
                    movl n, %ebx             
                    addl $2, %ebx            
                    imull %ebx, %eax         
                    movl colIdx, %ebx        
                    addl %ebx, %eax  

                    leal cp_matrix(,%eax,4), %edi
                    movl $1, (%edi)

                    // jmp next_cell

                next_cell:


                // # Print the matrix element
                pusha
                leal matrix(,%eax,4), %edi    # Calculate memory address of matrix element
                movl (%edi), %eax             # Load matrix element into %eax
                pushl %eax                    # Push value to be printed
                pushl $mx_printf              # Push format string
                call printf                   # Call printf
                addl $8, %esp
                popa                # Clean up the stack    

                incl colIdx                   # Increment colIdx
                jmp for_cv_cols                  # Jump back to for_cols   

            exit_ev_loop:
                // pusha
                call copy_matrix_back
                // popa


    // End loop
    add $1, %edx
    jmp for_k


//FINAL COUT SUKA BLEA 
print_matrix:
    pusha
    pushl $endl
    call printf
    add $4, %esp
    popa
    movl $1, lineIdx              # Initialize lineIdx to 0
    for_lines:
        mov lineIdx, %ecx             # Load lineIdx into %ecx
        movl m, %ebx                  # Load m into %ebx
        addl $1, %ebx                 # m + 2 for boundary rows
        cmpl %ebx, %ecx               # Compare with m + 2
        jge et_exit                   # Jump to exit if lineIdx >= m + 2
        movl $1, colIdx               # Reset colIdx to 0   

        for_cols:
            mov colIdx, %ecx              # Load colIdx into %ecx
            movl n, %ebx                  # Load n into %ebx
            addl $1, %ebx                 # n + 2 for boundary columns
            cmpl %ebx, %ecx               # Compare with n + 2
            jge cout_for_lines            # Jump if colIdx >= n + 2 

            # Calculate linear index for printing
            mov lineIdx, %eax        
            movl n, %ebx             
            addl $2, %ebx            
            imull %ebx, %eax         
            movl colIdx, %ebx        
            addl %ebx, %eax             

            # Print the matrix element
            pusha
            leal matrix(,%eax,4), %edi    # Calculate memory address of matrix element
            movl (%edi), %eax             # Load matrix element into %eax
            pushl %eax                    # Push value to be printed
            pushl $mx_printf              # Push format string
            call printf                   # Call printf
            addl $8, %esp
            popa                # Clean up the stack    

            incl colIdx                   # Increment colIdx
            jmp for_cols                  # Jump back to for_cols   

cout_for_lines:
    pushl $endl                   # Push end line string
    call printf                   # Call printf
    addl $4, %esp                 # Clean up the stack
    incl lineIdx                  # Increment lineIdx
    jmp for_lines                 # Jump back to for_lines

et_exit:
    #exit naxui damoi
    mov  $1,     %eax  # exit = 1
    mov  $0,     %ebx  # exit code = 0
    int  $0x80         # call kernel
