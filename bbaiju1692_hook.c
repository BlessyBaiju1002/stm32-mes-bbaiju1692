/*
 *  C to assembler menu hook - Lab 8 Version
 *
 *  Modified by bbaiju1692
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "stm32f3_discovery_gyroscope.h"

#include "common.h"

#define N 500

// A4 Interrupt Handlers - these are in bbaiju1692_asm.s
void bbaiju1692_a5_btn(void);
void bbaiju1692_a5_tick(void);


// Timer tick hook for our timer interrupt
// driven programming.
//
// Note that for now, this function toggles LED 0 every N cycles.
void bbaiju1692_tick(void)
{
  // Our tick variable is static so that it keeps its value from one
  // function call to the next.
  //
  // If this was not static, this would not work because ticks would
  // get reinitialized every time the function was called.
  static int32_t ticks;
  
  // Increment our tick count every time the timer interrupt fires.
  // Can you measure approximately how fast the tick is running? Try
  // timing how long it takes for the LED to blink 10 times.
  ticks++;

  // Every time we reach N cycles, reset the tick count to zero
  // and toggle LED 0.
  //
  // This proves to us that our interrupt is working.
  if (ticks > N)
  {
    ticks = 0;
    bbaiju1692_a5_tick();
  }


}

// Button press hook for our button interrupt
// driven programming.
//
// Note that for now, this function toggles LED 6 when the button is pressed.
void bbaiju1692_btn(void)
{
  // For now, just toggle an LED to prove the button press was noticed.
  bbaiju1692_a5_btn();
}

int bbaiju1692_lab8(void);

void Lab8_bbaiju1692(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 8\n\n"
	   "This command tests new lab 8 function by bbaiju1692\n"
	   );

    return;
  }


  printf("bbaiju1692_lab8 returned: %d\n", bbaiju1692_lab8() );
}

ADD_CMD("bbaiju1692_lab8", Lab8_bbaiju1692,"Test the new lab 8 function")

/*
 * bbaiju1692_a4 assembly function declaration
 * Parameters:
 *   status     = 1 to start, 0 or negative to stop
 *   num_skip   = ticks to skip between LED toggles
 *   direction  = +1 forward, -1 backward, 0 no change
 * Returns: 0
 */
int bbaiju1692_a4(int status, int num_skip, int direction);

/*
 * A4_bbaiju1692 - Interrupt driven LED blinking
 * Usage: bbaiju1692_a4 <status> <num_skip> <direction>
 *   status    = 1=start, 0=stop
 *   num_skip  = how many ticks to skip between blinks
 *   direction = 1=forward, -1=backward, 0=no change
 */
void A4_bbaiju1692(int action)
{
    if(action==CMD_SHORT_HELP) return;
    if(action==CMD_LONG_HELP) {
        printf("Assignment 4\n\n"
               "Usage: bbaiju1692_a4 <status> <num_skip> <direction>\n"
               "  status    = 1=start, 0=stop\n"
               "  num_skip  = ticks between blinks\n"
               "  direction = 1=forward, -1=backward, 0=no change\n"
               );
        return;
    }

    int status, num_skip, direction;

    /* Get status from user */
    if(fetch_uint32_arg((uint32_t *)&status)) {
        status = 1;        /* Default: start running */
    }

    /* Get num_skip from user */
    if(fetch_uint32_arg((uint32_t *)&num_skip)) {
        num_skip = 500;    /* Default: skip 500 ticks */
    }

    /* Get direction from user */
    if(fetch_uint32_arg((uint32_t *)&direction)) {
        direction = 1;     /* Default: forward */
    }

    /* Call assembly function - NO logic in C! */
    printf("bbaiju1692_a4 returned: %d\n",
        bbaiju1692_a4(status, num_skip, direction));
}
ADD_CMD("bbaiju1692_a4", A4_bbaiju1692, "Test the A4 function")



/* Declaration for A5 assembly functions */
void bbaiju1692_a5_tick(void);
void bbaiju1692_a5_btn(void);
int bbaiju1692_a5(int status, int num_skip, int direction);

void A5_bbaiju1692(int action)
{
    if(action==CMD_SHORT_HELP) return;
    if(action==CMD_LONG_HELP) {
        printf("Assignment 5\n\n"
               "Usage: bbaiju1692_a5 <status>\n"
               "  status = 1=start, 0=stop\n"
               "  Press blue button to stop watchdog refresh\n"
               "  Board will reboot after watchdog times out\n"
               );
        return;
    }

    int status, num_skip, direction;

    /* Get status from user */
    if(fetch_uint32_arg((uint32_t *)&status)) {
        status = 1;        /* Default: start running */
    }

    /* Get num_skip from user */
    if(fetch_uint32_arg((uint32_t *)&num_skip)) {
        num_skip = 5;      /* Default */
    }

    /* Get direction from user */
    if(fetch_uint32_arg((uint32_t *)&direction)) {
        direction = 1;     /* Default */
    }

    /* Call assembly function */
    printf("bbaiju1692_a5 returned: %d\n",
        bbaiju1692_a5(status, num_skip, direction));
}
ADD_CMD("bbaiju1692_a5", A5_bbaiju1692, "Test the A5 function")



/*
 * Lab9_bbaiju1692 - Low Level GPIO LED control
 * Directly manipulates GPIO register to control LEDs
 * No library functions used!
 */
int bbaiju1692_lab9(void);

void Lab9_bbaiju1692(int action)
{
    if(action==CMD_SHORT_HELP) return;
    if(action==CMD_LONG_HELP) {
        printf("Lab 9\n\n"
               "This command tests new lab 9 function by bbaiju1692\n"
               );
        return;
    }

    printf("bbaiju1692_lab9 returned: %d\n", bbaiju1692_lab9());
}

ADD_CMD("bbaiju1692_lab9", Lab9_bbaiju1692, "Test the new lab 9 function")

void mes_InitIWDG(int reload);
void mes_IWDGStart(void);
void mes_IWDGRefresh(void);

void Lab10_bbaiju1692(int action)
{
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 10\n\n"
       "This command tests new lab 10 function by bbaiju1692\n"
       "Usage: bbaiju1692_lab10 <reload>\n"
       "  reload = watchdog countdown value\n"
       );
    return;
  }

  int reload;

  /* Get reload value from user */
  if(fetch_uint32_arg((uint32_t *)&reload)) {
    reload = 9999;  /* Default reload value */
  }

  printf("Initializing Watchdog with reload: %d\n", reload);
  mes_InitIWDG(reload);
  printf("Starting Watchdog\n");
  mes_IWDGStart();
}
