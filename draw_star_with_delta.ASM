.model 	SMALL
.stack	200h

cent_x equ 320
cent_y equ 160
x1 equ 320
y1 equ 260
x2 equ 345
y2 equ 194
x3 equ 415
y3 equ 188
x4 equ 360
y4 equ 150
x5 equ 380
y5 equ 85
x6 equ 320
y6 equ 120
x7 equ 260
y7 equ 85
x8 equ 280
y8 equ 150
x9 equ 225
y9 equ 188
x10 equ 295
y10 equ 194

Delay MACRO	;delay � assembler 
	mov dx, 73h	;����� �������� � ������������� (������� ����)
	mov cx, 0Ch	;����� �������� � ������������� (������� ����)
	mov ah,	86h	;��� ����� ���������� � ���� "�������"
	int 15h
ENDM

SetXY MACRO x0, xend, y0, yend      ; ���������������� ��� ������ ��������� � �������� ���������
	mov ST_X, x0 
	mov ST_Y, y0  
	mov END_X, xend 
	mov END_Y, yend  
ENDM 

drawStar MACRO delta
	setXY x1, x2-delta*2/5, y1-delta*4/3, y2-delta*3/5
	call drawLine

	setXY x2-delta*2/5, x3-delta*4/3, y2-delta*3/5, y3-delta/3
	call drawLine
	
	setXY x3-delta*4/3, x4-delta*4/5, y3-delta/3, y4+delta/3
	call drawLine

	setXY x4-delta*4/5, x5-delta*4/5, y4+delta/3, y5+delta*4/5
	call drawLine

	setXY x5-delta*4/5, x6, y5+delta*4/5, y6+delta*4/5
	call drawLine

	setXY x6, x7+delta*4/5, y6+delta*4/5, y7+delta
	call drawLine
	
	setXY x7+delta*4/5, x8+delta*4/5, y7+delta, y8+delta/3
	call drawLine

	setXY x8+delta*4/5, x9+delta*4/3, y8+delta/3, y9-delta/3
	call drawLine

	setXY x9+delta*4/3, x10+delta*2/5, y9-delta/3, y10-delta*3/5
	call drawLine

	setXY x10+delta*2/5, x1, y10-delta*3/5, y1-delta*4/3
	call drawLine
ENDM	

.data

	COLOR DB 1
	cycle db 0
	END_X dw ?
	END_Y dw ?
	ST_X dw ?
	ST_Y dw ?
	DI_X_IN DW ?
	DI_Y_IN DW ?
	SH_DI DW ?
	ST_X_IN DW ?
	ST_Y_IN DW ?
	ST_CO DW ?
	DI_CO DW ?

.code

drawLine proc       ; ������� ��������� �����
;���������� ��� ���� � � �
	mov cx, 1
	mov dx, 1
;���������� deltaY
	mov di, END_Y
	sub di, ST_Y	;�������� �� �������� ����� ���������
	jge KEEP_Y	;���� ����������� ����� (������ �������������), ��������� �����
	neg dx		;����� ��������� �� y �������������
	neg di		;��������� - �������������
KEEP_Y:	mov DI_Y_IN,dx
;���������� deltaX
	mov si, END_X
	sub si, ST_X	;�������� �� �������� ����� ���������
	jge KEEP_X	;���� ���� ������ , ��������� �����
	neg cx		;����� ��������� �� x �������������
	neg si		;��������� - �������������
KEEP_X:	mov DI_X_IN,cx
;��������� delta (������������ ������)
	cmp si, di	;���� ��������� �� ����������� ������, ���� � HORIS
	jge HORIS
	mov cx, 0	;����� ��������� ��� � �������
	xchg si, di	;������� ��������� �������� � ������� si
	jmp SAVE
HORIS:	mov dx,0	;��������� ��� y �������
SAVE:	mov SH_DI, di	;��������� ����������
	mov ST_X_IN, cx
	mov ST_Y_IN, dx
;���������� ������
	mov ax, SH_DI	
	shl ax, 1	;�������� ����� �� 1 (�������� �� 2)
	mov ST_CO, ax	;���������� ������� ���������� � ���������
	sub ax, si
	mov bx, ax	; ���������� ������� �����
	sub ax, si	;2x������� ����� - 2x�������
	mov DI_CO, ax	;���������� ������
;��������� � ��������� ����������, ����� ����� � ��
	mov cx, ST_X
	mov dx, ST_Y
	inc si
	mov al, COLOR
;����� �����
MLOOP:	dec si
	jz FINISH	;����� ����� ��������� �����
	mov ah, 12	;����� �����
	int 10h
	cmp bx,0	;���� ������ �������, �� ������� ������
	jge DILIN	;�����, ������� � ����� ��� ���������� ��������
;��� �������������� ������
	add cx, ST_X_IN
	add dx, ST_Y_IN
	add bx, ST_CO
	jmp SHORT MLOOP
;��� ��������� ������
DILIN:	add cx, DI_X_IN
	add dx, DI_Y_IN
	add bx, DI_CO
	jmp SHORT MLOOP
;���������� ���������
FINISH: ret
drawLine endp

main proc
	mov ax, @data
	mov ds, ax
	mov Ah, 0
        mov Al, 10H
	int 10h    ;��������� �����������
	
	mov ah, 0Bh
	mov bh, 0
	mov bl, 0
	int 10h		
	mov ah, 0Bh	
	mov bh, 1
	mov bl, 0
	int 10h		;������������� ������/������/���������� �����
	mov  dx,0
	mov  ah,02h            ; ������������� ������
   	int  10h

	wow:
	inc COLOR
	inc cycle
	drawStar 0
	drawStar 5
	drawStar 10
	drawStar 15
	drawStar 20
	drawStar 25
	drawStar 30
	drawStar 35
	drawStar 40
	drawStar 45
	drawStar 50
	Delay
	cmp cycle, 16
	je Endstar	
	jmp wow
 
Endstar:
	mov ah,	1    ;������� ������� ���� ������� (��� getch � ��)
	int 21h
	mov ah, 4Ch
	int 21h
	
	
main endp
end main
