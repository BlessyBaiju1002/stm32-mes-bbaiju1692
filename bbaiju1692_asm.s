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
    push {lr}           @ Save LR because we will call another function
    add r0, r0, r1      @ Add x + y, result is in r0
    push {r0}           @ Save the addition result before calling delay
    ldr r0, =0xFFFFFF   @ Load the delay value 0xFFFFFF into r0
    bl busy_delay       @ Call busy_delay with that value
    pop {r0}            @ Restore the addition result into r0
    pop {pc}            @ Restore and return
    .size   bbaiju1692_add_test, .- bbaiju1692_add_test

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