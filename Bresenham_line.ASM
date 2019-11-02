DOSSEG
.MODEL SMALL
.STACK 100h

SetXY MACRO x0, xend, y0, yend       ; макроопределение
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
FINISH:	ret
drawLine endp

main proc
;загрузка адреса сегмента данных 
	mov ax, @Data	
	mov ds, ax
;видеорежим
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
