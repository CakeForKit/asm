; из двух модулей, в первом ввести 2 цифры от 5 до 9 и от 1 до
; 5, во втором - вывести разность этих цифр. Сегменты коды
; должны объединяться в единый.

EXTRN diff_ab: near

;PUBLIC A
;PUBLIC B

DSEG SEGMENT PARA common 'DATA'
	A db ?	; создает переменную байт и определяет ее 
	B db ?
DSEG ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:DSEG
main:
	mov AH,07h	;ввести символ без эха
	int 21h
	mov A, al 	; определяем перменну введенным символом
	
	mov ah, 07h
	int 21h
	mov B, al
	
	call diff_ab
	
	mov ax, 4c00h
	int 21h
SC1 ENDS

END main
