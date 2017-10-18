#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
    int t1, t2;
    int pid;

    argv++;
    t1 = uptime();
    pid = fork();
    if (pid < 0) {
        printf(2, "Error: fork failed. %s at line %d.\n", __FILE__, __LINE__);
        exit();
    }
    if (pid == 0) {
        exec(argv[0], argv);
        printf(2, "Error: exec failed. %s at line %d.\n", __FILE__, __LINE__);
    }
    else {
        wait();
        t2 = uptime();
        printf(1, "%s ran in %d.%d seconds.\n", argv[0], (t2-t1)/100, (t2-t1)%100);
    }
    //return 0;
    exit();
}

