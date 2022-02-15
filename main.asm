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
ldi R16,0xEF
push R16
ldi R16, 0xFF
push R16
ldi R16,0x87
push R16
ldi R16,0xFD
push R16
ldi R16,0xED
push R16
ldi R16,0xE6
push R16
ldi R16,0xCF
push R16
ldi R16,0xDB
push R16
ldi R16,0x86
push R16
ldi R16,0xBF
push R16

; start main program

;rcall miliSecDelay

; display a digit 
ldi R16,0x3F;0
ldi R20,0xBF
	;pop R20
	rcall display
	
;rcall pause


L1: 
	

SBIS PINB,4
rjmp L2
;ldi R16,0x67

ldi R29,9
	;rcall oneSecDelay
	;ldi R18,0x07 ;0
	;rcall display2
	;rcall effeciency
	ldi R30,0
	rjmp L1
	

L2: 
ldi R21,1
test:
cpi R29,9
breq set0
back0:
cpi R29,8
breq set1
back1:
cpi R29,7
breq set2
back2:
cpi R29,6
breq set3
back3:
cpi R29,5
breq set4
back4:
cpi R29,4
breq set5
back5:
cpi R29,3
breq set6
back6:
cpi R29,2
breq set7
back7:
cpi R29,1
breq set8
back8:
cpi R29,0
breq set9
back9:
dec R29

ldi R16, 0x06 ; load pattern to display
rcall display ; call display subroutine
rcall miliSecDelay
rcall effeciency

ldi R16, 0x5B ; load pattern to display
rcall display
rcall miliSecDelay
rcall effeciency

ldi R16, 0x4F ; load pattern to display
rcall display
rcall miliSecDelay
rcall effeciency

ldi R16, 0x66 ; load pattern to display
rcall display
rcall miliSecDelay
rcall effeciency

ldi R16, 0x6D; load pattern to display
rcall display
rcall miliSecDelay
rcall effeciency

ldi R16, 0x7D ; load pattern to display
rcall display
rcall effeciency
rcall miliSecDelay

ldi R16, 0x07 ; load pattern to display
rcall display
rcall miliSecDelay
rcall effeciency

ldi R16, 0x7F ; load pattern to display
rcall display
rcall miliSecDelay
rcall effeciency



;SBIS PINB,4    will try to move in some loop 
;rjmp L2

ldi R16, 0x67 ; load pattern to display
rcall display
rcall miliSecDelay
brne test
cpi R30,1
breq flash
rjmp L2

set0:
	ldi R20,0xBF
	;dec R23
	rjmp back0
set1:
	ldi R20,0x86
	;dec R23
	rjmp back1
set2:
	ldi R20,0xDB
	;dec R23
	rjmp back2
set3:
	ldi R20,0xCF
	;dec R23
	rjmp back3
set4:
	ldi R20,0xE6
	;dec R23
	rjmp back4
set5:
	ldi R20,0xED
	;dec R23
	rjmp back5
set6:
	ldi R20,0xFD
	;dec R23
	rjmp back6

set7:
	ldi R20,0x87
	;dec R23
	rjmp back7

set8:
	ldi R20,0xFF
	;dec R23
	rjmp back8
set9:
	ldi R20,0x67
	;dec R23
	ldi R30,1
	
	rjmp back9

flash:
	ldi R16,0x00
	ldi R20, 0x00
	rcall display
	rcall TwoSecDelay
	ldi R16,0x67
	ldi R20,0x67
	rcall display
	rcall TwoSecDelay
	rjmp flash

effeciency:
	
	rcall debounce4
	rcall debounce5


display: 
; backup used registers on stack

	   
	  ;  ldi R17, 8 ; loop --> test all 8 bits
       
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
      ; rcall delay_long
       cbi PORTB,2
       dec R17
       brne loop
	   ;ldi R16,0xBF
	  ; push R16
	   ldi R19, 8
	   mov R18,R20
	   rcall load
	  ; rcall Noload
       ;put code here to generate RCLK pulse
              sbi PORTB,1
              ;rcall delay_long
              cbi PORTB,1

       ;restore registers from stack
       
       ret
intermediate:
	rjmp L2

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

TwoSecDelay:
	
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

	/*ldi   r23,255      ; r23 <-- Counter for outer loop
	d20: ldi   r24,255     ; r24 <-- Counter for level 2 loop
	d21: ldi   r25,50    ; r25 <-- Counter for inner loop
	d23: dec   r25    
	nop;           ; no operation
	nop
	brne  d23
	nop
	nop
	dec   r24
	brne  d21
	dec   r23
	brne  d20*/
	ret


debounce4:
	ldi r25,0 ; ones
	ldi r26,0 ;zeroes
	ldi r27,10 ; i
	d7:               
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
	cpi R21,0
	breq intermediate
	
	rjmp pause
pressed5:
	rjmp L1

load:	
		;pop R18
        rol R18              ; rotate left trough Carry
		;rol R18
       BRCS set_ser_in_12    ; branch if Carry is set
       ; put code here to set SER to 0 ...
       cbi PORTB,3
       rjmp end2


set_ser_in_12:
; put code here to set SER to 1...
       sbi PORTB,3
end2: 
; put code here to generate SRCLK pulse...
       sbi PORTB,2
      ; rcall delay_long
       cbi PORTB,2
       dec R19
       brne load
	   ret
pause:
	ldi R21,0
	SBIS PINB,4
	ret
	rjmp pause
