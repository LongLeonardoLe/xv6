#include "types.h"
#include "user.h"

#define PrioCount 7
#define numChildren 10

void
countForever(int i)
{
    int j, p, rc;
    unsigned long count = 0;

    j = getpid();
    p = i%PrioCount;
    rc = setpriority(j, p);
    if (rc == 0)
        printf(1, "%d: start prio %d\n", j, p);
    else {
        printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
        exit();
    }

    while (1) {
        count++;
        if ((count & (0x1FFFFFFF)) == 0) {
            p = (p+1) & PrioCount;
            rc = setpriority(j, p);
            if (rc == 0)
                printf(1, "%d: start prio %d\n", j, p);
            else {
                printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
                exit();
            }
        }
    }
}

int
main(void)
{ 
    int i, rc;
    for (i = 0; i < numChildren; i++) {
        rc = fork();
        if (!rc) {
            countForever(i);
        }
    }
    
    countForever(1);
    exit();
}
