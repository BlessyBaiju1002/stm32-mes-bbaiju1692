/*
 *  C to assembler menu hook
 *
 *  Modified by bbaiju1692
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include "stm32f3_discovery_gyroscope.h"
#include <ctype.h>

#include "common.h"

int bbaiju1692_lab6(int x, int y);

void Lab6_bbaiju1692(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 6\n\n"
	   "This command tests new lab 6 function by bbaiju1692\n"
	   );

    return;
  }
  printf("bbaiju1692_lab6 returned: %d\n", bbaiju1692_lab6(99, 87) );
}

ADD_CMD("bbaiju1692_lab6", Lab6_bbaiju1692,"Test the new lab 6 function")

int bbaiju1692_a3(char *pattern_ptr);

void A3_bbaiju1692(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 3 Test\n\n"
	   "This is the A3 function by bbaiju1692\n"
	   );

    return;
  }

  int fetch_status;
  char *pattern;

  fetch_status = fetch_string_arg(&pattern);

  if (fetch_status) {
    // Default logic goes here
    pattern = "Test Pattern";
  }

  printf("bbaiju1692_a3 returned: %d\n", bbaiju1692_a3(pattern) );
}

ADD_CMD("bbaiju1692_a3", A3_bbaiju1692,"Run A3 for bbaiju1692")


/* Declaration for lab 7 assembly function */
int bbaiju1692_lab7(int delay);

/*
 * Lab7_bbaiju1692 - Gyroscope reading function
 * Usage: bbaiju1692_lab7 <count> <delay> <axis>
 * count = number of readings
 * delay = time between readings
 * axis  = 0:all 1:X only 2:Y only 3:Z only
 */
void Lab7_bbaiju1692(int action)
{
    if(action==CMD_SHORT_HELP) return;
    if(action==CMD_LONG_HELP) {
        printf("Lab 7 - Gyroscope Test by bbaiju1692\n\n"
               "Usage: bbaiju1692_lab7 <count> <delay> <axis>\n"
               "  count = how many readings\n"
               "  delay = time between readings\n"
               "  axis  = 0:all  1:X  2:Y  3:Z\n"
               );
        return;
    }

    int count, delay, axis;
    float xyz[3] = {0};

    /* Get count from user */
    if(fetch_uint32_arg((uint32_t *)&count)) {
        printf("Please provide count value\n");
        return;
    }

    /* Get delay from user */
    if(fetch_uint32_arg((uint32_t *)&delay)) {
        printf("Please provide delay value\n");
        return;
    }

    /* Get axis from user */
    if(fetch_uint32_arg((uint32_t *)&axis)) {
        printf("Please provide axis (0=all, 1=X, 2=Y, 3=Z)\n");
        return;
    }

    /* Loop count times reading gyroscope */
    int i;
    for(i = 0; i < count; i++) {

        /* Read gyroscope X Y Z values */
        BSP_GYRO_GetXYZ(xyz);

        /* Print based on axis selection */
        if(axis == 0) {
            printf("X: %f  Y: %f  Z: %f\n",
                xyz[0]/256, xyz[1]/256, xyz[2]/256);
        } else if(axis == 1) {
            printf("X: %f\n", xyz[0]/256);
        } else if(axis == 2) {
            printf("Y: %f\n", xyz[1]/256);
        } else if(axis == 3) {
            printf("Z: %f\n", xyz[2]/256);
        }

        /* Call assembly delay function */
        bbaiju1692_lab7(delay);
    }

    printf("bbaiju1692_lab7 done!\n");
}

ADD_CMD("bbaiju1692_lab7", Lab7_bbaiju1692, "Test the new lab 7 gyroscope function")