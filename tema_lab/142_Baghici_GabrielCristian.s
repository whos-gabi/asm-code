-1-1
-10
-11
0-1
00
01
1-1
10
11

0 0 0 0 0 0 
0 0 1 1 0 0 
0 1 0 0 0 0 
0 0 0 1 1 0 
0 0 0 0 0 0 

2 2 1 1 1 4 4 3 1 2 1 1
1 0 2 1 1 1 2 0 0 0 1 1 

0 1 0 0 
0 0 0 1
0 0 0 0 

-1 : -1 
-1 : 0 
-1 : 1 
 0 : -1 
 0 : 0 
 0 : 1 
 1 : -1 
 1 : 0 
 1 : 1 

 pusha
                    # Load the current cell value
                    movl element, %edx
                    # Check if the cell is alive (1) or dead (0)
                    cmp $0, %edx
                    je cell_is_dead
                    # Cell is alive: Apply rules for live cells
                    movl vecini, %eax
                    cmp $2, %eax
                    jl kill_cell
                    cmp $3, %eax
                    jg kill_cell
                    # The cell survives
                    jmp next_cell
                popa
                
                cell_is_dead:

                    pusha
                    pushl element
                    pushl $fPrintf
                    call printf
                    add $8, %esp
                    popa
                    # Cell is dead: Apply rules for dead cells
                    cmp $3, vecini
                    je make_alive

                    # The cell remains dead
                    jmp next_cell

                kill_cell:
                    # Set the cell to dead in the next state
                    # ... Insert code to set the cell to 0 in the next state matrix ...
                    //set cell with address %eax from cp_matrix to 0
                    pusha
                    leal cp_matrix(,%eax,4), %edi
                    movl $0, (%edi)
                    popa

                    jmp next_cell

                make_alive:
                    # Set the cell to alive in the next state
                    # ... Insert code to set the cell to 1 in the next state matrix ...
                    pusha
                    leal cp_matrix(,%eax,4), %edi
                    movl $1, (%edi)
                    popa

                next_cell: