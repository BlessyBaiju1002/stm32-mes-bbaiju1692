@ bbaiju1692_asm.s Data section - initialized values
.data
.align 3    @ This alignment is critical - to access our "huge" value, it must
            @ be 64 bit aligned
huge:   .octa 0xAABBCCDDDDCCBBFF
big:    .word 0xAAEEBBFF
num:    .byte 0xAB
str2:   .asciz "Guten Tag!"
count:  .word 12345                     @ This is an initialized 32 bit value
@ End of new data section



@ Test code for my own new function called from C
@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 
    .code   16
    .text
    .align  2
    .syntax unified
    .global bbaiju1692_add_test
    .code   16
    .thumb_func
    .type   bbaiju1692_add_test, %function
@ Function Declaration : int bbaiju1692_add_test (int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 
@ Here is the actual bbaiju1692_add_test function
bbaiju1692_add_test:
    bkpt
    @ Load the addresses of each of our items
    ldr r0, =num
    ldr r0, =big
    ldr r0, =huge
    ldr r0, =str2
    ldr r2, =str2			@ Load the address of str2 and store it in r2
    ldrb r0, [r2]			@ Load the value stored at the address str2 as a byte
    ldr r2, =str2			@ Load the address of str2 and store it in r2
    ldr r0, [r2]			@ Load the value stored at the address str2 as a word
    ldr r2, =num			@ Load the address of num and store it in r2
    ldrb r0, [r2]			@ Load the value stored at the address num
    ldr r2, =big			@ Load the address of big
    ldr r0, [r2]			@ Load the value of big
    ldr r2, =huge			@ Load the address of huge
    ldrd r0, r1, [r2]		@ Load the value of huge
    push {lr}           @ Save LR because we will call another function
    add r0, r0, r1      @ Add x + y, result is in r0
    push {r0}           @ Save the addition result
    mov r0, r2          @ Move delay parameter (r2) into r0 for busy_delay
    bl busy_delay       @ Call busy_delay with the delay value
    pop {r0}            @ Restore the addition result
    pop {pc}            @ Restore and return
    .size   bbaiju1692_add_test, .- bbaiju1692_add_test

.global bbaiju1692_string_test
@ Function Declaration : int bbaiju1692_string_test(char *p)
@
@ Input: r0 (i.e. r0 a pointer to a byte array)
@ Returns: r0
@ 
@ Here is the actual function
bbaiju1692_string_test:
StringLoop:
    ldrb r1, [r0]                    @ Dereference the character r0 points to
    cmp r1, #0                       @ Check if that value is zero
    beq OutLabel                     @ If it is, branch out
    add r0, r0, #1                   @ Add one to R0
    b StringLoop                     @ Branch back to string loop
OutLabel:
    bx lr                            @ Return the value of R0
    .size   bbaiju1692_string_test, .-bbaiju1692_string_test
@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 holds number of cycles to delay)
@ Returns: r0
@ 
@ Here is the actual function. DO NOT MODIFY THIS FUNCTION.
busy_delay:
    push {r6}
    mov r6, r0
delay_label:
    subs r6, r6, #1
    bge delay_label
    mov r0, #0                      @ Always return zero (success)
    pop {r6}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr)

@Assembly file ended by single .end directive on its own line

.end