public space_print
public mtrx_print

MTRX_SEG SEGMENT PARA common 'DATA'
MTRX_SEG ENDS

CODE_SEG SEGMENT PARA public 'CODE'
	assume CS:CODE_SEG DS:MTRX_SEG
	
space_print proc near
	mov ah, 02h
	mov dl, ' '
	int 21h
	
	ret
space_print endp

mtrx_print proc near
	mov ah, 02h
	mov dl, rows
	int 21h
	mov dl, 'x'
	int 21h
	mov dl, cols
	int 21h
	
	ret
mtrx_print endp
	
CODE_SEG ENDS
END