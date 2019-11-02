.model 	SMALL
.stack	200h

SetXYRadius MACRO x0, y0, rad      ; макроопределение для записи начальных и конечных координат
	mov X_C, x0 
	mov Y_C, y0  
	mov RADIUS, rad  
ENDM 

Point MACRO color, x, y
	mov al, color		;Цвет
	mov cx, x     ;Горизонтальная координата
	mov dx, y      ;Вертикальная координата
	call PlotPoint
ENDM

.data
	cycle dw 0
	COLOR db 4
	ANGLE dw 0
	X_C dw ?
	Y_C dw ?
	RADIUS dw ?
	X_RESULT dw ?
	Y_RESULT dw ?
	ANGLE_DELTA dw 1
	
.code
PlotPoint proc	   
	mov ah, 0Ch		;Функция отрисовки точки
	mov bh, 00h
	int 10h			;Нарисовать точку
	ret
PlotPoint endp

PlotCircle proc
	.486
	my_for:
		;find x
		fild ANGLE
		fcos
		fimul RADIUS
		fiadd X_C
		frndint
		fistp X_RESULT
		;find y
		fild ANGLE
		fsin
		fimul RADIUS
		fiadd Y_C
		frndint
		fistp Y_RESULT
		Point COLOR, X_RESULT, Y_RESULT
		;increase angle
		fild ANGLE
		fiadd ANGLE_DELTA
		fistp ANGLE
		inc cycle
		cmp cycle, 360	;~360 points for each gradus
		je end_for	
		jmp my_for
	end_for:
		Point 5, X_C, Y_C	;center
		ret
PlotCircle endp

main proc
	mov ax, @data
	mov ds, ax

	mov ah, 00h
    mov al, 10h ; цвета от 0-15
	int 10h    ;Включение видеорежима
	
	finit	;init coprocessor

	SetXYRadius 320, 175, 100
	call PlotCircle
	SetXYRadius 420, 175, 50
	call PlotCircle
	SetXYRadius 320, 275, 2
	call PlotCircle

end_main:
	mov ah,	1    ;getch
	int 21h
	mov ah, 4Ch
	int 21h
main endp
end main
