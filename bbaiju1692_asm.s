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

@ Function Declaration: void bbaiju1692_a4_tick(void)
@
@ Input:   None
@ Returns: Nothing
@
@ Called automatically every N milliseconds by SysTick interrupt
@ Checks if A4 is running, skips ticks if needed,
@ then toggles current LED and moves to next one
@
bbaiju1692_a4_tick:
    push {r4, r5, r6, lr}      @ Save registers we will use

    @ ---- STEP 1: Check if A4 is running ----
    ldr r1, =a4_is_running     @ Load address of running flag
    ldr r0, [r1]               @ Read running state from memory
    cmp r0, #0                 @ Is running state zero or less?
    ble a4_tick_done           @ Yes → not running, exit now

    @ ---- STEP 2: Handle skip counter ----
    @ We don't blink every tick - we skip some ticks first
    ldr r1, =a4_skip_count     @ Load address of skip counter
    ldr r0, [r1]               @ Read current skip count
    add r0, r0, #1             @ Add 1 to skip count
    str r0, [r1]               @ Save updated skip count back

    @ Compare skip count with our target num_skip value
    ldr r2, =a4_num_skip       @ Load address of num_skip
    ldr r2, [r2]               @ Read num_skip value
    cmp r0, r2                 @ Have we skipped enough ticks?
    blt a4_tick_done           @ No → not yet, exit without blinking

    @ ---- STEP 3: Reset skip counter ----
    @ We have waited long enough - reset counter and blink!
    ldr r1, =a4_skip_count     @ Load address of skip counter
    mov r0, #0                 @ Value to reset counter to
    str r0, [r1]               @ Reset skip counter to zero

    @ ---- STEP 4: Toggle current LED ----
    ldr r4, =a4_current_led    @ Load address of current LED variable
    ldr r0, [r4]               @ Read current LED index (0-7)
    ldr r5, =BSP_LED_Toggle    @ Load address of toggle function=
    blx r5                     @ Call toggle with LED index in r0

    @ ---- STEP 5: Move to next LED ----
    ldr r0, [r4]               @ Read current LED index again
    ldr r6, =a4_direction      @ Load address of direction variable
    ldr r6, [r6]               @ Read direction value (+1 or -1)
    add r0, r0, r6             @ Add direction to get next LED index

    @ ---- STEP 6: Wrap LED index if out of range ----
    cmp r0, #8                 @ Is new index 8 or more?
    bge a4_tick_wrap_low       @ Yes → went past LED 7, wrap to 0

    cmp r0, #0                 @ Is new index less than 0?
    blt a4_tick_wrap_high      @ Yes → went below LED 0, wrap to 7

    b a4_tick_save             @ Index in range → go save it

a4_tick_wrap_low:
    mov r0, #0                 @ Past end → wrap back to LED 0
    b a4_tick_save             @ Go save it

a4_tick_wrap_high:
    mov r0, #7                 @ Below start → wrap to LED 7

a4_tick_save:
    str r0, [r4]               @ Save new LED index to memory

a4_tick_done:
    pop {r4, r5, r6, lr}      @ Restore all saved registers
    bx lr                      @ Return to caller
    .size bbaiju1692_a4_tick, .-bbaiju1692_a4_tick


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

a5_running:     .word 0    @ A5 running flag (1=running, 0=stopped)
a5_btn_pressed: .word 0    @ Button pressed flag (1=pressed, 0=not)


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

    @@ Function Header Block - Assignment 5 Tick
    .global bbaiju1692_a5_tick
    .type   bbaiju1692_a5_tick, %function

@ Function Declaration: void bbaiju1692_a5_tick(void)
@
@ Input:   None
@ Returns: Nothing
@
@ Called automatically by SysTick interrupt
@ Handles A5 LED blinking and watchdog refresh
@
bbaiju1692_a5_tick:
    push {r4, r5, lr}          @ Save registers

    @ Check if A5 is running
    ldr r1, =a5_running        @ Load address of running flag
    ldr r0, [r1]               @ Read running state
    cmp r0, #0                 @ Is it zero or less?
    ble a5_skip                @ Not running → exit

        @ DO NOT PUT LOGIC FOR A5 ABOVE THIS LINE --------

        @ Toggle Upper Left, Upper Right, Lower Left, Lower Right LEDs
        @ Using direct GPIO memory access (Lab 9 style!)
        @ GPIO Port E Output Data Register = 0x48001014
        @ UL=LED3=bit9=0x0200, UR=LED4=bit8=0x0100
        @ LL=LED6=bit15=0x8000, LR=LED8=bit14=0x4000
        @ All 4 corners = 0x0200|0x0100|0x8000|0x4000 = 0xC300

        ldr r4, =0x48001014    @ Load GPIO ODR address
        ldrh r0, [r4]          @ Read current GPIO state
        eor r0, r0, #0xC300    @ Toggle all 4 corner LEDs at once
        strh r0, [r4]          @ Write back to GPIO register

        @ Check if button was pressed
        ldr r1, =a5_btn_pressed @ Load address of button flag
        ldr r0, [r1]            @ Read button flag
        cmp r0, #0              @ Was button pressed?
        bne a5_skip             @ Yes → skip watchdog refresh (board will reboot!)

        @ Refresh watchdog (only if button NOT pressed)
        ldr r4, =mes_IWDGRefresh @ Load refresh function address
        blx r4                   @ Refresh the watchdog

        @ DO NOT PUT LOGIC FOR A5 BELOW THIS LINE --------

    a5_skip:
    pop {r4, r5, lr}           @ Restore registers
    bx lr                      @ Return to caller
    .size bbaiju1692_a5_tick, .-bbaiju1692_a5_tick


@@ Function Header Block - Assignment 5 Button
    .global bbaiju1692_a5_btn
    .type   bbaiju1692_a5_btn, %function

@ Function Declaration: void bbaiju1692_a5_btn(void)
@
@ Input:   None
@ Returns: Nothing
@
@ Called when blue button is pressed
@ Sets a5_btn_pressed flag to 1
@
bbaiju1692_a5_btn:
    push {lr}                  @ Save return address

    @ Set button pressed flag to 1
    ldr r1, =a5_btn_pressed    @ Load address of button flag
    mov r0, #1                 @ Value to set
    str r0, [r1]               @ Store flag = 1

    pop {lr}                   @ Restore return address
    bx lr                      @ Return to caller
    .size bbaiju1692_a5_btn, .-bbaiju1692_a5_btn


@@ Function Header Block - Assignment 5 Main Function
    .global bbaiju1692_a5
    .type   bbaiju1692_a5, %function

@ Function Declaration: int bbaiju1692_a5(int status, int num_skip, int direction)
@
@ Input:
@   r0 = status    (1=start, 0=stop)
@   r1 = num_skip  (not used in A5 but kept for compatibility)
@   r2 = direction (not used in A5 but kept for compatibility)
@
@ Returns: r0 = 0
@
@ Initializes A5 LED blinking with watchdog
@
bbaiju1692_a5:
    push {r4, r5, r6, lr}     @ Save registers

    mov r4, r0                 @ r4 = status

    @ Save running state
    ldr r0, =a5_running        @ Load address of running flag
    str r4, [r0]               @ Store running state

    @ Reset button pressed flag
    ldr r0, =a5_btn_pressed    @ Load address of button flag
    mov r1, #0                 @ Reset value
    str r1, [r0]               @ Clear button flag

    @ Turn off all 8 LEDs first
    mov r4, #0                 @ Start from LED 0

bbaiju1692_a5_off_loop:
    cmp r4, #8                 @ Done all 8 LEDs?
    bge bbaiju1692_a5_wdog     @ Yes → setup watchdog

    mov r0, r4                 @ LED index into r0
    ldr r5, =BSP_LED_Off       @ Load BSP_LED_Off address
    blx r5                     @ Turn off this LED

    add r4, r4, #1             @ Next LED
    b bbaiju1692_a5_off_loop   @ Loop back

bbaiju1692_a5_wdog:
    @ Initialize watchdog with reload 8000
    mov r0, #8000              @ Reload value
    ldr r4, =mes_InitIWDG      @ Load init function address
    blx r4                     @ Initialize watchdog

    @ Start watchdog
    ldr r4, =mes_IWDGStart     @ Load start function address
    blx r4                     @ Start watchdog

bbaiju1692_a5_done:
    mov r0, #0                 @ Return 0
    pop {r4, r5, r6, lr}      @ Restore registers
    bx lr                      @ Return to C
    .size bbaiju1692_a5, .-bbaiju1692_a5

@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
