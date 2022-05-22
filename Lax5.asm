.def toggleVar = r20
.def numberVar = r17
.def numberCopyVar = r18

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
	cpi numberVar, 0
	breq TOGGLE
	call NUMBER
	call PRINT
	call WAIT


NUMBER:
	mov numberCopyVar, numberVar			//Kopierar

	swap numberVar
	cpi toggleVar, 0
	breq ADD_COPY
	call ADD_INVERTED_COPY

	ret

ADD_INVERTED_COPY:
	com numberCopyVar
	subi numberCopyVar, $F0				//Tar bort alla ettor
	add numberVar, numberCopyVar
	ret
		
	
ADD_COPY:
	add numberVar, numberCopyVar
	ret


TOGGLE:
	cpi toggleVar, 0
	breq INC_TOGGLE


	DEC_TOGGLE:
		dec toggleVar
		jmp WAIT

	INC_TOGGLE:
		inc toggleVar
		jmp WAIT



WAIT:
	sbic PINA, 4
	jmp WAIT
	jmp MAIN

PRINT:
	out PORTB, numberVar
	out PORTD, toggleVar
	ret

HW_INIT:
	ldi r16, 0
	out DDRA, r16
	ldi r16, $FF
	out DDRB, r16
	out DDRD, r16
	clr numberVar
	clr toggleVar
	clr numberCopyVar
	ret