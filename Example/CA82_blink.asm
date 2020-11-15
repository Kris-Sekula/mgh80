	.CR Z80
	.TF CA82_blink.HEX,INT

PIO_A	.EQ	00h		; CA80 user 8255 base address 	  (port A)
PIO_B	.EQ	01h		; CA80 user 8255 base address + 1 (port B)
PIO_C	.EQ	02h		; CA80 user 8255 base address + 2 (port C)
PIO_M	.EQ	03h		; CA80 user 8255 control register

	.OR 0000H
	NOP
	NOP
TU:	
	
	jp START
	
	.ORG 0101H

START:
	; main program

	ld sp,08100h		; set stack


	ld A,080h 			; configure, all ports Output
	out (PIO_M),A		;
	
INIT:	ld A,00h		; load 00 to port B register (LED OFF)
	out (PIO_B),A

	call pause			; delay
				
	ld A,0ffh			; load 0FFh to port B register (LED ON)
	out (PIO_B),A
	
	call pause			; delay
	
	jp INIT				; repeat

pause:
	LD BC, 01h            ; delay multiplier
Outer:
	LD DE, 3000h            ;Loads DE with hex 1000
Inner:
	DEC DE                  	;Decrements DE
	LD A, D                 	;Copies D into A
	OR E                    	;Bitwise OR of E with A (now, A = D | E)
	JP NZ, Inner            	;Jumps back to Inner: label if A is not zero
	DEC BC                  	;Decrements BC
	LD A, B                 	;Copies B into A
	OR C                    	;Bitwise OR of C with A (now, A = B | C)
	JP NZ, Outer            	;Jumps back to Outer: label if A is not zero
	RET                     	;Return from call to this subroutine	
