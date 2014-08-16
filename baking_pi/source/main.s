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

/* ================ */

/*
	mov r2,#0x3F0000	@ 2 second delay
wait1$:	
		sub r2,#1
		cmp r2,#0
		bne wait1$
*/

/* ================ */	
	

	mov r3, #0x3F0000          @ 700 which is 1 second
	ldr r2,=0x20003000	@ System Timer Base Address
	ldrd r0,r1,[r2,#4]
	mov r4, r0		@ Counter value when we started

wait1$:
	ldr r2,=0x20003000	@ System Timer Base Address
	ldrd r0,r1,[r2,#4]
	sub r1,r0,r4		@ Store into r1 current - start (current is usually larger)
	cmp r1, r3		@ Compare ellapsed time to our target delay r3 (700) - r1 (300) = 400
	blt wait1$		@ If ellapsed time is less, keep waiting

	
turn_on_led:	

	/* Turn on the LED */
	pinNum .req r0
	pinVal .req r1
	mov pinNum,#16
	mov pinVal,#1
	bl SetGpio
	.unreq pinNum
	.unreq pinVal


	/*
	mov r2,#0x3F0000	@ 2 second delay
wait2$:	
	sub r2,#1
	cmp r2,#0
        bne wait2$
	*/

	mov r3, #0x3F0000       @ 700 which is 1 millisecond 0x3F000 is about 6 seconds (5898.24 = 4128768 / 700)
	ldr r2,=0x20003000	@ System Timer Base Address
	ldrd r0,r1,[r2,#4]
	mov r4, r0		@ Counter value when we started

wait2$:
	ldr r2,=0x20003000	@ System Timer Base Address
	ldrd r0,r1,[r2,#4]
	sub r1,r0,r4		@ Store into r1 current - start (current is usually larger)
	cmp r1, r3		@ Compare ellapsed time to our target delay r3 (700) - r1 (300) = 400
	blt wait2$		@ If ellapsed time is less, keep waiting

	b loop$
