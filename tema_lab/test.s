
# gcc -m32 test.s -o test -no-pie && ./test < input.txt 
.data
  m: .space 4 #linii
  n: .space 4 #coloane
  p: .space 4  #nrcelulevii
  lineIndex: .space 4
  coloanaIndex : .space 4
  line :.space 4
  col :.space 4
  colIndex :.space 4
  matrix : .space 1600
  k: .space 4
  x: .space 4
  y: .space 4
  v: .space 4
  i: .space 4
  j: .space 4
  sum: .space 4
  matrix2 :.space 1600
  
  formatScanf : .asciz "%d"
  formatPrintf : .asciz "%d "
  endl : .asciz "\n"
.text
.global main

main:
  push $m 
  push $formatScanf
  call scanf
  add $4,%esp
   
  push $n
  push $formatScanf
  call scanf
  add $4,%esp

   
    movl m, %eax
    addl $2, %eax
    movl %eax, %ebx # ebx = m+2

    movl n, %eax
    addl $2, %eax
    imull %ebx, %eax
    movl %eax, %ebx
   
    movl $0, %ecx
    real_bordare:
        cmpl %ebx, %ecx
        je next1 
        movl $0, matrix(,%ecx,4)
        addl $1, %ecx 
        jmp real_bordare

    next1:
   
   push $p
   push $formatScanf
   call scanf
   add $8,%esp

et_inceput: 
   
   mov $matrix,%edi
   mov $0,%ecx
  et_for_cel:
     cmp %ecx,p
     je citire_k
      pushl %ecx

      
      pushl $x
      push $formatScanf
      call scanf
      add $8,%esp      
       
       
       pushl $y
       push $formatScanf
       call scanf
       pop %ebx
       popl %ebx
       popl %ecx
       
        movl x, %eax
        addl $2, %eax
        movl n, %ebx
        addl $2, %ebx
        imull %ebx, %eax
        movl y, %ebx
        addl $1, %ebx
        addl %ebx, %eax
      
      lea matrix,%edi
      movl $1,(%edi,%eax,4)
     
      inc %ecx
      jmp et_for_cel
      
citire_k:
      jmp et_afisarema
      pushl %ecx
      pushl $k
      push $formatScanf
      call scanf
      pop %ebx
      popl %ebx
      popl %ebx
      
et_calcul:

      movl $0,v
      movl k,%edx
    cmp v,%edx #while k
    je et_afisarema
     
     push %edx
     
      
      movl $1,lineIndex
       
       for_lcal:  
        movl m,%ebx
        cmp lineIndex,%ebx #for i,m
        je et_mutare
        
        // push %ebx        
        movl $0,sum
       
        movl $1,colIndex
        for_cal:
         
         movl n,%ecx
         cmp colIndex,%ecx #for j,n
         je for_lcal_cont
         
         push %ecx
         
         
           
     	   # v[i+1][j]
           movl lineIndex,%eax
           incl %eax
           mull n
           addl colIndex,%eax
           lea matrix,%edi
           movl (%edi,%eax,4),%ebx
           addl %ebx,sum
           
           #v[i-1][j] 
           movl lineIndex,%eax
           decl %eax
           mull n
           addl colIndex,%eax
           lea matrix,%edi
           movl (%edi,%eax,4),%ebx
           addl %ebx,sum
           
           
           #v[i+1][j+1]
           movl lineIndex,%eax
           incl %eax
           mull n
           addl colIndex,%eax
           incl %eax
           lea matrix,%edi 
           movl (%edi,%eax,4),%ebx
           add %ebx,sum
            
           
           #v[i+1][j-1]
           movl lineIndex,%eax
           incl %eax
           mull n
           addl colIndex,%eax
           decl %eax
           lea matrix,%edi
           movl (%edi,%eax,4),%ebx
           add %ebx,sum
           
           
           #v[i-1][j-1]
           movl lineIndex,%eax
           decl %eax
           mull n
           addl colIndex,%eax
           decl %eax
          lea matrix,%edi 
           movl (%edi,%eax,4),%ebx
          add %ebx,sum
           
           
           #v[i-1][j+1]
           movl lineIndex,%eax
           decl %eax
           mull n
           addl colIndex,%eax
           incl %eax
           movl (%edi,%eax,4),%ebx
           add %ebx,sum
           
           
           #v[i][j+1]
           movl lineIndex,%eax
           mull n
           addl colIndex,%eax
           incl %eax
           lea matrix,%edi
           
            #v[i][j-1]
           movl lineIndex,%eax
           mull n
           addl colIndex,%eax 
           decl %eax
           lea matrix,%edi  
           movl (%edi,%eax,4),%ebx 
           add %ebx,sum
           
         vecini:
         movl (%edi,%eax,4),%ebx
         mov $3,%edx
         cmp $1,%ebx #verific daca elem e 1
         je etverific 
         
         cmp sum,%edx #dc e 0 si are 3 vecini il creez dc a ajuns aici inseamna ca nu e 1
         je et_creere
         
         jmp et_increase
     et_creere:
      movl lineIndex,%eax
      mull n
      addl colIndex,%eax
      lea matrix2,%edi
      movl $1,(%edi,%eax,4)
      jmp et_increase
      
   etverific: #dc elem e 1 verific dc are >3 vecini si atunci moare 
      movl $3,%edx
      cmp sum,%edx
      jg et_moare
       
       movl $2,%edx #verific dc are<2 vecini si atunci iar moare
       cmp sum,%edx
       jl et_moare
       jmp et_creere
       
      et_moare: 
       movl lineIndex,%eax
       mull n
       addl colIndex,%eax
       lea matrix2,%edi
       movl $0,(%edi,%eax,4) 
       
       
       et_increase:     
          incl colIndex
          jmp for_cal
        
          
       for_lcal_cont:
          incl lineIndex
          jmp for_lcal
        
     et_mutare:     
       lea matrix2,%esi
       movl $1,line
       et_f:
        movl n,%ebx
        cmp line,%ebx
        je decrease_k
         
         movl $1,col
         movl m,%ecx
         et_c:
         cmp col,%ecx
         je et_f_cont
          
           
           movl line,%eax
           mull n
           addl col,%eax
           movl (%esi,%eax,4),%ebx
           lea matrix,%edi
           mov %ebx,(%edi,%eax,4)
           
           incl col
           jmp et_c
           
       et_f_cont:
           incl line
           popl %ebx
           popl %edx
           popl %ecx
           jmp et_f
        
       
       decrease_k:
       push %edx
       movl v,%edx 
       incl %edx 
       movl %edx,v 
       movl k,%edx #k
       popl %edx
      
       decl %edx #uitasei sa scazi k-ul.
       jmp et_calcul


et_afisarema:
//print n,m and endl

pushl n
pushl $formatPrintf
call printf
add $4,%esp

pushl m
pushl $formatPrintf
call printf
add $4,%esp

pushl $endl
call printf
add $4,%esp




   movl $1,lineIndex
for_lines:
    mov lineIndex,%ecx
    movl m,%ebx
    // inc %ebx
    add $1,%ebx
    cmpl %ebx, %ecx

    jge et_exit
    movl $1,coloanaIndex
      for_col:
        mov coloanaIndex,%ecx
        movl n,%ebx
        // inc %ebx
        addl $1,%ebx
        cmpl %ebx, %ecx
        jge afisez
       
        movl lineIndex,%eax
        movl n, %ebx
        addl $2,%ebx
        imull %ebx, %eax
        addl coloanaIndex,%ebx
        addl %ebx,%eax
        

        lea matrix,%edi
        movl (%edi,%eax,4),%ebx
        
        pusha
        push %ebx
        push $formatPrintf
        call printf
        add $8,%esp
        popa
        
        
        incl coloanaIndex
        jmp for_col 

afisez:  
  push $endl
  call printf
  add $4,%esp
  
  incl lineIndex
  jmp for_lines
      
et_exit:
    mov $1,%eax
    mov $0,%ebx
    int $ 0x80