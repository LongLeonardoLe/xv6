#include "types.h"
#include "user.h"
#include "uproc.h"
#define MAX 16

int
main(void) {
    struct uproc* table = (struct uproc*)malloc(MAX * sizeof(struct uproc));

    int check = getprocs(MAX, table);

    if (!table) {
        printf(2, "Error: malloc failed\n");
        exit();
    }

    if (check <= 0) {
        printf(2, "No processes found\n");
        exit();
    }
    else {
        printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
        for (int i = 0; i < check; i++) {
           printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
           printf(1, "%d.%d\t", table[i].elapsed_ticks/100, table[i].elapsed_ticks%100);
           printf(1, "%d.%d\t", table[i].CPU_total_ticks/100, table[i].CPU_total_ticks%100);
           printf(1, "%s\t%d\n", table[i].state, table[i].size);
        }
    }
    exit();
}
