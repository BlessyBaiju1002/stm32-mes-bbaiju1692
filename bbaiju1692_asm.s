@ Assembly File - Lab 8 Version
@
@ NOTE THERE IS A DATA SECTION AT THE END OF THIS FILE FOR ASSIGNMENT 4
@ USE THAT DATA SECTION FOR ANY DATA YOU NEED, DO NOT ADD ANOTHER.

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

    .global bbaiju1692_lab8        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   bbaiju1692_lab8, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : void bbaiju1692_lab8(void)
@
@ Input: none
@ Returns: nothing
@ 

@ Here is the actual bbaiju1692_lab8 function
bbaiju1692_lab8:
    push {lr}

    @ For now, this function just toggles, delays, and toggles again.
    mov r0, #3
    bl BSP_LED_Toggle

    ldr r0, =0xFFFFFFF
    bl busy_delay

    mov r0, #3
    bl BSP_LED_Toggle

    pop {lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   bbaiju1692_lab8, .-bbaiju1692_lab8    @@ - symbol size (not strictly required, but makes the debugger happy)




.global bbaiju1692_a4
.type   bbaiju1692_a4, %function

@ Function Declaration : int bbaiju1692_a4(int x)
@
@ Input: Document this
@ Returns: Document this
@ 

@ Here is the actual function
bbaiju1692_a4:

    @ This function only exists to start / initialize your A4
    @ logic working. No actions should be taken in this logic,
    @ aside from storing the parameters your A4 logic needs to run.

    @ Store the value we received indicating the running state
    ldr r1, =a4_is_running
    str r0, [r1]

    bx lr
    .size   bbaiju1692_a4, .-bbaiju1692_a4


.global bbaiju1692_a4_btn
.type   bbaiju1692_a4_btn, %function

@ Function Declaration : void bbaiju1692_a4_btn(void)
@
@ Input: None
@ Returns: Nothing
@ 
@ Reminder - this requires the button has been initialized as an interrupt
@ in main.c using BSP_PB_Init(BUTTON_USER, BUTTON_MODE_EXTI)
@ as well as requires a new function set up void EXTI0_IRQHandler(void)

@ Here is the actual function
bbaiju1692_a4_btn:
    push {lr}

    ldr r1, =a4_button_count        @ Get the address of the counter
    ldr r0, [r1]                    @ Get the actual count
    add r0, r0, #1                  @ Increment the count
    and r0, #7                      @ Keep the count between 0 and 7
    str r0, [r1]                    @ Store the new count

    bl BSP_LED_Toggle               @ Toggle the current LED

    pop {lr}
    bx lr
    .size   bbaiju1692_a4_btn, .-bbaiju1692_a4_btn


.global bbaiju1692_a4_tick
.type   bbaiju1692_a4_tick, %function

@ Function Declaration : void bbaiju1692_a4_tick(void)
@
@ Input: None
@ Returns: Nothing
@ 

@ Here is the actual function
bbaiju1692_a4_tick:
    push {lr}

    @ As a starting point, this function implements the basics needed
    @ to determine if our A4 logic should be running.
    @
    @ You will have to add logic here for A4.

    @ Some useful notes
    @
    @ BSP_LED_On, BSP_LED_Off - same argument as BSP_LED_Toggle, sets
    @ the LED to ON or OFF as you tell it
    @
    @ How to delay: DO NOT use busy_delay - remember, this is an interrupt
    @ handler. If you need a delay, use a counter to count how many times
    @ this function has been called, and use that to skip a desired number
    @ of calls.


    @ ***** Get something
    ldr r1, =a4_is_running
    ldr r0, [r1]

    @ ***** Check something
    cmp r0, #0
    ble a4_skip

        @ This part below is skipped if A4 is NOT running. You will want to
        @ keep all your A4 logic inside here.
        @ DO NOT PUT LOGIC FOR A4 ABOVE THIS LINE -----------------------------

        @ Even within this logic, you should still take a philosopy of check
        @ things, do things, and store things - do not use delays of any sort,
        @ and only use loops if they are bounded (that is, guaranteed to end)

        @ ***** Do something
        mov r0, #0
        bl BSP_LED_Toggle

        @ DO NOT PUT LOGIC FOR A4 BELOW THIS LINE -----------------------------
        @ End of A4 skipped logic. Do not add logic below here.

    a4_skip:

    @ ***** End of our tick function
    pop {lr}
    bx lr
    .size   bbaiju1692_a4_tick, .-bbaiju1692_a4_tick


@ Function Declaration : int busy_delay(int cycles)
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


@ Here is another data section, we will use it for some key interrupt items
@ We will put all necessary data for A4 in this block
.data
a4_is_running: .word 0
a4_button_count: .word 0


@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
