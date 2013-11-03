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
        color = DEFAULT_COLOR;
    }

    // Get offset to print char
    int offset = 0;
    if (row >= 0 && col >= 0) {
        offset = get_offset(row, col);
    } else {
        offset = get_cursor();
    }

    if (character == '\n') {
        int rows = offset / (2*MAX_COLS);
        offset = get_offset(rows, MAX_COLS-1);
    } else {
        video_memory[offset]   = character;
        video_memory[offset+1] = color;
    }

    // Next char
    offset += 2;
    offset = scroll_up(offset);

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
    printloc(message, -1, -1, DEFAULT_COLOR);
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
 * Clear a row
 * @param row Row to clear
 */
void clear_row(int row)
{
    int col;
    for (col=0; col < MAX_COLS; col++) {
        char* emp = (char*)get_offset(row, col) + VIDEO_ADDRESS;
        emp[0] = ' ';
        emp[1] = DEFAULT_COLOR;
    }
}

/**
 * Clear the screen
 */
void clear_screen()
{
    int row = 0;
    int col = 0;

    for (row=0; row < MAX_ROWS; row++) {
        clear_row(row);
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
 * Copy a char* into an other
 * @param src  char* to copy
 * @param dest char* where to past
 * @param size size of the element to copy
 */
void memory_copy(char* src, char* dest, int size)
{
    int i=0;
    for (i=0; i<size; i++) {
        *(dest + i) = *(src + i);
    }
}

/**
 * Scroll the screen to 1 line to the top if last line reached
 * @param  offset offset of the current char
 * @return        new offset
 */
int scroll_up(int offset)
{
    if (offset < get_offset(MAX_ROWS-1, MAX_COLS-1)) {
        return offset;
    }

    int i;
    for (i=8; i<MAX_ROWS; i++) {
        memory_copy((char*)get_offset(i, 0) + VIDEO_ADDRESS,
                    (char*)get_offset(i-1, 0) + VIDEO_ADDRESS,
                    MAX_COLS*2
        );
    }

    // Clear the last line
    for (i=0; i < MAX_COLS*2; i++) {
        clear_row(MAX_ROWS-1);
    }

    offset -= 2*MAX_COLS;

    return offset;
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