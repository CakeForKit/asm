; lab 4
; ввод и вывод матрицы 9х9
; прямоугольная цифровая
; поменять местами первый элемент каждого столбца
; с максимальным


extrn mtrx_input: near
extrn mtrx_print: near
extrn newline: near
extrn changre_max_elem: near
public rows
public cols
public matrix

STK SEGMENT PARA STACK USE16 'STACK'
    db 100 dup (?)
STK ENDS

DATA_SEG SEGMENT PARA public 'DATA'
	mword db 0
	mdword dd 1
	rows db '0'
	cols db '0'
	matrix db 81 dup (0)
DATA_SEG ENDS

CODE_SEG SEGMENT PARA public 'CODE'
	assume CS:CODE_SEG, DS:DATA_SEG
main:
	mov ax, DATA_SEG
	mov ds, ax
	
	mov mword, 1
	mov ax, word ptr mdword
	
	call mtrx_input
	call changre_max_elem
	call mtrx_print
	
	mov ax, 4c00h ; завершаем программу
	int 21h

CODE_SEG ENDS
END main
	
	
	
	