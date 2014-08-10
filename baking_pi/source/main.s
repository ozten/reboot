.section .init
.globl _start
_start:
b main

.section .text

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

loop$:

	/* Turn off LED */
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#0
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	/* Sleep 2 seconds */
	mov r2,#0x3F0000
	wait1$:
		sub r2,#1
		cmp r2,#0
		bne wait1$

	/* Turn on the LED */
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#1
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	/* Sleep 2 seconds */
	mov r2,#0x3F0000
	wait2$:
		sub r2,#1
		cmp r2,#0
		bne wait2$
b loop$
