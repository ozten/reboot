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

/* mov r4,#0x20003000 */

@timerAddress .req r4

loop$:

turn_off_led:	
	/* Turn off LED */
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#0
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	mov r0, #3 	@ldr r0,=0x200B20          @ 700 which is 1 millisecond 0x3F000 is about 6 seconds (5898.24 = 4128768 / 700)
	bl Sleep
	
turn_on_led:	

	/* Turn on the LED */
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#1
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	mov r0, #4      	@ldr r0,=0x3F0000          @ 700 which is 1 millisecond 0x3F000 is about 6 seconds (5898.24 = 4128768 / 700)
	bl Sleep	

	b loop$
