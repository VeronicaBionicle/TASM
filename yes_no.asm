DOSSEG
.MODEL SMALL
.STACK 100h

.DATA
Time DB 'Eto wremja posle poludnja? [Y/N]$';��������� � ��������� �������� ������, �������� ������� � ��������� ������ (�����������)
GoodMorn DB 13, 10, 'Dobroje utro!',13,10,'$'
GoodAftern DB 13,10,'Sdrawstwuite!', 13,10,'$'

.CODE
main proc
	mov ax, @Data	;�������� ������ �������� ������ 
	mov ds, ax
	mov dx, OFFSET Time	;������ �� ���������
	mov ah, 9
	int 21h		;����� ���������
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
	int 21h		;����� ���������
	mov ah, 01
	int 21h
	mov ah, 4Ch	;������� ���������� ���������
	int 21h	;���������� �������
main endp
end main