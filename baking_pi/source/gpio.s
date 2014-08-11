/*
 * Raspberry Pi GPIO Controller Addresses
 * 0x20200000 -- Base Addresses
 * 0 -  24 -- Function Set
 * 28 - 36 --  Turn On Pin
 * 40 - 48 --  Turn Off Pin
 * 52 - 60 --  Pin Input
 */


/* return the address of the GPIO pin */
.globl GetGpioAddress
GetGpioAddress:
	ldr r0,=0x20200000
	mov pc,lr

/* Set the function of the GPIO register address in r0
 * to the low 3 bits of r1 */
.globl SetGpioFunction
SetGpioFunction:
	/* Validate that r0 is in the range 0 - 53
	   Validate that r1 is in the range 0 - 7 */
	cmp r0,#53
	cmpls r1,#7
	movhi pc,lr
	push {lr}
	mov r2,r0
	bl GetGpioAddress

	functionLoop$:
		cmp r2,#9
		subhi r2,#10
		addhi r0,#4
		bhi functionLoop$

	add r2, r2,lsl #1
	lsl r1,r2
	str r1,[r0]
	pop {pc}

/* Set a GPIO pin to a value
 * r0 GPIO register address
 * r1 value - 0 or 1
 */
.globl SetGpio
SetGpio:
	pinNum .req r0 /* Register Alias, pinNum now means r0 */
	pinVal .req r1
	cmp pinNum,#53
	movhi pc,lr
	push {lr}
	mov r2,pinNum
	.unreq pinNum
	pinNum .req r2
	bl GetGpioAddress
	gpioAddr .req r0
	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr,pinBank
	.unreq pinBank
	and pinNum,#31
	setBit .req r3
	mov setBit,#1
	lsl setBit,pinNum
	.unreq pinNum
	teq pinVal,#0
	.unreq pinVal
	streq setBit,[gpioAddr,#40]
	strne setBit,[gpioAddr,#28]
	.unreq setBit
	.unreq gpioAddr
	pop {pc}
