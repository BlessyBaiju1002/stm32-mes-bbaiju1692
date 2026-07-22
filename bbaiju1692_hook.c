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
void bbaiju1692_a4_btn(void);
void bbaiju1692_a4_tick(void);


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
    bbaiju1692_a4_tick();
  }


}

// Button press hook for our button interrupt
// driven programming.
//
// Note that for now, this function toggles LED 6 when the button is pressed.
void bbaiju1692_btn(void)
{
  // For now, just toggle an LED to prove the button press was noticed.
  bbaiju1692_a4_btn();
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

int bbaiju1692_a4(int x);

void A4_bbaiju1692(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 4 Test\n\n"
	   "This command tests new A4 function by bbaiju1692\n"
	   );

    return;
  }

  int fetch_status;
  uint32_t a4_start;

  fetch_status = fetch_uint32_arg(&a4_start);

  if (fetch_status) {
    a4_start = 1;
  }


  printf("bbaiju1692_a4 returned: %d\n", bbaiju1692_a4(a4_start) );
}

ADD_CMD("bbaiju1692_a4", A4_bbaiju1692,"Test the A4 function")


