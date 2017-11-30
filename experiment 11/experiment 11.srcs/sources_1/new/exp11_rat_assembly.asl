

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;------------------------------------------------------------------------------------
(0002)                            || ;- Experiment #11
(0003)                            || ;- Programmers: Ty Farris and Ryan Solorzano
(0004)                            || ;- 
(0005)                            || ;- Description: This program counts the number of interrupts
(0006)                            || ;-              and outputs the count to the 7 segment display
(0007)                            || ;------------------------------------------------------------------------------------
(0008)                            || 
(0009)                            || ;------------------------------------------------------------------------------------
(0010)                            || ; Various Ports 
(0011)                            || ;------------------------------------------------------------------------------------
(0012)                       130  || .EQU SEGS     = 0x82			; Segment OUTPUT port
(0013)                       036  || .EQU BTNS 	  = 0x24			; Buttons INPUT  port
(0014)                       131  || .EQU DISP_EN  = 0x83			; Anodes  OUTPUT port
(0015)                       181  || .EQU TCCR_ID  = 0xB5			; Timer module TCCR
(0016)                       176  || .EQU TCNT0_ID = 0xB0 			; Timer module TCNT0
(0017)                       177  || .EQU TCNT1_ID = 0xB1 			; Timer module TCNT1
(0018)                       178  || .EQU TCNT2_ID = 0xB2 			; Timer module TCNT0
(0019)                            || ;------------------------------------------------------------------------------------
(0020)                            || ; Segment LUT for Decimal Digits
(0021)                            || ;------------------------------------------------------------------------------------
(0022)                            || .DSEG
(0023)                       000  || .ORG 0x00
(0024)  DS-0x000             005  || seg_data: 	.DB 0x03, 0x9F, 0x25, 0x0D, 0x99	; for (0-4) 
(0025)  DS-0x005             005  || 			.DB 0x49, 0x41, 0x1F, 0x01, 0x09	; for (5-9)
(0026)                            || 
(0027)                            || ;------------------------------------------------------------------------------------
(0028)                            || ; Foreground Task
(0029)                            || ;------------------------------------------------------------------------------------
(0030)                            || .CSEG
(0031)                       021  || .ORG  0x15
(0032)                            || 
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x36003  0x003  ||              MOV     r0,0x03     ; write dseg data to reg
-STUP-  CS-0x001  0x3A000  0x000  ||              LD      r0,0x00     ; place reg data in mem 
-STUP-  CS-0x002  0x3609F  0x09F  ||              MOV     r0,0x9F     ; write dseg data to reg
-STUP-  CS-0x003  0x3A001  0x001  ||              LD      r0,0x01     ; place reg data in mem 
-STUP-  CS-0x004  0x36025  0x025  ||              MOV     r0,0x25     ; write dseg data to reg
-STUP-  CS-0x005  0x3A002  0x002  ||              LD      r0,0x02     ; place reg data in mem 
-STUP-  CS-0x006  0x3600D  0x00D  ||              MOV     r0,0x0D     ; write dseg data to reg
-STUP-  CS-0x007  0x3A003  0x003  ||              LD      r0,0x03     ; place reg data in mem 
-STUP-  CS-0x008  0x36099  0x099  ||              MOV     r0,0x99     ; write dseg data to reg
-STUP-  CS-0x009  0x3A004  0x004  ||              LD      r0,0x04     ; place reg data in mem 
-STUP-  CS-0x00A  0x36049  0x049  ||              MOV     r0,0x49     ; write dseg data to reg
-STUP-  CS-0x00B  0x3A005  0x005  ||              LD      r0,0x05     ; place reg data in mem 
-STUP-  CS-0x00C  0x36041  0x041  ||              MOV     r0,0x41     ; write dseg data to reg
-STUP-  CS-0x00D  0x3A006  0x006  ||              LD      r0,0x06     ; place reg data in mem 
-STUP-  CS-0x00E  0x3601F  0x01F  ||              MOV     r0,0x1F     ; write dseg data to reg
-STUP-  CS-0x00F  0x3A007  0x007  ||              LD      r0,0x07     ; place reg data in mem 
-STUP-  CS-0x010  0x36001  0x001  ||              MOV     r0,0x01     ; write dseg data to reg
-STUP-  CS-0x011  0x3A008  0x008  ||              LD      r0,0x08     ; place reg data in mem 
-STUP-  CS-0x012  0x36009  0x009  ||              MOV     r0,0x09     ; write dseg data to reg
-STUP-  CS-0x013  0x3A009  0x009  ||              LD      r0,0x09     ; place reg data in mem 
-STUP-  CS-0x014  0x080A8  0x100  ||              BRN     0x15        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0033)  CS-0x015  0x36000  0x015  || init:  	MOV   r0, 0x00			; Ones digit 
(0034)  CS-0x016  0x36100         ||         MOV   r1, 0x00			; Tens digit
(0035)                            || 
(0036)  CS-0x017  0x36200         || 		MOV	  r2, 0x00			; Value for TCNT2 for Multiplexing
(0037)  CS-0x018  0x363FF         || 		MOV	  r3, 0xFF			; Value for TCNT1 for Multiplexing
(0038)  CS-0x019  0x364FF         || 		MOV   r4, 0xFF			; Value for TCNT0 for Multiplexing
(0039)  CS-0x01A  0x36580         || 		MOV   r5, 0x80			; Value for TCCR for Multiplexing	
(0040)                            || 
(0041)  CS-0x01B  0x342B2         || 		OUT	  r2, TCNT2_ID		; Set tcnt_2 for multiplexing
(0042)  CS-0x01C  0x343B1         || 		OUT   r3, TCNT1_ID		; Set tcnt_1 for multiplexing
(0043)  CS-0x01D  0x344B0         || 		OUT   r4, TCNT0_ID 		; Set tcnt_0 for multiplexing
(0044)  CS-0x01E  0x345B5         || 		OUT   r5, TCCR_ID		; Set tccr for multiplexing
(0045)  CS-0x01F  0x1A000         || 		SEI						; Turn on the interrupt
(0046)                            || 		
(0047)  CS-0x020  0x32624  0x020  || main:	IN	  r6, BTNS			; Input the buttons
(0048)  CS-0x021  0x20602         || 		AND   r6, 0x02			; Mask the left button
(0049)  CS-0x022  0x08102         || 		BREQ  main				; If the button is not pressed, start over
(0050)  CS-0x023  0x081C1         || 		CALL  delay				; Delay for 10 microseconds
(0051)  CS-0x024  0x32624         || 		IN    r6, BTNS			; Input buttons
(0052)  CS-0x025  0x20602         || 		AND   r6, 0x02			; Mask leftmost button
(0053)  CS-0x026  0x08102         || 		BREQ  main				; If button is 0, then it's still bouncing
(0054)                            || 								; Otherwise increment the registers
(0055)                            || 
(0056)  CS-0x027  0x28001         || 		ADD    r0, 0x01			; Increment r0
(0057)  CS-0x028  0x3000A         || 		CMP    r0, 0x0A			; See if r0 > 10
(0058)  CS-0x029  0x08163         || 		BRNE   done1 			; If it is not, then you are done with this part
(0059)  CS-0x02A  0x28101         || 		ADD    r1, 0x01			; If it is add 1 to the 10's place
(0060)  CS-0x02B  0x36000         || 		MOV    r0, 0x00			; Set the 1's place to 0
(0061)                            || 
(0062)  CS-0x02C  0x30105  0x02C  || done1:  CMP	   r1, 0x05			; Check if the 10's place = 50
(0063)  CS-0x02D  0x08183         || 		BRNE   done2 			; If its not, then you are done
(0064)  CS-0x02E  0x36000         || 		MOV	   r0, 0x00			; Otherwise, reset the 10's place ...
(0065)  CS-0x02F  0x36100         || 		MOV	   r1, 0x00			; ... and the 1's place
(0066)                            || 
(0067)                     0x030  || done2:  						; Now wait for button to be released
(0068)  CS-0x030  0x32624         || 		IN    r6, BTNS 			; Input the buttons
(0069)  CS-0x031  0x20602         || 		AND   r6, 0x02			; Mask the leftmost button
(0070)  CS-0x032  0x08183         || 		BRNE  done2				; loop if button is still being pressed
(0071)  CS-0x033  0x081C1         || 		CALL delay				; Make sure there is no bounce
(0072)  CS-0x034  0x32624         || 		IN    r6, BTNS			
(0073)  CS-0x035  0x20602         || 		AND   r6, 0x02
(0074)  CS-0x036  0x08102         || 		BREQ  main				; Otherwise go to main
(0075)  CS-0x037  0x08180         || 		BRN   done2
(0076)                            || 	
(0077)                            || ;--------------------------------------------------------------------
(0078)                            || ;- Delay Subroutine
(0079)                            || ;- Delays for 10 microseconds
(0080)                            || ;--------------------------------------------------------------------
(0081)  CS-0x038  0x37900  0x038  || delay:	 MOV r25, 0x00			; Initialize stuff
(0082)  CS-0x039  0x37A00         || 		 MOV r26, 0x00			; Initialize stuff
(0083)  CS-0x03A  0x29901  0x03A  || loop3:	 ADD r25, 0x01			; Increment first register
(0084)  CS-0x03B  0x319FA         || 		 CMP r25, 0xFA			; Check if you counted to 250
(0085)  CS-0x03C  0x081D3         || 		 BRNE loop3				; If you are not yet at 250
(0086)  CS-0x03D  0x37900         || 		 MOV r25, 0x00			; Reset
(0087)  CS-0x03E  0x29A01  0x03E  || loop4:   ADD r26, 0x01			; Increment second counter
(0088)  CS-0x03F  0x31A02         || 		 CMP r26, 0x02			; If the second counter = 2 
(0089)  CS-0x040  0x081D3         || 		 BRNE loop3				; if it is not, you are not done
(0090)  CS-0x041  0x18002         || 		 RET				
(0091)                            || 
(0092)                            || ;------------------------------------------------------------------------------------
(0093)                            || ;- Interupt Service Routine
(0094)                            || ;- 
(0095)                            || ;- Description: This ISR handles the button press, and multiplexing the display. If
(0096)                            || ;-              the button has been presseed, then this increments the count to the 
(0097)                            || ;-              segments, and if it is above 49, it resets the value outputted to 0.
(0098)                            || ;------------------------------------------------------------------------------------
(0099)  CS-0x042  0x376FF  0x042  || ISR:	MOV   r22, 0xFF			; Turn off anodes
(0100)  CS-0x043  0x35683         || 		OUT   r22, DISP_EN		; Output the value to the segments
(0101)                            || 
(0102)  CS-0x044  0x30F00         || 		CMP	  r15, 0x00			; Check which segment to turn on
(0103)  CS-0x045  0x08263         || 		BRNE  segment_2			; If you are outputting to segment 2
(0104)                            || 
(0105)                     0x046  || segment_1: 		
(0106)  CS-0x046  0x04A02         || 		LD	  r10, (r0)			; Load the value of one's digit
(0107)  CS-0x047  0x34A82         || 		OUT	  r10, SEGS			; Output the segment value to the segment display
(0108)  CS-0x048  0x36A07         || 		MOV   r10, 0x07			; Only turn on the rightmost segment
(0109)  CS-0x049  0x34A83         || 		OUT   r10, DISP_EN		; Output the segment to display enable
(0110)  CS-0x04A  0x36F01         || 		MOV   r15, 0x01			; Go to segment 2 next
(0111)  CS-0x04B  0x08288         || 		BRN done				; Done
(0112)                            || 
(0113)                     0x04C  || segment_2: 
(0114)  CS-0x04C  0x04A0A         || 		LD    r10, (r1)			; Load the value of ten's digit
(0115)  CS-0x04D  0x34A82         || 		OUT   r10, SEGS			; Output the value of 10's digit
(0116)  CS-0x04E  0x36A0B         || 		MOV   r10, 0x0B			; Set value for anodes
(0117)  CS-0x04F  0x34A83         || 		OUT   r10, DISP_EN		; Enable anodes
(0118)  CS-0x050  0x36F00         || 		MOV   r15, 0x00			; Go to segment 1 next
(0119)                            || 		
(0120)  CS-0x051  0x1A003  0x051  || done:  RETIE					; Return with interrupt enabled
(0121)                            || ;------------------------------------------------------------------------------------
(0122)                            || .CSEG
(0123)                       1023  || .ORG  0x3FF
(0124)  CS-0x3FF  0x08210         ||         BRN    ISR		
(0125)                            || 
(0126)                            || 
(0127)                            || 





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
DELAY          0x038   (0081)  ||  0050 0071 
DONE           0x051   (0120)  ||  0111 
DONE1          0x02C   (0062)  ||  0058 
DONE2          0x030   (0067)  ||  0063 0070 0075 
INIT           0x015   (0033)  ||  
ISR            0x042   (0099)  ||  0124 
LOOP3          0x03A   (0083)  ||  0085 0089 
LOOP4          0x03E   (0087)  ||  
MAIN           0x020   (0047)  ||  0049 0053 0074 
SEGMENT_1      0x046   (0105)  ||  
SEGMENT_2      0x04C   (0113)  ||  0103 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BTNS           0x024   (0013)  ||  0047 0051 0068 0072 
DISP_EN        0x083   (0014)  ||  0100 0109 0117 
SEGS           0x082   (0012)  ||  0107 0115 
TCCR_ID        0x0B5   (0015)  ||  0044 
TCNT0_ID       0x0B0   (0016)  ||  0043 
TCNT1_ID       0x0B1   (0017)  ||  0042 
TCNT2_ID       0x0B2   (0018)  ||  0041 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
SEG_DATA       0x005   (0024)  ||  
