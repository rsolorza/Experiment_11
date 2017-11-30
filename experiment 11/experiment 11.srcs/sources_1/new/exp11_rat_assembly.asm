;------------------------------------------------------------------------------------
;- Experiment #11
;- Programmers: Ty Farris and Ryan Solorzano
;- 
;- Description: This program counts the number of interrupts
;-              and outputs the count to the 7 segment display
;------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------
; Various Ports 
;------------------------------------------------------------------------------------
.EQU SEGS     = 0x82			; Segment OUTPUT port
.EQU BTNS 	  = 0x24			; Buttons INPUT  port
.EQU DISP_EN  = 0x83			; Anodes  OUTPUT port
.EQU TCCR_ID  = 0xB5			; Timer module TCCR
.EQU TCNT0_ID = 0xB0 			; Timer module TCNT0
.EQU TCNT1_ID = 0xB1 			; Timer module TCNT1
.EQU TCNT2_ID = 0xB2 			; Timer module TCNT0
;------------------------------------------------------------------------------------
; Segment LUT for Decimal Digits
;------------------------------------------------------------------------------------
.DSEG
.ORG 0x00
seg_data: 	.DB 0x03, 0x9F, 0x25, 0x0D, 0x99	; for (0-4) 
			.DB 0x49, 0x41, 0x1F, 0x01, 0x09	; for (5-9)

;------------------------------------------------------------------------------------
; Foreground Task
;------------------------------------------------------------------------------------
.CSEG
.ORG  0x15

init:  	MOV   r0, 0x00			; Ones digit 
        MOV   r1, 0x00			; Tens digit

		MOV	  r2, 0x00			; Value for TCNT2 for Multiplexing
		MOV	  r3, 0xFF			; Value for TCNT1 for Multiplexing
		MOV   r4, 0xFF			; Value for TCNT0 for Multiplexing
		MOV   r5, 0x80			; Value for TCCR for Multiplexing	

		OUT	  r2, TCNT2_ID		; Set tcnt_2 for multiplexing
		OUT   r3, TCNT1_ID		; Set tcnt_1 for multiplexing
		OUT   r4, TCNT0_ID 		; Set tcnt_0 for multiplexing
		OUT   r5, TCCR_ID		; Set tccr for multiplexing
		SEI						; Turn on the interrupt
		
main:	IN	  r6, BTNS			; Input the buttons
		AND   r6, 0x02			; Mask the left button
		BREQ  main				; If the button is not pressed, start over
		CALL  delay				; Delay for 10 microseconds
		IN    r6, BTNS			; Input buttons
		AND   r6, 0x02			; Mask leftmost button
		BREQ  main				; If button is 0, then it's still bouncing
								; Otherwise increment the registers

		ADD    r0, 0x01			; Increment r0
		CMP    r0, 0x0A			; See if r0 > 10
		BRNE   done1 			; If it is not, then you are done with this part
		ADD    r1, 0x01			; If it is add 1 to the 10's place
		MOV    r0, 0x00			; Set the 1's place to 0

done1:  CMP	   r1, 0x05			; Check if the 10's place = 50
		BRNE   done2 			; If its not, then you are done
		MOV	   r0, 0x00			; Otherwise, reset the 10's place ...
		MOV	   r1, 0x00			; ... and the 1's place

done2:  						; Now wait for button to be released
		IN    r6, BTNS 			; Input the buttons
		AND   r6, 0x02			; Mask the leftmost button
		BRNE  done2				; loop if button is still being pressed
		CALL delay				; Make sure there is no bounce
		IN    r6, BTNS			
		AND   r6, 0x02
		BREQ  main				; Otherwise go to main
		BRN   done2
	
;--------------------------------------------------------------------
;- Delay Subroutine
;- Delays for 10 microseconds
;--------------------------------------------------------------------
delay:	 MOV r25, 0x00			; Initialize stuff
		 MOV r26, 0x00			; Initialize stuff
loop3:	 ADD r25, 0x01			; Increment first register
		 CMP r25, 0xFA			; Check if you counted to 250
		 BRNE loop3				; If you are not yet at 250
		 MOV r25, 0x00			; Reset
loop4:   ADD r26, 0x01			; Increment second counter
		 CMP r26, 0x02			; If the second counter = 2 
		 BRNE loop3				; if it is not, you are not done
		 RET				

;------------------------------------------------------------------------------------
;- Interupt Service Routine
;- 
;- Description: This ISR handles the button press, and multiplexing the display. If
;-              the button has been presseed, then this increments the count to the 
;-              segments, and if it is above 49, it resets the value outputted to 0.
;------------------------------------------------------------------------------------
ISR:	MOV   r22, 0xFF			; Turn off anodes
		OUT   r22, DISP_EN		; Output the value to the segments

		CMP	  r15, 0x00			; Check which segment to turn on
		BRNE  segment_2			; If you are outputting to segment 2

segment_1: 		
		LD	  r10, (r0)			; Load the value of one's digit
		OUT	  r10, SEGS			; Output the segment value to the segment display
		MOV   r10, 0x07			; Only turn on the rightmost segment
		OUT   r10, DISP_EN		; Output the segment to display enable
		MOV   r15, 0x01			; Go to segment 2 next
		BRN done				; Done

segment_2: 
		LD    r10, (r1)			; Load the value of ten's digit
		OUT   r10, SEGS			; Output the value of 10's digit
		MOV   r10, 0x0B			; Set value for anodes
		OUT   r10, DISP_EN		; Enable anodes
		MOV   r15, 0x00			; Go to segment 1 next
		
done:  RETIE					; Return with interrupt enabled
;------------------------------------------------------------------------------------
.CSEG
.ORG  0x3FF
        BRN    ISR		



