#include "types.h"
#include "user.h"

int
main(int argc, char* argv[])
{
    char *uidIn = argv[1];
    char *path = argv[2];
    int uid = atoi(uidIn);
    if(uidIn[0] == '-') {
        printf(2, "Invalid UID\n");
        exit();
    }
    if(chown(path, uid) < 0)
        printf(2, "Error: exec chown failure\n");
    exit();
}
