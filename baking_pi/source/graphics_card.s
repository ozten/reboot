
	.globl GetMailboxBase
GetMailboxBase:
	ldr r0,=0x2000B880
	mov pc,lr


	.globl MailboxWrite
MailboxWrite:
	tst r0,#0b1111		@ Top bit must be 0
	movne pc,lr		@ Bail
	cmp r1,#15		@ Check mailbox is expected
	movhi pc,lr

	channel .req r1
	value .req r2
	mov value,r0
	push {lr}
	bl GetMailboxBase
	mailbox .req r0

wait1$:
	status .req r3
	ldr status,[mailbox,#0x18]
	tst status,#0x80000000	@ Mask when we are ready
	.unreq status
	bne wait1$

	add value,channel
	.unreq channel

	str value,[mailbox,#0x20]
	.unreq value
	.unreq mailbox
	pop {pc}


	.globl MailboxRead
MailboxRead:
	cmp r0,#15		@ Check mailbox
	movhi pc,lr		@ Bail
	channel .req r1
	mov channel,r0
	push {lr}
	bl GetMailboxBase
	mailbox .req r0

rightmail$:
wait2$:
	status .req r2
	ldr status,[mailbox,#0x18]
	tst status,#0x40000000
	.unreq status
	bne wait2$

	mail .req r2
	ldr mail,[mailbox,#0]	@ Read the next item

	inchan .req r3
	and inchan,mail,#0b1111
	teq inchan,channel	@ Is this the right mailbox?
	.unreq inchan
	bne rightmail$
	.unreq mailbox
	.unreq channel

	and r0,mail,#0xfffffff0 @ Save mail in r0
	.unreq mail
	pop {pc}