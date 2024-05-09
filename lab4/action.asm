; поменять местами первый элемент каждого столбца
; с максимальным
public changre_max_elem

extrn rows: byte
extrn cols: byte
extrn matrix: byte
;extrn set_ij: near


DATA_SEG SEGMENT PARA public 'DATA'
	i db ?
	j db ?
	imax db ?
	max db ?
	tmp db ?
DATA_SEG ENDS


CODE_SEG SEGMENT PARA public 'CODE'
	assume CS:CODE_SEG, DS:DATA_SEG
	
set_ij proc near
	mov ax, 0
	mov al, i
	mov si, ax
	mov bx, 0
	mov bl, j
	ret
set_ij endp
	
set_max proc near
	; устанавливаем max = maxtrix[i][j]
	call set_ij
	mov al, matrix[si][bx]
	mov max, al
	mov al, i
	mov imax, al
	
	ret
set_max endp

find_max_elem proc near
	push bp
	mov bp, sp
	
	; в j должно быть уже установлено какой столбец рассматрицаем
	mov i, 0
	call set_max	; устанавливаем max = maxtrix[0][j]
	
	; проходимся по столбцу
	mov cx, 0
	mov cl, rows
	see_new_elem:	
		; if matrix[i][j] > max: max = matrix[i][j]
		call set_ij
		mov al, max
		cmp matrix[si][bx], al
		ja set_max_and_back
		go_back:
		
		add i, 10
		loop see_new_elem
	
;	mov ah, 02h
;	mov dl, max
;	add dl, '0'
;	int 21h
	
	mov cx, [bp + 4] ;  считать верхний параметр стека
	; +4 т к 2 байта на адресс возврата (near) и 2 байта bp
	pop bp
	ret
	
	set_max_and_back:
		call set_max
		jmp go_back
	
find_max_elem endp

change_frst_max_elem_in_col proc near
	; в j должно быть уже установлено какой столбец рассматрицаем
	mov i, 0
	call set_ij
	mov al, matrix[si][bx]	; tmp = maxtrix[0][j]
	mov tmp, al				
	mov al, max				; maxtrix[0][j] = max
	mov matrix[si][bx], al
	
	mov al, imax
	mov i, al
	call set_ij
	mov al, tmp				; matrix[imax][j] = tmp
	mov matrix[si][bx], al

	ret
change_frst_max_elem_in_col endp
	
changre_max_elem proc near
;	mov ah, 02h
;	mov dl, 'a'
;	int 21h
	
	mov cx, 0
	mov cl, cols
	mov j, 0
	
	next_col:
		; сохраняем значение cx в стек
		push cx		; сохраняю в стек занчение cx
		
		call find_max_elem
		
		add sp, 2	; освобождаю стек от параметров
		
		call change_frst_max_elem_in_col
		
		add j, 1
		loop next_col
	
	ret
changre_max_elem endp
	
CODE_SEG ENDS
END