.def counter = r17


COLD:
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	ldi r16, LOW(RAMEND)
	out SPL, r16
	call HW_INIT

MAIN:
	sbic PINA, 0
	jmp LEFT
	sbic PINA, 1
	jmp RIGHT
	jmp MAIN

LEFT:
	cpi counter, 15
	breq MAX_COUNTER
	inc counter	
	jmp WAIT_L

MAX_COUNTER:
	ldi counter, 15
	jmp WAIT_L

RIGHT:
	
	out PORTB, counter
	clr counter
	jmp WAIT_R

WAIT_R:
	sbic PINA, 1
	jmp WAIT_R
	jmp MAIN

WAIT_L:
	sbic PINA, 0
	jmp WAIT_L
	jmp MAIN

HW_INIT:
	ldi r16, 0
	out DDRA, r16
	ldi r16, $FF
	out DDRB, r16
	clr r16
	clr counter
	ret