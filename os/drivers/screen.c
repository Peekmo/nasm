/*
 * Screen management
 * 2013/11/03
 * Axel Anceau
 */
#include "screen.h"

/**
 * Print a character to the screen
 * @param character character to print
 * @param row       Row of the cursor
 * @param col       Column of the cursor
 * @param color     Color to apply (screen.h)
 */
void printc(char character, int row, int col, char color)
{
    // Get video_memory address
    unsigned char* video_memory = (unsigned char*) VIDEO_ADDRESS;

    // Black on whit by default
    if (!color) {
        color = WHITE;
    }

    // Get offset to print char
    int offset = 0;
    if (row >= 0 && col >= 0) {
        offset = get_offset(row, col);
    } else {
        offset = get_cursor();
    }

    video_memory[offset]   = character;
    video_memory[offset+1] = color;

    // Next char
    offset += 2;
    set_cursor(offset);
}

/**
 * Print a message to the given location
 * @param message Message to print
 * @param row     Row of the message
 * @param col     Column of the message
 * @param color   Color for the message
 */
void printloc(char* message, int row, int col, char color)
{
    if (col >= 0 && row >= 0) {
        set_cursor(get_offset(row, col));
    }

    int i=0;
    while (message[i] != 0) {
        printc(message[i++], -1, -1, color);
    }
}

/**
 * Print a message to the screen
 * @param message Message to print
 */
void print (char* message)
{
    printloc(message, -1, -1, 0x74);
}

/**
 * Get the offset of the given row/col
 * @param  row Row of the char
 * @param  col Col of the char
 * @return     Offset
 */
int get_offset(int row, int col)
{
    return (col + row * MAX_COLS) * 2;
}

/**
 * Clear the screen
 */
void clear_screen()
{
    int row = 0;
    int col = 0;

    for (row=0; row < MAX_ROWS; row++) {
        for (col=0; col < MAX_COLS; col++) {
            printc(' ', row, col, (char)0x70);
        }
    }

    // Initialize the cursor
    set_cursor(0);
}

/**
 * Get cursor position
 * @return Cursor offset
 */
int get_cursor()
{
    // Bit de poid fort
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;

    // Bit de poid faible
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);

    return offset*2;
}

/**
 * Set the cursor position on the screen
 * @param offset Offset of the cursor
 */
void set_cursor(int offset)
{
    offset /= 2;

    // Poid fort
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));

    // Poid faible
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, offset);
}

/**
 * Return size of the string
 * @param  message Messages searched   
 * @return         Length of the char
 */
int str_len(char* message)
{
    int len=0;

    while (message[len] != 0) {
        message[len++];
    }

    return len;
}