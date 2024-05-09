; EXTRN - объявляет соответствующее имя внешним для текущего ассемблирования
EXTRN output_X: near

STK SEGMENT PARA STACK 'STACK'	; PARA - выравнивание адреса кратного 16
	db 100 dup(0)	; создает массив из 100 байт проинициализорованных 0
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	X db 'R'	; создает переменную Х - 1 байт и определяет ее 'R'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
main:
	mov ax, DSEG
	mov ds, ax

	call output_X	; вызов процедуры output_X

	mov ax, 4c00h	; завершение программы
	int 21h
CSEG ENDS

PUBLIC X

END main