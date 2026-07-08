/*
 *  C to assembler menu hook
 *
 *  Modified by bbaiju1692
 * 
 */

#include <stdio.h>
#include <stdint.h>
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
