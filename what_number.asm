.model 	SMALL
.stack	200h

.data
beep db 'Beep!',13,10,'$'
number db ?

.code
Delay proc	;delay assembler 
	mov cx, 13h	;high byte
	mov dx, 18h	;low byte	
	mov ah,	86h	;for "wait" cx:dx microseconds
	int 15h
	ret
Delay endp	;this delay is 5 ms

WriteMessage proc
	mov ah, 9
	mov dx, OFFSET beep	
	int 21h		;write message
	call Delay
	ret
WriteMessage endp

main proc
	mov ax, @Data	
	mov ds, ax

	mov ah, 00h	;change video mode
	mov al, 10h
	int 10h

	mov ah, 00h
	int 16h	;catch key

	and al, 00001111b ;turn ascii code to "int" digit (al-30)
	mov bl, 00h	;clear bl
	mov number, al	;save digit, because Delay "break" al
boop:		;write message for number times
	cmp bl, number
	jge fin
	call WriteMessage
	inc bl
	jmp boop
fin:
	mov ah,	1    ;getch
	int 21h
	mov ah, 4Ch
	int 21h
main endp
end main
