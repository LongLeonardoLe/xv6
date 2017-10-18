#include "types.h"
#include "user.h"

int 
main(int argc, char* argv[])
{
    char *modeIn = argv[1];
    char *path = argv[2];
    if(strlen(modeIn) > 4)
        printf(2, "Error: invalid MODE\n");
    for(int i = 0; i < strlen(modeIn); i++) {
        if(modeIn[i] < '0' || modeIn[i] > '7') {
            printf(2, "Error: invalid MODE\n");
            exit();
        }
    }
    int mode = atoo(modeIn);
    if(chmod(path, mode) < 0)
        printf(2, "Error: exec chmod failure\n");
    exit();
}

