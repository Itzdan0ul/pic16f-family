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
						;	Code Protection disabled.
;SUBROUTINE SECTION.
; 1 second delay.
DELAY2		CLRF TMR0			;START TMR0.
LOOPA		MOVF TMR0,W			;READ TMR0 INTO W.
	SUBLW		.64 			;TIME - 64
	BTFSS		STATUS,ZEROBIT	; Check TIME-W = 0
	GOTO		LOOPA			;Time is not = 64.
	RETLW		0				;Time is 64, return.

; 0.5 second delay.
DELAY5		CLRF TMR0			;START TMR0.
LOOPB		MOVF TMR0,W 		;READ TMR0 INTO W.
	SUBLW		.64				;TIME - 64
	BTFSS		STATUS,ZEROBIT	; Check TIME-W ¼ 0
	GOTO		LOOPB			;Time is not 64.
	RETLW 		0				;Time is 64, return.

;CONFIGURATION SECTION.
START	BSF STATUS,5				;Turns to Bank1.
		MOVLW		B'00011111'		;5bits of PORTA are I/P
		MOVWF		TRISA
		MOVLW		B'00000000'
		MOVWF		TRISB			;PORTB is OUTPUT
		MOVLW		B'00000111' 	;Prescaler is /256
		MOVWF		OPTION_R		;TIMER is 1/32 secs.
		BCF			STATUS,5		;Return to Bank0.
		CLRF		PORTA			;Clears PortA.
		CLRF		PORTB			;Clears PortB.

BEGIN MOVLW B'00100100' ;R1, R2 on.
	MOVWF PORTB
	CALL DELAY2			;Wait 2 Seconds.
	MOVLW B'00110100' 	;R1, A1, R2 on.
	MOVWF PORTB
	CALL DELAY2 		;Wait 2 Seconds.
	MOVLW B'00001100' 	;G1, R2 on.
	MOVWF PORTB
	CALL DELAY5 		;Wait 5 Seconds.
	MOVLW B'00010100'	;A1, R2 on.
	MOVWF PORTB
	CALL DELAY2			;Wait 2 Seconds.
	MOVLW B'00100100'	;R1, R2 on.
	MOVWF PORTB
	
	CALL DELAY2			;Wait 2 Seconds.
	MOVLW B'00100110'	;R1, R2, A2 on.
	MOVWF PORTB
	CALL DELAY2			;Wait 2 Seconds.
	MOVLW B'00100001'	;R1, G2 on.
	MOVWF PORTB
	CALL DELAY5 		;Wait 5 Seconds.
	MOVLW B'00100010'	;R1, A2 on.
	MOVWF PORTB
	CALL DELAY2			;Wait 2 Seconds.
	GOTO BEGIN
	END