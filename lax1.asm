.def number = r17


COLD:
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	ldi r16, LOW(RAMEND)
	out SPL, r16
	call HW_INIT

MAIN:
	sbis PINA, 4
	jmp MAIN
	call GET_NUMBER
	call PRINT
	call WAIT



GET_NUMBER:
	in number, PINA
	andi number, $0F					//Tar bort strobe
	cpi number, 10
	brpl SEPARATE
	ret

SEPARATE:
	subi number, $FA

PRINT:
	out PORTB, number

WAIT:
	sbic PINA, 4
	jmp WAIT
	jmp MAIN


HW_INIT:
	ldi r16, 0
	out DDRA, r16
	ldi r16, $FF
	out DDRB, r16
	clr r16
	clr number

	ret