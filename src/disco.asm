	include p16f84a.inc

TMR0		EQU 1 		;means TMR0 is file 1.
STATUS		EQU 3 		;means STATUS is file 3.
PORTA		EQU 5 		;means PORTA is file 5.
PORTB		EQU 6 		;means PORTB is file 6.
TRISA		EQU 85H		;TRISA (the PORTA I/O selection) is file 85H
TRISB		EQU 86H		;TRISB (the PORTB I/O selection) is file 86H
OPTION_R	EQU 81H		;the OPTION register is file 81H
ZEROBIT		EQU 2		;means ZEROBIT is bit 2.
COUNT		EQU 0CH		; COUNT is file 0C, a register to count events.

	LIST 	P=16F84A 	;we are using the 16F84A.
	ORG 	0 			;the start address in memory is 0
	GOTO 	START 		;goto start!

	__CONFIG H'3FF0' 	;selects LP oscillator, WDT off, PUT on,
						; Code Protection disabled.
;SUBROUTINE SECTION.
DELAYP5 CLRF TMR0 					;START TMR0.
LOOPB 		MOVF TMR0,W 			;READ TMR0 INTO W.
		SUBLW 	.16 				;TIME - 16
		BTFSS 	STATUS,ZEROBIT 		; Check TIME-W ¼ 0
		GOTO 	LOOPB 				;Time is not ¼ 16.
		RETLW 0 					;Time is 16, return.
		MOVLW 	.5 					;Move 5 into W
		MOVWF 	COUNT 				;Move W into user file COUNT
		MOVLW 	.10 				;Move 10 into W
		MOVWF 	COUNT 				;Move W into user file COUNT
		DECFSZ 	COUNT 				;decrement file COUNT skip if zero.
		GOTO 	SEQ2 				;COUNT not yet zero, repeat sequence
		DECFSZ 	COUNT 				;decrement file COUNT skip if zero.
		GOTO 	SEQ1 				;COUNT not yet zero, repeat sequence
;CONFIGURATION SECTION.
START	BSF 		STATUS,5		;Turns to Bank1.
		MOVLW		B'00011111'		;5bits of PORTA are I/P
		MOVWF		TRISA
		MOVLW		B'00000000'
		MOVWF		TRISB			;PORTB is OUTPUT
		MOVLW		B'00000111' 	;Prescaler is /256
		MOVWF		OPTION_R		;TIMER is 1/64 secs.
		BCF			STATUS,5		;Return to Bank0.
		CLRF		PORTA			;Clears PortA.
		CLRF		PORTB			;Clears PortB.

BEGIN 	MOVLW 		.5
		MOVWF 		COUNT 			;Set COUNT ¼ 5
SEQ1 	MOVLW 		B'11111111'
		MOVWF 		PORTB 			;Turn B7-B0 ON
		CALL 		DELAYP5 		;Wait 0.5 seconds
		MOVLW 		B'00000000'
		MOVWF 		PORTB 			;Turn B7-B0 OFF
		CALL 		DELAYP5 		;Wait 0.5 seconds
		DECFSZ 		COUNT 			;COUNT-1, skip if 0.
		GOTO 		SEQ1
		MOVLW 		.10
		MOVWF 		COUNT 			;Set COUNT = 10
SEQ2 	MOVLW 		B'11110000'
		MOVWF 		PORTB 			;B7-B4 on, B3-B0 off
		CALL 		DELAYP5 		;Wait 0.5 seconds
		MOVLW 		B'00001111'
		MOVWF 		PORTB 			;B7-B4 off, B3-B0 on
		CALL 		DELAYP5 		;Wait 0.5 seconds
		DECFSZ 		COUNT 			;COUNT-1, skip if 0.
		GOTO 		SEQ2
		GOTO 		BEGIN
		END
