# gcc -m32 part_0.s -o part_0 -no-pie && ./part_0 < input.txt 
# < input.txt
# Life game in assembly final project
.data
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
    endl: .asciz "\n" 
    fPrintf: .asciz "%d " 
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
    movl m, %eax
    addl $2, %eax
    movl %eax, %ebx # ebx = m+2

    movl n, %eax
    addl $2, %eax
    imull %ebx, %eax
    movl %eax, %ebx


    movl $0, %ecx
    // mov $matrix, %edi
    for_fill_matrix:
        cmpl %ebx, %ecx
        je xuy1 
        movl $0, matrix(,%ecx,4)
        addl $1, %ecx 
        jmp for_fill_matrix

    xuy1:

    push $p # citire p
    push $formatScanf
    call scanf
    add $8, %esp
    
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
        addl $1, %eax
        movl n, %ebx
        addl $2, %ebx
        imull %ebx, %eax
        movl j, %ebx
        addl $1, %ebx
        addl %ebx, %eax

        # Set the cell in the matrix to 1
        lea matrix, %edi
        movl $1, (%edi,%eax,4)

        add $1, %ecx
        jmp for_fill


citire2:
    push $k
    push $formatScanf
    call scanf
    add $8, %esp
   
    jmp evolution


copy_matrix:
    movl n, %eax
    addl $2, %eax
    movl %eax, %ebx  
    movl m, %eax
    addl $2, %eax
    imull %ebx, %eax

    movl %eax, %ecx 
    movl $matrix, %esi
    movl $cp_matrix, %edi
for_elem_in_matrix:
    movl (%esi), %eax      
    movl %eax, (%edi)      
    addl $4, %esi          
    addl $4, %edi          
    decl %ecx              
    jnz for_elem_in_matrix 
    ret

copy_matrix_back:
    movl n, %eax
    addl $2, %eax
    movl %eax, %ebx 
    movl m, %eax
    addl $2, %eax 
    imull %ebx, %eax

    movl %eax, %ecx 
    movl $cp_matrix, %esi 
    movl $matrix, %edi 
for_elem_in_matrix_back:
    movl (%esi), %eax          
    movl %eax, (%edi)          
    addl $4, %esi              
    addl $4, %edi              
    decl %ecx                  
    jnz for_elem_in_matrix_back
    ret

count_vecini:
    movl $0, %eax     
    movl lineIdx, %ebx
    movl colIdx, %ecx 
    movl $0, vecini   

    # Calculate base index for the current cell in %eax
    mov lineIdx, %eax        
    movl n, %ebx             
    addl $2, %ebx            
    imull %ebx, %eax         
    movl colIdx, %ebx        
    addl %ebx, %eax 

    # Neighbor [i-1][j-1]
    movl %eax, %ebx
    subl n, %ebx
    subl $3, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i-1][j]
    movl %eax, %ebx
    subl n, %ebx
    subl $2, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i-1][j+1]
    movl %eax, %ebx
    subl n, %ebx
    subl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i][j-1]
    movl %eax, %ebx
    subl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i][j+1]
    movl %eax, %ebx
    addl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i+1][j-1]
    movl %eax, %ebx
    addl n, %ebx
    addl $1, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i+1][j]
    movl %eax, %ebx
    addl n, %ebx
    addl $2, %ebx
    leal matrix(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, vecini
    # Neighbor [i+1][j+1]
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
    // loop k times
    mov $0, %edx
    for_k:
        cmp k, %edx
        je print_matrix
    
        call copy_matrix

        movl $1, lineIdx  
        for_cv_lines:
            mov lineIdx, %ecx  
            movl m, %ebx       
            addl $1, %ebx      
            cmpl %ebx, %ecx    
            jge exit_ev_loop   

            
            movl $1, colIdx   
            for_cv_cols:
                mov colIdx, %ecx     
                movl n, %ebx         
                addl $1, %ebx        
                cmpl %ebx, %ecx      
                jge cout_forcv_lines 

                # Calculate linear index for printing
                mov lineIdx, %eax        
                movl n, %ebx             
                addl $2, %ebx            
                imull %ebx, %eax         
                movl colIdx, %ebx        
                addl %ebx, %eax  

                leal matrix(,%eax,4), %edi    
                movl (%edi), %eax
                movl %eax, element
    
                pusha
                call count_vecini
                popa
                
                pusha
                    movl element, %eax
                    cmp $0, %eax    
                    je cell_is_dead 
                  
                    movl vecini, %eax
                    cmp $2, %eax
                    jl kill_cell
                    cmp $3, %eax
                    jg kill_cell
                    
                 
                    jmp next_cell
                popa
               
                cell_is_dead:
                    movl vecini, %eax
                    cmp $3, %eax
                    je make_alive

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

                next_cell:

                incl colIdx  
                jmp for_cv_cols 

            exit_ev_loop:
                call copy_matrix_back


    // End loop
    add $1, %edx
    jmp for_k


print_matrix:
    movl $1, lineIdx  
    for_lines:
        mov lineIdx, %ecx
        movl m, %ebx     
        addl $1, %ebx    
        cmpl %ebx, %ecx  
        jge et_exit      
        movl $1, colIdx  

        for_cols:
            mov colIdx, %ecx  
            movl n, %ebx      
            addl $1, %ebx     
            cmpl %ebx, %ecx   
            jge cout_for_lines

            # Calculate linear index for printing
            mov lineIdx, %eax        
            movl n, %ebx             
            addl $2, %ebx            
            imull %ebx, %eax         
            movl colIdx, %ebx        
            addl %ebx, %eax             

            # Print the matrix element
            pusha
            leal matrix(,%eax,4), %edi   
            movl (%edi), %eax            
            pushl %eax                   
            pushl $fPrintf             
            call printf                  
            addl $8, %esp
            popa                

            incl colIdx   
            jmp for_cols  

cout_for_lines:
    pushl $endl   
    call printf   
    addl $4, %esp 
    incl lineIdx  
    jmp for_lines 

et_exit:
    pushl $0
    call fflush
    popl %ebx
    
    mov  $1,     %eax
    mov  $0,     %ebx
    int  $0x80       
