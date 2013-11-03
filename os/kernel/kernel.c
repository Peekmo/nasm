#include "../drivers/screen.h"

void print_name();

int main()
{
    clear_screen();
    print_name();

    // Loading Kernel OK
    printloc("Loading kernel...", 8, 2, RED);
    printloc("[OK]", 8, 30, GREEN);
    printloc("Building the world...", 9, 2, RED);
    printloc("[OK]", 9, 30, GREEN);

    printloc("You can now doing nothing :)", 11, 2, CYAN);
    // printloc("[OK]", 0, 40, GREEN);
    // print("\nChargement de rien du tout...");
    // printloc("[OK]", 1, 40, GREEN);
    // printloc("Bonjour Angele :D", 4, 40-str_len("Bonjour Harold :D"), YELLOW);
}

/**
 * Print the OS name centered to the top (juste for fun <3)
 */
print_name()
{
    char* border_top;
    int i;

    for(i=0; i < 21; i++) {
        border_top[i] = (char)220;
    }

    int center = MAX_COLS/2 - str_len(border_top)/2;
    printloc(border_top, 1, center, YELLOW);


    char* empty_border;
    empty_border[0] = (char)221;
    empty_border[20] = (char)222;
    for(i=1; i<20; i++) {
        empty_border[i] = ' ';
    }

    printloc(empty_border, 2, center, YELLOW);
    printloc(empty_border, 3, center, YELLOW);
    printloc("MoonOS", 3, MAX_COLS/2 - str_len("MoonOS", YELLOW)/2);    
    printloc(empty_border, 4, center, YELLOW);
   
    char* border_bottom;
    for(i=0; i < 21; i++) {
        border_bottom[i] = (char)223;
    }

    printloc(border_bottom, 5, center, YELLOW);
    printloc("\n\n", 5,MAX_COLS-1,YELLOW); // return to the line
}