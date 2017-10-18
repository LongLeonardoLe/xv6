#include "types.h"
#include "user.h"

int
main(int argc, char* argv[])
{
    char *gidIn = argv[1];
    char *path = argv[2];
    int gid = atoi(gidIn);
    if(gidIn[0] == '-') {
        printf(2, "Invalid GID\n");
        exit();
    }
    if(chgrp(path, gid) < 0)
        printf(2, "Error: exec chgrp failure\n");
    exit();
}
