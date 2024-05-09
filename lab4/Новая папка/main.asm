; lab 4
; ввод и вывод матрицы 9х9
; прямоугольная цифровая
; поменять местами первый элемент каждого столбца
; с максимальным

extrn space_print: near
extrn print_mtrx: near

MTRX_SEG SEGMENT PARA common 'DATA'
	rows db '0'
	cols db '0'
	matrix db 81 dup ('0')
MTRX_SEG ENDS

CODE_SEG SEGMENT PARA public 'CODE'
	assume CS:CODE_SEG, DS:MTRX_SEG
main:
	mov ax, MTRX_SEG
	mov ds, ax
	
	mov ah, 01h ; ввод с эха
	int 21h
	mov rows, al
	
	call space_print
	
	mov ah, 01h ; ввод с эха
	int 21h
	mov cols, al
	
	call mtrx_print
	
	mov ax, 4c00h ; завершаем программу
	int 21h

CODE_SEG ENDS
END main
	
	
	
	