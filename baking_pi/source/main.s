.section .init
.globl _start
_start:
    b main

.section .text

	ptrn .req r4
	ldr ptrn,=pattern
	ldr ptrn,[ptrn]
	seq .req r5
	mov seq,#0

main:
    mov sp,#0x800 /* See ../kernel.ld 0x800 is the start of .init */


/* Set up GPIO port 16 in binary mode (001) */
    pinNum .req r0
    pinFunc .req r1
    mov pinNum,#16
    mov pinFunc,#1
    bl SetGpioFunction
    .unreq pinNum
    .unreq pinFunc

/* mov r4,#0x20003000 */

@timerAddress .req r4

loop$:



turn_on_or_off_led:	
	/* Turn off LED */
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16

read_pattern:	
	mov pinVal,#1
	lsl pinVal,seq
	and pinVal,ptrn	

	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	mov r0, #1 	@ldr r0,=0x200B20          @ 700 which is 1 millisecond 0x3F000 is about 6 seconds (5898.24 = 4128768 / 700)
	bl Sleep

update_pattern_seq:
	add seq, seq, #1
	cmp seq,#31
	movgt seq,#0
	
	b loop$

	.section .data
	.align 2
pattern:
	.int 0b11111111101010100010001000101010
	