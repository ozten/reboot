/* Convert number to binary for printing */
    .global _start
_start:
    mov r6, #19968 @ We will print 256
/*    lsl r6, #10
    add r6, #251
    lsl r6, #10
    add r6, #251
    lsl r6, #4
    add r6, #251*/
    mov r10, #1  @ set up the mask 1 mask to test against our binary number
    mov r9, r10, lsl #31 @ Move mask left 31 characters to far left
    ldr r1, =string @ Point r1

_test_bits:
    tst r6, r9 @tst number with mask
    beq _print0

_print1:
    mov r8, r6 @ preserve number
    mov r0, #49 @ ASCII '1'
    str r0, [r1] @ Store 1 in string
    bl _write
    mov r6, r8 @ preserve number
    bal _update_mask

_print0:
    mov r8, r6
    mov r0, #48 @ ASCII 'o'
    str r0, [r1] @store o in string
    bl _write
    mov r6, r8

_update_mask:
  movs r9, r9, lsr #1 @ Move mask right one character
  bne _test_bits

_exit:
  mov r7, #1
  swi 0

_write:
    mov r0, #1
    mov r2, #1
    mov r7, #4
    swi 0
    mov pc, lr

.data
    string: .ascii " "
