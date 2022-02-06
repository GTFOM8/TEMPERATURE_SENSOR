.include "m16def.inc"
.cseg
.org 0

;---------------------------------STACK SETTING-----------------------------------
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16

;--------------------------------I/O REGISTER SETTING-----------------------------

ldi r16, 0xff
out DDRB, r16
ldi r16, 0xff
out DDRD, r16
;-------------------------INITIALIZATION-------------------------------
call p20000mks
call p20000mks
call p20000mks
call p20000mks
ldi r16, 0

ldi r17, 0b00110000
call write
call p20000mks

ldi r17, 0b00110000
call write
call p20000mks

ldi r17, 0b00110000
call write
call p20000mks

ldi r17, 0b00100000
call write
call p20000mks

ldi r17, 0b00100000
call write
call p20000mks

ldi r17, 0b11000000
call write
call p20000mks

ldi r17, 0
call write
call p20000mks

ldi r17, 0b10000000
call write
call p20000mks

ldi r17, 0
call write
call p20000mks

ldi r17, 0b00010000
call write
call p20000mks

ldi r17, 0
call write
call p20000mks

ldi r17, 0b01100000
call write
call p20000mks

ldi r17, 0
call write
call p20000mks

ldi r17, 0b11000000
call write
call p20000mks

ldi r17, 0
call write
call p20000mks

ldi r17, 0b00010000
call write
call p20000mks

;--------------------------------------------------SENSOR SETTING-----------------------------
begin:
ldi r27, 0

start:
ldi r16, 0b00001111
out ddrd, r16
cbi portd, 3
call p25ms
sbi portd, 3
ldi r16, 0b00000111
out ddrd, r16

jmp go

restart:
call p250ms
call p250ms
call p250ms
call p250ms
jmp start

go:
call p60mks
sbis pind, 3
jmp povdel
jmp restart

povdel:
call p60mks
sbis pind, 3
jmp start
jmp read00

read00:
sbis pind, 3
jmp re0
jmp read00

re0:
sbis pind, 3
jmp re0
call p32mks
sbis pind, 3
jmp per00
jmp per10

per00:
clc
rol r17
inc r27
cpi r27, 8
brne read00
mov r22, r17
rjmp read1

per10:
sec
rol r17
b1:
sbis pind, 3
rjmp b2
rjmp b1

b2:
inc r27
cpi r27, 8 
brne read00
mov r22, r17
rjmp read1

;-------------------------------AIR HUMIDITY----------------------------------------
read1:
ldi r27, 0

read01:
sbis pind, 3
jmp re1
jmp read01

re1:
sbis pind, 3
jmp re1
call p32mks
sbis pind, 3
jmp per01
jmp per11

per01:
clc 
rol r17
inc r27
cpi r27, 8
brne read01
mov r23, r17
jmp read2

per11:
sec
rol r17
b11:
sbis pind, 3
rjmp b21
rjmp b11

b21:
inc r27
cpi r27, 8
brne read01
mov r23, r17
jmp read2

;---------------------------------TEMPERATURE----------------------------------------
read2:
ldi r27, 0

read02:
sbis pind, 3
jmp re2
jmp read02

re2:
sbis pind, 3
jmp re2
call p32mks
sbis pind, 3
jmp per02
jmp per12

per02:
clc
rol r17
inc r27
cpi r27, 8
brne read02
mov r24, r17
jmp read3

per12:
sec
rol r17
b111:
sbis pind, 3
jmp b211
jmp b111

b211:
inc r27
cpi r27, 8
brne read02
mov r24, r17
jmp read3


read3:
ldi r27,0
read03:
sbis pind, 3
jmp R_3
jmp read03

R_3:
sbis pind, 3
jmp R_3
call p32mks
sbis pind, 3
jmp per03
jmp per13

per03:
clc
rol r17
inc r27
cpi r27, 8
brne read03
mov r25, r17
jmp read4

per13:
sec
rol r17
b1111:
sbis pind, 3
jmp b2111
jmp b1111

b2111:
inc r27
cpi r27, 8
brne read03
mov r25, r17
rjmp read4

read4: nop

;----------------------------------------FIRST LINE SETTING------------------------------------------
ldi r16, 0
ldi r17, 0x80
call write
call p40mks
swap r17
call write
call p40mks

string1:
ldi r16, 0b00000001
ldi r17, 'T'
call write
swap r17
call write
ldi r17, '='
call write
swap r17
call write

mov r28, r24
call pr2v210
mov r17, r30
ldi r28, 0x30
add r17, r28
call write
swap r17
call write

mov r17, r29
ldi r28, 0x30
add r17, r28
call write
swap r17
call write

ldi r17, 0xdf
call write
swap r17
call write
ldi r17, 'C'
call write
swap r17
call write

;------------------------------------SECOND LINE SETTING---------------------------------------------------
ldi r16, 0
ldi r17, 0xC0
call write
call p40mks
swap r17
call write
call p40mks

string2:
ldi r16, 0b00000001
ldi r17, 'H'
call write
swap r17
call write
ldi r17, '='
call write
swap r17
call write

;---------------------------------------------HUMIDITY VALUE DISPLAY-------------------------
mov r28, r22
call pr2v210
mov r17, r30
ldi r28, 0x30
add r17, r28
call write
swap r17
call write

mov r17, r29
ldi r28, 0x30
add r17, r28
call write
swap r17
call write

ldi r17, '%'
call write
swap r17
call write

jmp begin

;конвертация

pr2v210:
clr r30
bBCD8_1:
subi r28, 10
brcs bBCD8_2
inc r30
jmp bBCD8_1
bBCD8_2:
subi r28, -10
mov r29,r28
ret

;------------------------------------TIMER 20mks------------------------------------

p20000mks:
ldi r18, 236
ldi r19, 0b00000101
jmp delay

;---------------------------------------------DISPLAYING VALUES-------------------------
write:
out portd, r16
out portb, r17
nop
sbi portd, 2
nop
call p40mks
cbi portd, 2
nop
call p40mks
ret

;------------------------------------PAUSES------------------------------------

p250ms:
ldi r18, 2
ldi r19, 0b00000101
jmp delay

p25ms:
ldi r18, 231
ldi r19, 0b00000101
jmp delay

p27mks:
ldi r18, 253
ldi r19, 0b00000001
jmp delay

p32mks:
ldi r18, 243
ldi r19, 0b00000001
jmp delay

p40mks:
ldi r18, 238
ldi r19, 0b00000001
jmp delay

p60mks:
ldi r18, 221
ldi r19, 0b00000001
jmp delay

delay:
out TCNT0, r18
out TCCR0, r19
ffff:
in r18, TIFR
sbrs r18, 0
jmp ffff
ldi r20, 0
out TCCR0, r20
ldi r21, 0b00000001
out TIFR, r21
ret