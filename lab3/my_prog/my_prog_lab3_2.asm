public diff_ab
;EXTERN A: byte
;EXTERN B: byte


DSEG SEGMENT PARA common 'DATA'
	A label byte
	org 1h
	B label byte
DSEG ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:DSEG
diff_ab proc near
	mov al, A
	mov ah, B
	sub al, ah
	add al, '0' ;48
	mov DL, al
	mov AH, 02h
	int 21h
	
	ret
diff_ab endp
SC1 ENDS
END
