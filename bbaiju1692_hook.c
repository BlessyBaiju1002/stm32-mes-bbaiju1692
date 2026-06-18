/*
 *  C to assembler menu hook
 * 
 */
#include <stdio.h>
#include <stdint.h>
#include <ctype.h>
#include "common.h"

int bbaiju1692_add_test(int x, int y, uint32_t delay);

void AddTest(int action)
{
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Addition Test\n\n"
       "This command tests new addition function by bbaiju1692\n"
       );
    return;
  }

  uint32_t delay;
  int fetch_status;
  fetch_status = fetch_uint32_arg(&delay);
  if(fetch_status) {
    // Use a default delay value
    delay = 0xFFFFFF;
  }

  printf("bbaiju1692_add_test returned: %d\n", bbaiju1692_add_test(99, 87, delay) );
}

ADD_CMD("bbaiju1692_add", AddTest,"Test the new add function")

int bbaiju1692_string_test(char *p);

void bbaiju1692_StringTest(int action)
{
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("String Test\n\n"
	   "This command tests new string function by bbaiju1692\n"
	   );
    return;
  }
  int fetch_status;
  char *destptr;
  fetch_status = fetch_string_arg(&destptr);
  if (fetch_status) {
    // Default logic goes here
  }
  printf("string_test returned: %d\n", bbaiju1692_string_test(destptr) );
}

ADD_CMD("bbaiju1692_string", bbaiju1692_StringTest,"Test the new string function")

int bbaiju1692_a2(int num, int wait);

// Assignment 2 C Hook Function
//
void _bbaiju1692_Assignment2(int action)
{
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 2\n\n"
	   "This command triggers assignment 2 by bbaiju1692\n"
	   );
    return;
  }
  uint32_t num_input;
  uint32_t wait_input;
  int fetch_status;

  fetch_status = fetch_uint32_arg(&num_input);
  if(fetch_status) {
  	// Use a default value
  	num_input = 1;
  }

  fetch_status = fetch_uint32_arg(&wait_input);
  if(fetch_status) {
  	// Use a default value
  	wait_input = 0xFFFFEF;
  }

  printf("bbaiju1692_a2 returned: %d\n", bbaiju1692_a2 (num_input, wait_input) );
}
ADD_CMD("bbaiju1692_a2", _bbaiju1692_Assignment2, "Assignment 2")