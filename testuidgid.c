// This is the testing file for testuidgid
#include "types.h"
#include "user.h"
#define TPS 300

static void
uidTest(uint nval) {
    uint uid = getuid();
    printf(1, "Current UID is %d\n", uid);
    printf(1, "Setting UID to %d\n", nval);
    if (setuid(nval) < 0)
        printf(2, "Error. Invalid UID: %d\n", nval);
    uid = getuid();
    printf(1, "Current UID is %d\n", uid);
    sleep(5 * TPS);
}

static void
gidTest(uint nval) {
    uint gid = getgid();
    printf(1, "Current GID is %d\n", gid);
    printf(1, "Setting GID to %d\n", nval);
    if (setgid(nval) < 0)
        printf(2, "Error. Invalid GID: %d\n", nval);
    gid = getgid();
    printf(1, "Current GID is %d\n", gid);
    sleep(5 * TPS);
}

static void
forkTest(uint nval) {
    uint uid, gid;
    int pid;

    printf(1, "Setting UID to %d and GID to %d before fork(). Value should be inherited\n", nval, nval);

    if (setuid(nval) < 0)
        printf(2, "Error. Invalid UID: %d\n", nval);
    if (setgid(nval) < 0)
        printf(2, "Error. Invalid GID: %d\n", nval);

    printf(1, "Before fork(), UID = %d, GID = %d\n", getuid(), getuid());
    pid = fork();
    if (pid == 0) {
        uid = getuid();
        gid = getgid();
        printf(1, "Child: UID is: %d, GID is: %d\n", uid, gid);
        sleep(5 * TPS);
        exit();
    }
    else
        sleep(10 * TPS);
}

static void
invalidTest(uint nval) {
    printf(1, "Setting UID to %d. This test should FAIL\n", nval);
    if (setuid(nval) < 0)
        printf(1, "SUCCESS! The setuid system call indicated failure\n");
    else
        printf(2, "FAILURE! The setuid system call indicated success\n");

    printf(1, "Setting GID to %d. This test should FAIL\n", nval);
    if (setgid(nval) < 0)
        printf(1, "SUCCESS! The setgid system call indicated failure\n");
    else
        printf(2, "FAILURE! The setgid system call indicated success\n");
}

static int
test(void) {
    uint nval, ppid;

    // UID test
    nval = 100;
    uidTest(nval);

    // GID test
    nval = 200;
    gidTest(nval);

    // PPID test
    ppid = getppid();
    printf(1, "My parent process is %d\n", ppid);

    // fork test
    nval = 11;
    forkTest(nval);

    // test the invalid value
    nval = 32800; // 32767 is the max
    invalidTest(nval);

    printf(1, "Done!\n");
    return 0;
}

int
main() {
    test();
    exit();
}

