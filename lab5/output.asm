;.386
public newline
public print_unsigned_16sc
public print_8bit_signed_10sc
public print_min_deg2_gt_num
extrn num: word

DATA_SEG SEGMENT PARA public USE16 'DATA'
	text_u16 db 10, 13, "unsigned 16 s/c: $"
	num16 db "0000$"
	tmpnum dw 0
	
	text_8s10 db 10, 13, "8bit signed 10 s/c: $"
	num8 db 0
	str_num8 db "+000$"
	
	text_min_deg2 db 10, 13, "min degree 2 > unsigned num: $"
	deg db "00$"
DATA_SEG ENDS


CODE_SEG SEGMENT PARA public USE16 'CODE'
	assume CS:CODE_SEG, DS:DATA_SEG
newline proc near
	mov ah, 02h
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
	ret
newline endp

print_unsigned_16sc proc near
	mov ax, num
	mov tmpnum, ax
	
	mov ah, 09h
	mov dx, offset text_u16
	int 21h
	
	mov si, 3
	mov cx, 4
	
	for_bit_num_loop:
		mov ax, 0Fh
		and ax, tmpnum
		
		cmp al, 0Ah
		jae its_alpha
		add al, '0'
		jmp next
		its_alpha:
			add al, 55	; 10 + 55 = 65(10)-> 41(16) -> 'A'
			
		next:
		mov num16[si], al		
		
		sub si, 1
		mov ax, cx
		mov cx, 0
		mov cl, 4
		shr tmpnum, cl ; лог сдвиг вправо на 1
		mov cx, ax
		loop for_bit_num_loop
		
	mov ah, 09h
	mov dx, offset num16
	int 21h
	
	call newline
	ret
print_unsigned_16sc endp

print_8bit_signed_10sc proc near
	mov ah, 09h
	mov dx, offset text_8s10
	int 21h
	
	mov ax, num
	mov num8, al
	mov str_num8[0], '+'
	
	cmp num8, 10000000b
	jb positive_num	; num8 < 1000 0000b (1 бит == 0)
	mov str_num8[0], '-'	
	sub num8, 1
	not num8
	
	positive_num:
	mov si, 1
	mov cx, 3
	mov dl, 100 ; 64h
	
	for_bit_8num_loop:
		mov ax, 0
		mov al, num8
		div dl		; num8 / dl = al, ost = ah
		
		mov str_num8[si], al
		add str_num8[si], '0'
		mov num8, ah
		
		mov ax, 0
		mov al, dl
		mov dl, 10
		div dl 		; dl / 10 (0Ah) = al
		mov dl, al
		inc si
		loop for_bit_8num_loop
		
	mov ah, 09h
	mov dx, offset str_num8
	int 21h
	
	ret
print_8bit_signed_10sc endp

;2-й вариант - минимальная степень двойки, 
;которая превышает введённое число в беззнаковой интерпретации.
print_min_deg2_gt_num proc near
	mov ah, 09h
	mov dx, offset text_min_deg2
	int 21h

	mov bl, 0 ; степень двойки
	mov tmpnum, 1 ; 2 ** 0
	
	mov cx, 16	; если степень > 16 то 17, не более т к число 2Б
	bigger_degree:
		mov ax, num
		cmp tmpnum, ax
		ja good_degree
		
		inc bl
		mov ax, 2
		mul tmpnum ; tmpnum *= 2
		mov tmpnum, ax
		
		loop bigger_degree	
		
	mov bl, 16
	
	good_degree:
	
	; выводим степень двойки в 10сс
	cmp bl, 10
	jae two_digit	; bl < 10
	
	one_digit:
	mov deg[0], bl
	add deg[0], '0'
	mov deg[1], '$'
	jmp print_res
	
	two_digit:
	mov ax, 0
	mov al, bl
	mov bl, 10
	div bl		; bl / 10 = al, ost - ah
	mov deg[0], al
	add deg[0], '0'
	mov deg[1], ah
	add deg[1], '0'
	
	print_res:
	mov ah, 09h
	mov dx, offset deg
	int 21h
	
	ret
print_min_deg2_gt_num endp
CODE_SEG ENDS
END