DOSSEG
.MODEL SMALL
.STACK 100h

SetXY MACRO x0, xend, y0, yend       ; ����������������
	mov ST_X, x0    
	mov ST_Y, y0    
	mov END_X, xend  
	mov END_Y, yend   
ENDM 


.DATA
ST_X DW 0
END_x DW 319

ST_Y DW 0
END_Y DW 199

COLOR DB 1      ;1 - red

DI_X_IN DW ?
DI_Y_IN DW ?

SH_DI DW ?
ST_X_IN DW ?
ST_Y_IN DW ?
ST_CO DW ?
DI_CO DW ?

.CODE

drawLine proc
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
FINISH:	ret
drawLine endp

main proc
;�������� ������ �������� ������ 
	mov ax, @Data	
	mov ds, ax
;����������
	mov ah, 0
        mov al, 4
	int 10h

	call drawLine
	
  	mov COLOR, 2
	setXY 160, 160, 100, 210
	call drawLine

	mov ah, 01h
	int 21h
	mov ah, 4Ch	
	int 21h
main endp

end main
