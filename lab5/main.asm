;.386
public menu_loop

EXTERN newline: near
EXTERN input_num: near
EXTERN print_unsigned_16sc: near
EXTERN print_8bit_signed_10sc: near
EXTERN print_min_deg2_gt_num: near

STK SEGMENT PARA STACK USE16 'STACK'
    db 100 dup (?)
STK ENDS

DATA_SEG SEGMENT PARA public USE16 'DATA'
	menu_err db 10, 13, "ERROR: action num$"
	no_input_err db 10, 13,  "ERROR: input num before$"
DATA_SEG ENDS

DATA_SEG SEGMENT PARA public USE16 'DATA'
	menu_text 	db "1 - Input number signed 2 s/c"
			db 10	; перевести курсор на нов. строку
			db 13 	; курсор поместить в нач. строки
			db "2 - print unsigned 16 s/c", 10, 13
			db "3 - print 8bit signed 10 s/c", 10, 13
			db "4 - print min degree of 2 > unsigned input num", 10, 13
			db "5 - Exit", 10, 13
			db "Input action (1-4): $"
	func	dw (input_num)
			dw (print_unsigned_16sc)
			dw (print_8bit_signed_10sc)
			dw (print_min_deg2_gt_num)
			dw (exit)
	bool_num_inputed db 0
DATA_SEG ENDS

CODE_SEG SEGMENT PARA public USE16 'CODE'
	assume CS:CODE_SEG, DS:DATA_SEG
main:
	mov ax, DATA_SEG	; загружаем сегмент данный в ds
	mov ds, ax
	
	menu_loop:
		call newline
		; вывод меню
		mov ah, 09h
		mov dx, offset menu_text	; offset - получить адресс переменной а не ее содержимое
		int 21h
		
		mov ah, 01h	; ввод симола, полученный -> al
		int 21h
		sub al, '1'
		cmp al, 0
		jb show_menu_err	; if al < 0
		cmp al, 4
		ja show_menu_err	; if al > 4
		
		cmp al, 0		; проверка введено ли число, перед его выводом
		je good_input
		cmp al, 4		; exit
		je good_input
		cmp bool_num_inputed, 0	; число не введено но попытка выолнить действия 2, 3
		je show_no_input_err
		jmp good_input
		
		show_menu_err:
			mov dx, offset menu_err
			jmp bad_input
		show_no_input_err:
			mov dx, offset no_input_err
			jmp bad_input
		bad_input:
			mov ah, 09h
			int 21h
			jmp menu_loop
		
		good_input:
		mov bool_num_inputed, 1
		mov ah, 2
		mul ah		; умножает источник(ah) на al, результат -> ax
		mov bx, ax
		
		call func[bx]
		jmp menu_loop
	
	call exit

exit proc near
	mov ax, 4c00h
	int 21h
exit endp

CODE_SEG ENDS

END main
