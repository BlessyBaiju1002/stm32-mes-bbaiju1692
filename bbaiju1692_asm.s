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
@ Function Declaration: int bbaiju1692_a3(int wait, char *pattern, int num)
@
@ Input:
@   r0 = wait    (delay value between each LED toggle)
@   r1 = pattern (pointer to LED pattern string)
@   r2 = num     (number of times to repeat pattern)
@
@ Returns:
@   r0 = total number of BSP_LED_Toggle calls made
@
@ What this function does:
@   Reads pattern string character by character
@   Converts each char to LED number (ASCII - 48)
@   Toggles that LED and delays
@   Checks button after each toggle
@   Repeats num times or until button pressed
@
bbaiju1692_a3:
    push {r4, r5, r6, r7, r8, lr}  @ Save registers

    @ Save parameters safely
    mov r4, r0             @ r4 = wait (delay value)
    mov r5, r1             @ r5 = pattern pointer (start)
    mov r6, r2             @ r6 = num (repeat counter)
    mov r7, #0             @ r7 = toggle counter (starts at 0)

bbaiju1692_a3_repeat:
    @ Check if repeat counter is zero
    cmp r6, #0             @ Have we done all repeats?
    ble bbaiju1692_a3_done @ If yes, exit

    mov r8, r5             @ r8 = current position in pattern
                           @      reset to start for each repeat

bbaiju1692_a3_loop:
    @ Read one character from pattern string
    ldrb r0, [r8]          @ Load byte at current pattern position
    cmp r0, #0             @ Is it end of string (null terminator)?
    beq bbaiju1692_a3_next_repeat  @ Yes → go to next repeat

    @ Convert ASCII character to LED number
    sub r0, r0, #48        @ Subtract 48 to convert ASCII to number
                           @ e.g. '1'(49) - 48 = 1, '2'(50) - 48 = 2

    @ Toggle the LED
    bl BSP_LED_Toggle      @ Toggle LED number in r0

    add r7, r7, #1         @ Increment toggle counter

    @ Delay between toggles
    mov r0, r4             @ Put delay value into r0
    bl busy_delay          @ Call delay function

    @ Check if button is pressed
    mov r0, #0             @ 0 = user button
    bl BSP_PB_GetState     @ Read button state
    cmp r0, #0             @ Is button pressed?
    bne bbaiju1692_a3_done @ Yes → exit immediately

    @ Move to next character in pattern
    add r8, r8, #1         @ Increment pattern pointer
    b bbaiju1692_a3_loop   @ Go back to read next character

bbaiju1692_a3_next_repeat:
    @ Finished one full pattern cycle
    sub r6, r6, #1         @ Decrement repeat counter
    b bbaiju1692_a3_repeat @ Go back to start of repeat

bbaiju1692_a3_done:
    @ Return total toggle count
    mov r0, r7             @ Put toggle counter in r0
    pop {r4, r5, r6, r7, r8, lr}  @ Restore registers
    bx lr                  @ Return to C

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

@@ Function Header Block - Lab 7
    .global bbaiju1692_lab7
    .type   bbaiju1692_lab7, %function

@ Function Declaration: int bbaiju1692_lab7(int delay)
@ Input:   r0 = delay value
@ Returns: r0 = 0
@
@ Here is the actual bbaiju1692_lab7 function
bbaiju1692_lab7:
    push {lr}          @ Save return address

    bl busy_delay      @ Delay (r0 already has delay value)

    mov r0, #0         @ Return 0
    pop {lr}           @ Restore return address
    bx lr              @ Return to C

    .size bbaiju1692_lab7, .-bbaiju1692_lab7
.end
