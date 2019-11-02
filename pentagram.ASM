.model 	SMALL
.stack	200h

SetXY MACRO x0, xend, y0, yend       ; макроопределение для записи начальных и конечных координат
	mov ST_X, x0    
	mov ST_Y, y0    
	mov END_X, xend  
	mov END_Y, yend   
ENDM 

Delay MACRO
	mov dx, 73h
	mov cx, 0Ch
	mov ah,	86h
	int 15h
ENDM

Love MACRO Message
	mov  bl,0Ah          ; на чёрном фоне(0), красные символы(A)
	mov dx, OFFSET Message	;ссылка на сообщение
	mov ah, 9
	int 21h		;вывод сообщения
ENDM

.data
Mes db 03h,03h,03h,'Go to hell, for heaven`s sake...',03h,03h,03h,13,'$'
;Heart db 03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h, 13,'$'
	COLOR DB 1
	eror dw ?
	END_X dw ?
	END_Y dw ?
	ST_X dw ?
	ST_Y dw ?
	delta dw ?
	radius dw ?

DI_X_IN DW ?
DI_Y_IN DW ?
SH_DI DW ?
ST_X_IN DW ?
ST_Y_IN DW ?
ST_CO DW ?
DI_CO DW ?

.code

drawLine proc
;инкременты для осей х и у
	mov cx, 1
	mov dx, 1
;вычисление deltaY
	mov di, END_Y
	sub di, ST_Y	;вычитаем из конечной коорд начальную
	jge KEEP_Y	;если поднимаемся вверх (наклон положительный), сохраняем сразу
	neg dx		;иначе инкремент по y отрицательный
	neg di		;дистанция - положительная
KEEP_Y:	mov DI_Y_IN,dx
;вычисление deltaX
	mov si, END_X
	sub si, ST_X	;вычитаем из конечной коорд начальную
	jge KEEP_X	;если идем вправо , сохраняем сразу
	neg cx		;иначе инкремент по x отрицательный
	neg si		;дистанция - положительная
KEEP_X:	mov DI_X_IN,cx
;сравнение delta (определяется наклон)
	cmp si, di	;если дистанция по горизонтали больше, идем в HORIS
	jge HORIS
	mov cx, 0	;иначе инкремент для х нулевой
	xchg si, di	;большую дистанцию помещаем в регистр si
	jmp SAVE
HORIS:	mov dx,0	;инкремент для y нулевой
SAVE:	mov SH_DI, di	;сохраняем инкременты
	mov ST_X_IN, cx
	mov ST_Y_IN, dx
;вычисление ошибки
	mov ax, SH_DI	
	shl ax, 1	;сдвигаем влево на 1 (умножаем на 2)
	mov ST_CO, ax	;запоминаем меньшее расстояние и удваиваем
	sub ax, si
	mov bx, ax	; запоминаем счетчик цикла
	sub ax, si	;2xменьшее расст - 2xбольшее
	mov DI_CO, ax	;запоминаем ошибку
;установка в начальную координату, выбор цвета и тд
	mov cx, ST_X
	mov dx, ST_Y
	inc si
	mov al, COLOR
;вывод точки
MLOOP:	dec si
	jz FINISH	;выход после последней точки
	mov ah, 12	;вывод точки
	int 10h
	cmp bx,0	;если наклон нулевой, то сегмент прямой
	jge DILIN	;иначе, прыгаем в часть для наклонного сегмента
;для горизонтальной прямой
	add cx, ST_X_IN
	add dx, ST_Y_IN
	add bx, ST_CO
	jmp SHORT MLOOP
;для наклонной прямой
DILIN:	add cx, DI_X_IN
	add dx, DI_Y_IN
	add bx, DI_CO
	jmp SHORT MLOOP
;завершение программы
FINISH: ret
drawline endp 

Plot proc
	mov Ah, 0Ch		;Функция отрисовки точки
	mov al, COLOR		;Цвет
	int 10h			;Нарисовать точку
	ret
Plot endp


drawCircle proc
        mov END_X, 0
	mov ax, radius
        mov END_Y, ax
        mov delta, 2
	mov ax, 2
	mov dx, 0
	imul END_Y
	sub delta, ax
	mov eror, 0
	jmp ccicle
finally: ret
ccicle:
	mov ax, END_Y
	cmp ax, 0
	jl  finally
	mov cx, ST_X
	add cx, END_X
	mov dx, ST_Y
	add dx, END_Y
	call Plot
        mov cx, ST_X
	add cx, END_X
	mov dx, ST_Y
	sub dx, END_Y
	call Plot
	mov cx, ST_X
	sub cx, END_X
	mov dx, ST_Y
	add dx, END_Y
	call Plot
	mov cx, ST_X
	sub cx, END_X
	mov dx, ST_Y
	sub dx, END_Y
	call Plot
	mov ax, delta
	mov eror, ax
	mov ax, END_Y
	add eror, ax
	mov ax, eror
	mov dx, 0
	mov bx, 2
	imul bx
	sub ax, 1
	mov eror, ax
	cmp delta, 0
	jg sstep
	je sstep
	cmp eror, 0
	jg  sstep
	inc END_X
	mov ax, 2
	mov dx, 0
	imul END_X
	add ax, 1
	add delta, ax
        jmp ccicle
sstep:
	mov ax, delta
	sub ax, END_X
	mov bx, 2
	mov dx, 0
	imul bx
	sub ax, 1
	mov eror, ax
	cmp delta, 0
	jg tstep
	cmp eror, 0
	jg tstep
	inc END_X
	mov ax, END_X
	sub ax, END_Y
	mov bx, 2
	mov dx, 0
	imul bx
	add delta, ax
        dec END_Y
	jmp ccicle
tstep:
	dec END_Y
        mov ax, 2
	mov dx, 0
	imul END_Y
	mov bx, 1
	sub bx, ax
	add delta, bx
	jmp ccicle
drawCircle endp

penta proc
	setXY 160, 210, 150, 112
	call drawLine

	setXY 210, 190, 112, 60
	call drawLine

	setXY 190, 130, 60, 60
	call drawLine

	setXY 130, 110, 60, 112
	call drawLine

	setXY 110, 160, 112, 150
	call drawLine

	setXY 160, 190, 150, 60
	call drawLine

	setXY 190, 110, 60, 112
	call drawLine

	setXY 110, 210, 112, 112
	call drawLine

	setXY 210, 130, 112, 60
	call drawLine

	setXY 130, 160, 60, 150
	call drawLine

        mov radius, 50    ;Радиус нашего круга.
	setXY 160, 0, 100, 0
	call DrawCircle

        mov radius, 60    ;Радиус нашего круга.
	call DrawCircle
	
	ret
penta endp


main proc
	mov ax, @data
	mov ds, ax
	mov Ah, 0
        mov Al, 4
	int 10h    ;Включение видеорежима
	
	mov ah, 0Bh
	mov bh, 0
	mov bl, 0
	int 10h		
	mov ah, 0Bh	
	mov bh, 1
	mov bl, 0
	int 10h		;устанавливаем зелено/красно/коричневый режим
	
	mov  dx,0
	mov  ah,02h            ; позиционируем курсор
   	int  10h

	mov COLOR, 2

	Love Mes
	call penta

	mov ah,	1    ;Функция захвата кода клавиши
	int 21h
	mov ah, 4Ch
	int 21h
	
	
main endp
end main
