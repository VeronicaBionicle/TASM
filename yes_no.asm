DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
Time DB 'Eto wremja posle poludnja? [Y/N]$';сообщение с символами перевода строки, возврата каретки и окончания строки (терминатора)
GoodMorn DB 13, 10, 'Dobroje utro!',13,10,'$'
GoodAftern DB 13,10,'Sdrawstwuite!', 13,10,'$'

.CODE
main proc
	mov ax, @Data	;загрузка адреса сегмента данных 
	mov ds, ax
	mov dx, OFFSET Time	;ссылка на сообщение
	mov ah, 9
	int 21h		;вывод сообщения
	mov ah, 01
	int 21h
	cmp al, 'Y'
	jz IsAftern
	cmp al, 'N'
	jz IsMorn
IsAftern:
	mov dx, OFFSET GoodAftern
	jmp Displ
IsMorn:
	mov dx, OFFSET GoodMorn
Displ:
	mov ah, 9
	int 21h		;вывод сообщения
	mov ah, 01
	int 21h
	mov ah, 4Ch	;функция завершения программы
	int 21h	;выполнение функции
main endp
end main