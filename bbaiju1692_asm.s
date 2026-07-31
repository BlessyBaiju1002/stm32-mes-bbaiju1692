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

@ Function Declaration: int bbaiju1692_a4(int status, int num_skip, int direction)
@
@ Input:
@   r0 = status    (1=start, 0=stop)
@   r1 = num_skip  (ticks between blinks)
@   r2 = direction (+1=forward, -1=backward, 0=no change)
@
@ Returns: r0 = 0
@
@ Here is the actual function
bbaiju1692_a4:
    push {r4, r5, r6, lr}  @ Save registers

    mov r4, r0             @ r4 = status
    mov r5, r1             @ r5 = num_skip
    mov r6, r2             @ r6 = direction

    @ Save status to memory
    ldr r0, =a4_is_running
    str r4, [r0]           @ Store running state

    @ Save num_skip to memory
    ldr r0, =a4_num_skip
    str r5, [r0]           @ Store num_skip

    @ Only change direction if not zero
    cmp r6, #0             @ Is direction 0?
    beq bbaiju1692_a4_skip_dir @ Yes → don't change

    ldr r0, =a4_direction
    str r6, [r0]           @ Store direction

bbaiju1692_a4_skip_dir:
    @ Reset skip counter to 0
    ldr r0, =a4_skip_count
    mov r1, #0
    str r1, [r0]           @ Reset counter

    @ Turn off all 8 LEDs before starting
    mov r4, #0             @ Start from LED 0

bbaiju1692_a4_off_loop:
    cmp r4, #8             @ Done all 8 LEDs?
    bge bbaiju1692_a4_done @ Yes → exit

    mov r0, r4             @ LED index into r0
    ldr r1, =BSP_LED_Off   @ Load BSP_LED_Off address
    blx r1                 @ Turn off this LED

    add r4, r4, #1         @ Next LED
    b bbaiju1692_a4_off_loop @ Loop back

bbaiju1692_a4_done:
    mov r0, #0             @ Return 0
    pop {r4, r5, r6, lr}   @ Restore registers
    bx lr                  @ Return to C
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
    push {r4, r5, r6, lr}  @ Save all registers we will use

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

        @ Check skip counter - have we waited long enough?
        ldr r1, =a4_skip_count  @ Get address of skip counter
        ldr r0, [r1]            @ Get current skip count
        add r0, r0, #1          @ Increment skip count
        str r0, [r1]            @ Save new skip count

        ldr r2, =a4_num_skip    @ Get address of num_skip
        ldr r2, [r2]            @ Get num_skip value
        cmp r0, r2              @ Have we waited enough?
        blt a4_skip             @ No → skip this tick

        @ Reset skip counter back to 0
        mov r0, #0              @ Reset value
        str r0, [r1]            @ Save reset value

                @ Toggle the current LED
        ldr r4, =a4_current_led @ Get address of current LED
        ldr r0, [r4]            @ Get current LED index
        ldr r5, =BSP_LED_Toggle @ Load toggle function address
        blx r5                  @ Toggle current LED

        @ Move to next LED using direction
        ldr r0, [r4]            @ Get current LED index again
        ldr r2, =a4_direction   @ Get direction address
        ldr r2, [r2]            @ Get direction value (+1 or -1)
        add r0, r0, r2          @ Move to next LED

        @ Wrap around if out of range
        cmp r0, #8              @ Greater than 7?
        bge a4_wrap_low         @ Yes → wrap to 0
        cmp r0, #0              @ Less than 0?
        blt a4_wrap_high        @ Yes → wrap to 7
        b a4_save_led           @ In range → save it

a4_wrap_low:
        mov r0, #0              @ Wrap to LED 0
        b a4_save_led

a4_wrap_high:
        mov r0, #7              @ Wrap to LED 7

a4_save_led:
        str r0, [r4]            @ Save new LED index

    

        @ DO NOT PUT LOGIC FOR A4 BELOW THIS LINE -----------------------------
        @ End of A4 skipped logic. Do not add logic below here.

    a4_skip:

    @ ***** End of our tick function
    pop {r4, r5, r6, lr}   @ Restore all registers
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
a4_num_skip:    .word 500  @ ticks to skip between blinks
a4_direction:   .word 1    @ +1=forward, -1=backward
a4_current_led: .word 0    @ current LED index (0-7)
a4_skip_count:  .word 0    @ current skip counter

@@ Function Header Block
    .global bbaiju1692_lab9
    .type   bbaiju1692_lab9, %function

@ Function Declaration : int bbaiju1692_lab9(void)
@
@ Input: None
@ Returns: r0
@
@ Here is the actual bbaiju1692_lab9 function
bbaiju1692_lab9:
    push {lr}

    @ Directly turn on one LED using GPIO register
    ldr r1, =LEDaddress    @ Load address of GPIO register pointer
    ldr r1, [r1]           @ Dereference to get actual GPIO address
    ldrh r0, [r1]          @ Read current GPIO state (half word)
    orr r0, r0, #0x0100
    strh r0, [r1]          @ Write back to GPIO register

    pop {lr}
    bx lr
    .size bbaiju1692_lab9, .-bbaiju1692_lab9

@ Data section - GPIO address
LEDaddress:
    .word 0x48001014

@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
