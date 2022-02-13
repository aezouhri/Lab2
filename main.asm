;

; lab2.asm

;

; Created: 2/5/2022 11:50:46 AM

; Author : aezouhri

;

; put code here to configure I/0 lines ; as output & connected to SN74HC595

sbi  DDRB,1
sbi  DDRB,2
sbi  DDRB,3
cbi  DDRB,4
cbi  DDRB,5
; start main program

;rcall miliSecDelay

; display a digit 
L1: SBIS PINB,4
	rjmp L2
	ldi R16,0x06;0
	rcall display
	;rcall oneSecDelay
	ldi R18,0x07 ;0
	;rcall display2
	
	

	rjmp L1

L2: 

ldi R16, 0x06 ; load pattern to display
rcall display ; call display subroutine
rcall oneSecDelay
rcall effeciency

ldi R16, 0x5B ; load pattern to display
rcall display
rcall oneSecDelay
rcall effeciency

ldi R16, 0x4F ; load pattern to display
rcall display
rcall oneSecDelay
rcall effeciency

ldi R16, 0x66 ; load pattern to display
rcall display
rcall oneSecDelay
rcall effeciency

ldi R16, 0x6D; load pattern to display
rcall display
rcall oneSecDelay
rcall effeciency

ldi R16, 0x7D ; load pattern to display
rcall display
rcall effeciency
rcall oneSecDelay

ldi R16, 0x07 ; load pattern to display
rcall display
rcall oneSecDelay
rcall effeciency

ldi R16, 0x7F ; load pattern to display
rcall display
rcall oneSecDelay

;SBIS PINB,4    will try to move in some loop 
;rjmp L2

ldi R16, 0x67 ; load pattern to display
rcall display
rcall oneSecDelay
RJMP L2


L4:
ldi R16,0x06
rcall display2
rcall oneSecDelay
rjmp L2


effeciency:
	rcall debounce4
	rcall debounce5


display: 
; backup used registers on stack

	   

       push R16
       push R17
       in R17, SREG
       push R17
       ldi R17, 8 ; loop --> test all 8 bits
	  

loop:	

		;pop R18
        rol R16              ; rotate left trough Carry
		;rol R18
       BRCS set_ser_in_1    ; branch if Carry is set
       ; put code here to set SER to 0 ...
       cbi PORTB,3
       rjmp end


set_ser_in_1:
; put code here to set SER to 1...
       sbi PORTB,3



end: 
; put code here to generate SRCLK pulse...
       sbi PORTB,2
       rcall delay_long
       cbi PORTB,2
       dec R17
       brne loop


       ;put code here to generate RCLK pulse
              sbi PORTB,1
              rcall delay_long
              cbi PORTB,1

       ;restore registers from stack
       pop R17
       out SREG, R17
       pop R17
       pop R16
       ret
	   

display2: 
;backup used registers on stack

	    
       push R18
       push R19
       in R19, SREG
       push R19
       ldi R19, 8 ; loop --> test all 8 bits
	  

loop2:
       rol R18              ; rotate left trough Carry
       BRCS set_ser_in_12    ; branch if Carry is set
       ; put code here to set SER to 0 ...
       sbi PORTB,3
       rjmp end2


set_ser_in_12:
;put code here to set SER to 1...
       cbi PORTB,3

 
end2: 
; put code here to generate SRCLK pulse...
       sbi PORTB,2
       rcall delay_long
       cbi PORTB,2
       dec R19
       brne loop2


              ; put code here to generate RCLK pulse
              sbi PORTB,1
              rcall delay_long
              cbi PORTB,1
			  

       ;restore registers from stack
       pop R19
       out SREG, R19
       pop R19
       pop R18
       ret


stop: 
	jmp stop









delay_long:
    
       ldi   r23,10   
       d1: ldi   r24,98    
       d2: ldi   r25,50    
       d3: dec   r25
       nop   
       nop          
       brne  d3
       dec   r24
       brne  d2
       dec   r23
       brne  d1
ret


miliSecDelay:
	ldi  r23,10      ; r23 <-- Counter for outer loop
	d10: ldi   r24,255     ; r24 <-- Counter for level 2 loop
	d11: ldi   r25,209   ; r25 <-- Counter for inner loop
	d12: dec   r25          
	brne  d12
	dec   r24
	brne  d11
	;nop
	dec   r23
	brne  d10
	ret

oneSecDelay:
	
	ldi   r23,255      ; r23 <-- Counter for outer loop
	d4: ldi   r24,255     ; r24 <-- Counter for level 2 loop
	d5: ldi   r25,50    ; r25 <-- Counter for inner loop
	d6: dec   r25    
	nop;           ; no operation
	nop
	brne  d6
	nop
	nop
	dec   r24
	brne  d5
	dec   r23
	brne  d4
	ret


debounce4:
	ldi r25,0 ; ones
	ldi r26,0 ;zeroes
	ldi r27,10 ; i
	d7:               ; no operation
		SBIS PINB,4
			inc r26
		SBIC PINB,4
			inc r25
	dec  r27
	brne  d7

	cp r26,r25
	brge pressed4
	;rjmp not_pressed4
	ret


debounce5:
	ldi r25,0 ; ones
	ldi r26,0 ;zeroes
	ldi r27,10 ; i
	d8:               ; no operation
		SBIS PINB,5
			inc r26
		SBIC PINB,5
			inc r25
	dec  r27
	brne  d8

	cp r26,r25
	brge pressed5
	;rjmp not_pressed
	ret


pressed4:
	rjmp L2
pressed5:
	rjmp L1
