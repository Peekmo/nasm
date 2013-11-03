#include "../drivers/screen.h"

int main()
{
    clear_screen();
    char *boot = "< Le systeme a bien demarre >";
    char *author = "Par Axel Anceau";
    int center = 40 - str_len(boot)/2;
    printloc(boot, 11, center, 0x74);
    center = 40 - str_len(author)/2;
    printloc(author, 12, center, 0x74);
}
