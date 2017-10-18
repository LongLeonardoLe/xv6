#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void) {
    cprintf("UID: %d\n", getuid());
    exit();
}

