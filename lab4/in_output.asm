public space_print
public mtrx_input
public mtrx_print
public newline
;public set_ij1

extrn rows: byte
extrn cols: byte
extrn matrix: byte

DATA_SEG SEGMENT PARA public 'DATA'
	i db ?
	j db ?
DATA_SEG ENDS

CODE_SEG SEGMENT PARA public 'CODE'
	assume CS:CODE_SEG, DS:DATA_SEG
	
space_print proc near
	mov ah, 02h
	mov dl, ' '
	int 21h
	
	ret
space_print endp

newline proc near
	mov ah, 02h
	mov dl, 13		; курсор поместить в нач. строки
	int 21h
	mov dl, 10		; перевести курсор на нов. строку
	int 21h
	
	ret
newline endp

set_ij1 proc near
	mov ax, 0
	mov al, i
	mov si, ax
	mov bx, 0
	mov bl, j
	ret
set_ij1 endp

next_row proc near
	add i, 10
	mov j, 0
	call newline
	
	ret
next_row endp

next_elem proc near
	inc j
	mov al, j
	cmp al, cols
	jne not_next_row
		call next_row
		ret
	not_next_row:
	; inc j
	call space_print
	
	ret
next_elem endp

mtrx_input proc near
	mov ah, 01h ; ввод с эха
	int 21h
	mov rows, al
	sub rows, '0'
	
	call space_print
	
	mov ah, 01h ; ввод с эха
	int 21h
	mov cols, al
	sub cols, '0'
	
	call newline
	
	mov al, rows
	mul cols
	mov cx, ax	; высчитываем кол-во элементов в массива
	
	mov i, 0
	mov j, 0
	read_elem:
		; si = i, bx = j
		call set_ij1
		
		; ввод элемента матрицы
		mov ah, 01h
		int 21h
		mov matrix[si][bx], al
		sub matrix[si][bx], '0'
		
		; переход к следующему элементу
		call next_elem
		
		next_symbol:
			loop read_elem
	ret
mtrx_input endp

mtrx_print proc near
	mov ah, 02h
	call newline
	
	mov dl, rows
	add dl, '0'
	int 21h
	
	mov dl, 'x'
	int 21h
	
	mov dl, cols
	add dl, '0'
	int 21h
	
	call newline
	
	; вывод самой матрицы
	mov al, rows
	mul cols
	mov cx, ax	; высчитываем кол-во элементов в массива
	
	mov i, 0
	mov j, 0
	print_elem:
		call set_ij1
		
		mov ah, 02h
		mov dl, matrix[si][bx]
		add dl, '0'
		int 21h
		call next_elem
		
		next_symbol:
			loop print_elem
	ret
mtrx_print endp
	
CODE_SEG ENDS
END