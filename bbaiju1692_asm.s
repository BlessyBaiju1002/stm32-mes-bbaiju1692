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
@ Input:   r0 = delay value from user
@ Returns: r0 = total number of LED toggles performed
@
bbaiju1692_lab6:
    push {r4, r5, r6, lr}  @ Save registers and return address

    mov r4, r0             @ Save delay value safely in r4
    mov r5, #7             @ Set loop index to 7 (start from LED 7)
    mov r6, #0             @ Set toggle counter to 0

bbaiju1692_loop:
    @ Check if loop index is less than zero
    cmp r5, #0             @ Compare loop index with 0
    bge bbaiju1692_skip    @ If >= 0, skip reset
    mov r5, #7             @ Else reset loop index back to 7

bbaiju1692_skip:
    @ Toggle the LED at current loop index
    mov r0, r5             @ Put loop index into r0 (parameter for BSP_LED_Toggle)
    bl BSP_LED_Toggle      @ Toggle that LED

    add r6, r6, #1         @ Increment toggle counter
    sub r5, r5, #1         @ Decrement loop index

    @ Delay for the amount of time given by user
    mov r0, r4             @ Put delay value back into r0
    bl busy_delay          @ Call delay function

    @ Check if button is pressed
    mov r0, #0             @ 0 = user button
    bl BSP_PB_GetState     @ Call button read function
                           @ r0 = 0 means NOT pressed, non-zero means PRESSED

    cmp r0, #0             @ Is button pressed?
    beq bbaiju1692_loop    @ If NOT pressed (r0==0), go back to loop
                           @ If pressed, fall through and exit

bbaiju1692_done:
    mov r0, r6             @ Put toggle counter into r0 as return value
    pop {r4, r5, r6, lr}   @ Restore registers
    bx lr                  @ Return to C

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
