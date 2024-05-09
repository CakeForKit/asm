.model tiny

CODE_SEG SEGMENT
	assume CS:CODE_SEG, DS:CODE_SEG
	org 100h
main:
	jmp init
	
	installed db 1
	old_int09h dd ?
	last_time_hour db 0
	last_time_min db 0
	last_time_sec db 0
	speed db 0h			; первый 4 бита параметра 0F3h
	
	my_param dq 1280 dup(?) ; 10 Кб - отниментся из ОП
	
new_int09h proc far
	pushf				; сохранить регистр флагов
	push ax
	push dx
	call cs:old_int09h
	
;	mov ah, 01h			; Проверка буфера на наличие в нем символов
;	int 16h
;	jne pushed_one_btn	; ZF = 0, если в буфере имеется код нажатой
                        ; на клавиатуре клавиши;
	
	mov ah, 02h		; Определить время RTC
	int 1Ah			; DH = секунда (в формате BCD)
	
	cmp ch, last_time_hour
	jne change_speed
	cmp cl, last_time_min
	jne change_speed
	cmp dh, last_time_sec
	jne change_speed
	
	end_change_speed:
	
	mov last_time_hour, ch
	mov last_time_min, cl
	mov last_time_sec, dh	
	
	pushed_one_btn:
	pop ax
	pop dx
	iret
	
change_speed:
	inc speed
	inc speed
	
	cmp speed, 1Fh	; 1Fh - макс скорость
	ja speed_to_zepo
	back:
	call set_speed
	jmp end_change_speed
	
speed_to_zepo:
	mov speed, 0
	
;	mov ah, 02h
;	mov dl, 'K'
;	int 21h
	jmp back

new_int09h endp

set_speed proc near
	call wait_KBin
	mov al, 0F3h	; установить параметры режима автоповтора
	out 60h, al
	call wait_KBin
	mov al, speed	; устанавливаем скорость (второй параметр команды 0F3h)
	out 60h, al
	ret
set_speed endp
	

;Перед тем как посылать команду процессору 8042, 
;необходимо убедиться в том, что его внутренняя очередь команд пуста
wait_KBin proc near	; ожидание возможности ввода команды для клавиатуры
	in al, 64h		; Считать данные из порта 
	test al, 0010b	; бит 1 == 1 когда очередь пуста
	jnz wait_KBin	; если не пуста - ждем
	ret
wait_KBin endp
	
init:
	; чтение элемента таблицы векторов прерывания
	mov ax, 3509h	; Ah = 35h Al = номер прерывания которого считываем
	int 21h
	mov word ptr old_int09h, bx		; смещение обработчика прерывания
	mov word ptr old_int09h + 2, es	; сегмент обработчика прерывания
	
	cmp es:installed, 1
	je uninstall 

	; установка времени
	mov last_time_hour, ch
	mov last_time_min, cl
	mov last_time_sec, dh
	
	; установка нового обработчика прерывания
	mov ax, 2509h				; Ah = 35h Al = номер прерывания которое заменяет
	mov dx, offset new_int09h	; dx - адресс обработчика на замену
	int 21h
	
	mov dx, offset init	; смещение команды, нач с которой можно удалять
	int 27h				; завершить выполнение оставшись резидентом

uninstall:
	mov speed, 0
	call set_speed
	
	
	mov ax, 2509h
	mov dx, word ptr es:old_int09h
	mov ds, word ptr es:old_int09h + 2
	int 21h
	
	mov ah, 49h	; Releases memory that was allocated via function 48h.
    int 21h		; ES = Segment address of memory to be released
	
	mov ax, 4C00h
    int 21h

CODE_SEG ENDS
END main
