
.def toggleVar = r20
.def numberVar = r17
.def numberVar2 = r18

COLD:
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	ldi r16, LOW(RAMEND)
	out SPL, r16
	call HW_INIT


MAIN:
	sbis PINA, 4
	jmp MAIN
	in numberVar, PINA
	andi numberVar, $0F					//Tar bort strobe
	cpi numberVar, 15
	brne NO_TOGGLE
	com toggleVar

NO_TOGGLE:

	cpi numberVar, 10
	brpl WAIT
	in numberVar2, PORTB
	sbrs toggleVar, 0
	jmp RIGHT

LEFT:
	andi numberVar2, $0F
	swap numberVar
	jmp PRINT

RIGHT:
	andi numberVar2, $F0

PRINT:
	or numberVar2, numberVar
	out PORTB, numberVar2
	jmp WAIT



TOGGLE:
	com toggleVar
	mov numberVar2, numberVar
	inc numberVar
	swap numberVar
	jmp PRINT

WAIT:
	sbic PINA, 4
	jmp WAIT
	jmp MAIN


HW_INIT:
	ldi r16, 0
	out DDRA, r16
	ldi r16, $FF
	out DDRB, r16
	ldi r16, $00
	out PORTB, r16
	clr numberVar
	clr toggleVar
	ret