@ Test code for my own new function called from C

@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 


    .code   16              @ This directive selects the instruction set being generated. 
                            @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                   @ Tell the assembler that the upcoming section is to be considered
                            @ assembly language instructions - Code section (text -> ROM)

@@ Function Header Block
    .align  2               @ Code alignment - 2^n alignment (n=2)
                            @ This causes the assembler to use 4 byte alignment

    .syntax unified         @ Sets the instruction set to the new unified ARM + THUMB
                            @ instructions. The default is divided (separate instruction sets)

    .global bbaiju1692_lab6        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   bbaiju1692_lab6, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int bbaiju1692_lab6(int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 

@ Here is the actual bbaiju1692_lab6 function
bbaiju1692_lab6:
    push {lr}

    @ These lines just show that the code is working
    ldr r0, =0xFFFFFF
    bl busy_delay

    pop {lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   bbaiju1692_lab6, .-bbaiju1692_lab6    @@ - symbol size (not strictly required, but makes the debugger happy)


.global bbaiju1692_a3
.type   bbaiju1692_a3, %function

@ Function Declaration: int bbaiju1692_a3(char *pattern_ptr)
@
@ Input: r0 (i.e. r0 is a pointer to the first character of the pattern)
@ Returns: r0
@ 

@ Here is the function
bbaiju1692_a3:

    bx lr
    .size   bbaiju1692_a3, .-bbaiju1692_a3

@ Function Declaration: int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 is how many cycles to delay)
@ Returns: r0
@ 

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION
busy_delay:
    push {r6}
    mov r6, r0

    d3lay_loop:
        subs r6, r6, #1
        bge d3lay_loop

        mov r0, #0      @ Return zero (success)

    pop {r6}
    bx lr               @ Return to calling function


@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
