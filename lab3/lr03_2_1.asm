STK SEGMENT para STACK 'STACK'
	db 100 dup(0)	; создает массив из 100 байт проинициализорованных 0
STK ENDS

SD1 SEGMENT para common 'DATA'
	W dw 3444h	; создает слово сранящее - 3444h
SD1 ENDS
END
