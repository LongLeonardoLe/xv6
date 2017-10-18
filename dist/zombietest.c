#include "types.h"
#include "user.h"
#define TPS 100

int
main(int argc, char *argv[])
{
    int i, pid;

    for(i = 0; i < 5; i++) {
        pid = fork();
        if (pid == 0) {
            pid = getpid();
            sleep(pid);
            int newval = pid;
            printf(1, "Process %d: setting UID and GID to %d\n", pid, newval);
            setuid(newval);
            setgid(newval);
            sleep(TPS);
            exit();
        }
    }
    sleep(30*TPS);
    while(wait() != -1)
        wait();
    exit();
}
