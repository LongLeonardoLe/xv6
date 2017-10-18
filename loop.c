#include "types.h"
#include "user.h"
#define TPS 100

int
main()
{
    int pid, max = 7;
    unsigned long x = 0;

    for(int i = 0; i < max; i++) {
        sleep(5*TPS);
        pid = fork();
        if(pid < 0) {
            printf(2, "fork failed!\n");
            exit();
        }

        if(pid == 0) {
            sleep(getpid()*100);
            do {
                x += 1;
            } while (1);
            printf(1, "Child %d exiting\n", getpid());
            exit();
        }
    }

    pid = fork();
    if(pid == 0) {
        sleep(20);
        do {
            x = x+1;
        } while(1);
    }
    exit();
}

