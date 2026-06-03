/*
 *  C to assembler menu hook
 * 
 */
#include <stdio.h>
#include <stdint.h>
#include <ctype.h>
#include "common.h"

int bbaiju1692_add_test(int x, int y);

void AddTest(int action)
{
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Addition Test\n\n"
       "This command tests new addition function by bbaiju1692\n"
       );
    return;
  }
  printf("bbaiju1692_add_test returned: %d\n", bbaiju1692_add_test(99, 87) );
}

ADD_CMD("bbaiju1692_add", AddTest,"Test the new add function")