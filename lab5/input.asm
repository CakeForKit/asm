;.386
public input_num
public num
extrn newline: near
extrn menu_loop: near


DATA_SEG SEGMENT PARA public USE16 'DATA'
	prompt_to_enter db 10, 13, "Input bin num ([+- ]([01])*15): $"
	num_err db 10, 13, "ERROR: wrong num$"
DATA_SEG ENDS

DATA_SEG SEGMENT PARA public USE16 'DATA'
	max_size db 17
	len db 0
	num_str db 17 dup('$')
	
	num dw 0
	db '$'
DATA_SEG ENDS

CODE_SEG SEGMENT PARA public USE16 'CODE'
	assume CS:CODE_SEG, DS:DATA_SEG
input_num proc near
	; зануляем num для начала ввода
	mov num, 0

	mov ah, 09h
	mov dx, offset prompt_to_enter
	int 21h
	
	mov ah, 0Ah
	mov dx, offset max_size
	int 21h
	
	call newline
	
	; si = 0, cx = len
	mov cx, 0
	mov cl, len
	mov si, 0
	
	; пропустим знак если есть
	cmp num_str[si], '+'
	je pass_sign
	cmp num_str[si], '-'
	je pass_sign
	cmp len, 16		; введено 16 бит без знака
	jne for_bit_in_num_loop
	mov dx, offset num_err
	call error_out
	jmp for_bit_in_num_loop
	pass_sign:
		add si, 1
		sub cx, 1
	
	for_bit_in_num_loop:
		sub num_str[si], '0'
		cmp num_str[si], 0
		je good_num
		cmp num_str[si], 1
		je good_num
		bad_num:
			mov dx, offset num_err
			call error_out
			
		good_num:
		shl num, 1 ; лог сдвиг влево num на 1 (num * 2)
		mov ax, 0
		mov al, num_str[si]
		add num, ax	; num += num_str[si]
		
		add si, 1
		loop for_bit_in_num_loop
	
	cmp num_str[0], '-'
	jne not_negative_num
	not num
	add num, 1
	
	not_negative_num:

	ret
input_num endp

error_out proc near
	mov ah, 09h
	int 21h
	jmp menu_loop
error_out endp
CODE_SEG ENDS
END