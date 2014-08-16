/* Use pre-indexed address to move characters */

    .global _start
_start:
    ldr r1, =string @ 1st string's location
    ldr r3, =numbers @ 2nd string location
    mov r2, #25 @ chars in alphabet
_loop:
    ldrb r0, [r1, r2] @ get byte r1 + r2
    strb r0, [r3, r2] @ save byte r3 + r2
    subs r2, r2, #1 @ decrement, flag set
    bpl _loop @ if positive, loop
_write:
    mov r0, #1       @ STDOUT
    ldr r1, =numbers @ Register of the value to write
    mov r2, #27      @ Length of string to write
    mov r7, #4       @ Write Sys call
    swi 0            @ Interrupt
_exit:
    mov r7, #1       @ Exit Sys call
    swi 0            @ Interrupt

    .data
string:
    .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
numbers:
    .ascii "01234567891011121314151617\n"
