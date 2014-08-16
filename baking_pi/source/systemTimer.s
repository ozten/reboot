	/* r0 - number of seconds to sleep to sleep.
	        r0 must be between 1 and 6135 */
	
	/* TODO: check that r0 < 6135 */
	.global Sleep
Sleep:
	push {lr, r7, r8}
        ldr r7,=0xAAE60 	@ 0xAAE60 is 700,000 - seconds * 1000 (for milliseconds) * 700 ( Raspberry Pi is 700 MHz)
	MUL r8, r0, r7          @ convert seconds to milliseconds

	ldr r1,=0x20003000	@ System Timer Base Address
	ldrd r2,r3,[r1,#4]
	mov r4, r2		@ Counter value when we started

        wait1$:
  	    ldrd r2,r3,[r1,#4]
  	    sub r3,r2,r4	@ Store into r3 current - start (current is usually larger)
  	    cmp r3, r8		@ Compare ellapsed time to our target delay r8 (700) - r3 (300) = 400
	    blt wait1$		@ If ellapsed time is less, keep waiting
	
	pop {pc, r7, r8}