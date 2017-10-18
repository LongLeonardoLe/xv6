#include "types.h"
#include "user.h"

#define TPS 100


void
testInvalid(void)
{
    int pid, value, rc;

    pid = -1;
    value = 1;
    printf(1, "%d: setting priority to %d\n", pid, value);
    rc = setpriority(pid, value);
    if (rc < 0)
        printf(2, "Failed setting priority!\n");
    else printf(1, "Change priority of %d to %d\n", pid, value);
    sleep(5 * TPS);

    pid = 1;
    value = -1;
    printf(1, "%d: setting priority to %d\n", pid, value);
    rc = setpriority(pid, value);
    if (rc < 0)
        printf(2, "Failed setting priority!\n");
    else printf(1, "Change priority of %d to %d\n", pid, value);
    sleep(5 * TPS);

    pid = 1;
    value = 1;
    printf(1, "%d: setting priority to %d\n", pid, value);
    rc = setpriority(pid, value);
    if (rc < 0)
        printf(2, "Failed setting priority!\n");
    else printf(1, "Change priority of %d to %d\n", pid, value);
    sleep(5 * TPS);

    pid = 45;
    value = 1;
    printf(1, "%d: setting priority to %d\n", pid, value);
    rc = setpriority(pid, value);
    if (rc < 0)
        printf(2, "Failed setting priority!\n");
    else printf(1, "Change priority of %d to %d\n", pid, value);
    sleep(5 * TPS);
}

int
main(void)
{
    testInvalid();
    exit();
}
