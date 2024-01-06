# gcc -m32 tema2.s -o tema2 -no-pie && ./tema2
.data
    fmtScanf: .asciz "%d"
    endl: .asciz "\n" 
    fPrintf: .asciz "%d " 
    
    #date pentru citire
    m: .space 4
    n: .space 4
    p: .space 4
    k: .space 4

    i: .space 4
    j: .space 4
    
    #valoarea celulei
    cell: .space 4
    #numarul de vecini
    cntr: .space 4

    matrice: .space 400 
    #matricea copiata
    matrice2: .space 400

    x: .space 4
    y: .space 4

    #operatii cu fisiere
    fisIntrare: .asciz "in.txt"
    fisIesire: .asciz "out.txt"
    #cod de citire sau scriere
    modCitire: .asciz "r"
    modScriere: .asciz "w"
    #continutul fisierului
    fin: .long 0
    fout: .long 0    
.text
.global main
main:
    #deschidere fisier pentru citire
    push $modCitire
    push $fisIntrare
    call fopen
    add $8, %esp
    mov %eax, fin

    #deschidere fisier pentru scriere
    push $modScriere
    push $fisIesire
    call fopen
    add $8, %esp
    mov %eax, fout

    #citesc m si n
    push $m 
    push $fmtScanf
    push fin 
    call fscanf
    pop %eax
    pop %eax
    pop %eax

    push $n 
    push $fmtScanf
    push fin 
    call fscanf
    pop %eax
    pop %eax
    pop %eax


    movl m, %eax
    addl $2, %eax
    movl %eax, %ebx 

    movl n, %eax
    addl $2, %eax
    imull %ebx, %eax
    movl %eax, %ebx

    #bordaree matricei
    movl $0, %ecx
    border_mx:
        cmpl %ebx, %ecx
        je bmxok 
        movl $0, matrice(,%ecx,4)
        addl $1, %ecx 
        jmp border_mx

    bmxok:
    
    push $p # citire p
    push $fmtScanf
    push fin
    call fscanf
    add $12, %esp

    call citeste_celule

    push $k
    push $fmtScanf
    push fin
    call fscanf
    add $12, %esp

    jmp evolutie

citeste_celule:
    mov $0, %ecx
    cit_celula:
        cmp p, %ecx
        je cellok

        pusha
        push $i
        push $fmtScanf
        push fin
        call fscanf
        add $12, %esp
        popa

        pusha
        push $j
        push $fmtScanf
        push fin
        call fscanf
        add $12, %esp
        popa

        movl i, %eax
        addl $1, %eax
        movl n, %ebx
        addl $2, %ebx
        imull %ebx, %eax
        movl j, %ebx
        addl $1, %ebx
        addl %ebx, %eax

        lea matrice, %edi
        movl $1, (%edi,%eax,4)

        add $1, %ecx
        jmp cit_celula

    cellok:
    ret


calcul_cell:
    #initializare
    movl $0, %eax
    movl x, %ecx
    movl y, %edx
    movl $0, cntr

    mov %ecx, %eax
    movl n, %ebx
    addl $2, %ebx
    imull %ebx, %eax
    movl %edx, %ebx
    addl %ebx, %eax


    movl %eax, %ebx
    subl n, %ebx
    subl $2, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    subl n, %ebx
    subl $3, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    subl $1, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    subl n, %ebx
    subl $1, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    addl $1, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    addl n, %ebx
    addl $2, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    addl n, %ebx
    addl $1, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    movl %eax, %ebx
    addl n, %ebx
    addl $3, %ebx
    leal matrice(,%ebx,4), %edi
    movl (%edi), %ebx
    addl %ebx, cntr

    ret


evolutia_celulei:
    pusha
    movl cell, %eax
    cmp $0, %eax    
    je cell_is_dead 
    #daca celula e via, continua 
    movl cntr, %eax
    cmp $2, %eax
    jl kill_cell     
    cmp $3, %eax
    jg kill_cell     
    jmp next_cell    

cell_is_dead:
    movl cntr, %eax
    cmp $3, %eax
    je make_alive    
    jmp next_cell

kill_cell:
    call kill_cell_procedure
    jmp next_cell

make_alive:
    call make_alive_procedure

next_cell:
    popa
    ret


ev_line:
    incl x
    jmp loop_ev_lines

evolutie:
    # margi prin k evolutii
    mov $0, %edx
    loop_k:
        cmp k, %edx
        je print
    
        call cp_mx_to_cmx

        movl $1, x  
        loop_ev_lines:
            mov x, %ecx  
            movl m, %ebx       
            addl $1, %ebx      
            cmpl %ebx, %ecx    
            jge exit_ev_loop   

            
            movl $1, y   
            for_cv_cols:
                mov y, %ecx     
                movl n, %ebx         
                addl $1, %ebx        
                cmpl %ebx, %ecx      
                jge ev_line 

                mov x, %eax        
                movl n, %ebx             
                addl $2, %ebx            
                imull %ebx, %eax         
                movl y, %ebx        
                addl %ebx, %eax  

                leal matrice(,%eax,4), %edi    
                movl (%edi), %eax
                movl %eax, cell
    
                pusha
                call calcul_cell
                popa
                
                call evolutia_celulei

                incl y  
                jmp for_cv_cols 

            exit_ev_loop:
                call cp_cmx_to_mx

    add $1, %edx
    jmp loop_k


print:
    movl $1, x  
    for_lines:
        mov x, %ecx
        movl m, %ebx     
        addl $1, %ebx    
        cmpl %ebx, %ecx  
        jge et_exit      
        movl $1, y  

        for_cols:
            mov y, %ecx  
            movl n, %ebx      
            addl $1, %ebx     
            cmpl %ebx, %ecx   
            jge cout_for_lines

            mov x, %eax        
            movl n, %ebx             
            addl $2, %ebx            
            imull %ebx, %eax         
            movl y, %ebx        
            addl %ebx, %eax             

            pusha
            leal matrice(,%eax,4), %edi   
            movl (%edi), %eax            
            pushl %eax                   
            pushl $fPrintf             
            pushl fout            
            call fprintf                  
            pop %eax
            pop %eax
            pop %eax
            popa                

            incl y   
            jmp for_cols  

        cout_for_lines:
            pushl $endl   
            pushl fout
            call fprintf   
            addl $8, %esp
            incl x  
            jmp for_lines 

    et_exit:
        #inchide fisier de intrare si de iesire
        push fin 
        push fout 
        call fclose
        add $4, %esp
        #iesire din program
        mov  $1,     %eax
        mov  $0,     %ebx
        int  $0x80

kill_cell_procedure:
    mov x, %eax        
    movl n, %ebx             
    addl $2, %ebx            
    imull %ebx, %eax         
    movl y, %ebx        
    addl %ebx, %eax  


    leal matrice2(,%eax,4), %edi
    movl $0, (%edi)
    ret

make_alive_procedure:
    mov x, %eax        
    movl n, %ebx             
    addl $2, %ebx            
    imull %ebx, %eax         
    movl y, %ebx        
    addl %ebx, %eax  

    leal matrice2(,%eax,4), %edi
    movl $1, (%edi)
    ret

cp_mx_to_cmx:
    movl n, %eax
    addl $2, %eax
    movl %eax, %ebx  
    movl m, %eax
    addl $2, %eax
    imull %ebx, %eax

    movl %eax, %ecx 
    movl $matrice, %esi
    movl $matrice2, %edi

loop_cell_mx:
    movl (%esi), %eax      
    movl %eax, (%edi)      
    addl $4, %esi          
    addl $4, %edi          
    decl %ecx              
    jnz loop_cell_mx 
    ret

cp_cmx_to_mx:
    movl n, %eax
    addl $2, %eax
    movl %eax, %ebx 
    movl m, %eax
    addl $2, %eax 
    imull %ebx, %eax

    movl %eax, %ecx 
    movl $matrice2, %esi 
    movl $matrice, %edi 
loop_cell_cmx:
    movl (%esi), %eax          
    movl %eax, (%edi)          
    addl $4, %esi              
    addl $4, %edi              
    decl %ecx                  
    jnz loop_cell_cmx
    ret