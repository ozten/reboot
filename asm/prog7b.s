/* Syscall 4 to write to the screen */
	.global _start
_start:

_read:
	MOV R7, #3 @ Read input Syscall
	MOV R0, #0
	MOV R2, #5 @ Read 5 characters
	LDR R1,=string
	SWI 0

_write:

	MOV R7, #4 @ Write output Syscall
	MOV R0, #1 @ To the screen
	MOV R2, #19 @ String length
	LDR R1,=string @ The string is located at string
	SWI 0

_exit: @exit syscall
	MOV R7, #1 @ Exit Syscall
	SWI 0
.data
string:
	.ascii "Hello World String\n"
