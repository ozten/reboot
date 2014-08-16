/* Post-indexed address to concat strings */
    .global _start

_start:
    ldr r2, =string1 @ load locations
    ldr r3, =string2

_loop:
    ldrb r0, [r3], #1 @ Get byte & +1
    cmp r0, #0        @ End of string?
    bne _loop         @ No, continue
    sub r3, r3, #1    @ Yes, decrement back 1

_copyloop:
    ldrb r0, [r2], #1 @ Get byte string1
    strb r0, [r3], #1 @ Add to string2
    cmp r0, #0        @ is it 0?
    bne _copyloop     @ if not get the next char

_write:
    mov r0, #1        @ Yes, print new
    ldr r1, =string2
    mov r2, #24
    mov r7, #4
    swi 0

_exit:
    mov r7, #1
    swi 0

    .data
string1:
    .asciz "ABCDEFGHIJKL"

string2:
    .asciz "012345678910"

padding:
    .ascii " "
