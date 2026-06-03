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
    add r0, r0, r1
    bx lr
    .size   bbaiju1692_add_test, .- bbaiju1692_add_test
@ Assembly file ended by single .end directive on its own line
.end