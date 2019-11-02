DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
CWET DB 0
X DW 0
Y DW 0
N DW 400

.CODE
main proc
	mov ax, @Data	;загрузка адреса сегмента данных 
	mov ds, ax
	mov ah, 00	;видеорежим
	mov al, 12h
	int 10h
M1:	mov ah, 0Ch
	mov al, CWET
	mov bh, 00
	mov cx, X
	mov dx, Y
	int 10h
	inc CWET
	and CWET, 0Fh	
	inc X
	inc Y
	dec N
	jnz M1
	mov ah, 01h
	int 21h
	mov ah, 4Ch	;функция завершения программы
	int 21h	;выполнение функции
main endp
end main