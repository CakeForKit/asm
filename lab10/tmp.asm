bits 64
global main

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 700
%define GTK_WIN_HEIGHT 450

extern exit
extern gtk_init
extern gtk_main
extern g_object_set
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show
extern g_signal_connect
extern gtk_window_set_title
extern g_signal_connect_data
extern gtk_window_set_position
extern gtk_settings_get_default
extern gtk_widget_set_size_request
extern gtk_window_set_default_size

extern gtk_box_new
extern gtk_orientable_set_orientation
extern gtk_label_set_text
extern gtk_widget_set_halign
extern gtk_grid_new
extern gtk_container_add
extern gtk_label_new
extern gtk_grid_attach
extern gtk_button_new_with_label

extern my_func

; Секция .bss содержит неинициализированные данные, 
; для которых известен размер, но неизвестно значение. 
; Операционная система инициализирует раздел .bss всеми нулями. 
section .bss
window: resq 1
label_a: resq 1 
label_b: resq 1
label_iters: resq 1
label_root: resq 1
label_out_root: resq 1

entry_start: resq 1
entry_end: resq 1
entry_iterations: resq 1
; output_result: resq 1
button: resq 1
grid: resq 1
box: resq 1

section .data
result_buffer: db 100 dup(0)
double_result: dq 0
double_start: dq 0
double_end: dq 0
int_iterations: dq 0

; Секция .rodata содержит данные, которые нельзя изменить 
;(то есть по сути константы).
section .rodata
signal:
.destroy: db "destroy", 0
.clicked: db "clicked", 0

title: db "LAB 10", 0
label_a_text: db "X_start:", 0
label_b_text: db "X_end:", 0
label_iters_text: db "Iterations:", 0
label_root_text: db "Root:", 0
button_text: db "Find root", 0
double_format: db "%lf", 0
int_format: db "%d", 0
error_msg: db "ERROR: can't find the root.", 0

section .text
_destroy_window:
    jmp gtk_main_quit
main:
    push rbp
    mov rbp, rsp
    xor rdi, rdi
    xor rsi, rsi
    call gtk_init
    xor rdi, rdi
    call gtk_window_new
    mov qword [ rel window ], rax
    mov rdi, qword [ rel window ]
    mov rsi, title
    call gtk_window_set_title
    mov rdi, qword [ rel window ]
    mov rsi, GTK_WIN_WIDTH
    mov rdx, GTK_WIN_HEIGHT
    call gtk_window_set_default_size
    mov rdi, qword [ rel window ]
    mov rsi, GTK_WIN_POS_CENTER
    call gtk_window_set_position

    ; Обработка нажатия кнопки

    

    ; Создание контейнера
    ; call gtk_grid_new
    ; mov qword [rel grid], rax

    ; mov rdi, qword [rel window]
    ; mov rsi, qword [rel grid]
    ; call gtk_container_add
    call gtk_box_new
    mov qword [rel box], rax

    mov rdi, qword [rel box]
    mov rsi, 1
    call gtk_orientable_set_orientation

    mov rdi, qword [rel window]
    mov rsi, qword [rel box]
    call gtk_container_add
    ;

    ; Создание лэйблов
    ; mov rdi, label_a_text
    call gtk_label_new
    mov qword [rel label_a], rax

    mov rdi, qword [rel label_a]
    mov rsi, label_a_text
    call gtk_label_set_text
    mov rdi, qword [rel label_a]
    mov rsi, 1
    call gtk_widget_set_halign

    ; mov rdi, label_b_text
    ; call gtk_label_new
    ; mov qword [rel label_b], rax

    ; mov rdi, label_iters_text
    ; call gtk_label_new
    ; mov qword [rel label_iters], rax

    ; mov rdi, label_root_text
    ; call gtk_label_new
    ; mov qword [rel label_root], rax

    ; call gtk_label_new
    ; mov qword [rel label_out_root], rax
    ;

    ; Создание кнопки
    mov rdi, button_text
    call gtk_button_new_with_label
    mov qword [rel button], rax

    ; Добавление виджетов в контейнер
    ; mov rdi, qword [rel grid]
    ; mov rsi, qword [rel label_a]
    ; mov rdx, 0
    ; mov rcx, 0
    ; mov r8d, 1
    ; mov r9d, 1
    ; call gtk_grid_attach

    ; mov rdi, qword [rel grid]
    ; mov rsi, qword [rel button]
    ; mov rdx, 0
    ; mov rcx, 3
    ; mov r8d, 2
    ; mov r9d, 1
    ; call gtk_grid_attach

    mov rdi, qword [ rel box ]
    mov rsi, qword [ rel label_a ]
    call gtk_container_add

    mov rdi, qword [ rel box ]
    mov rsi, qword [ rel button]
    call gtk_container_add

    mov rdi, 1
    mov rsi, 2
    mov rdx, 3
    mov rcx, 4
    mov r8d, 5
    mov r9d, 6
    call my_func
    ;

    ; [rel msg]
    ; which uses the relative address msg-nextInsn instead of 
    ; absolute address of msg, thus allowing the assembler to not know 
    ; the actual address but still encode the instruction.
    mov rdi, qword [ rel window ]
    mov rsi, signal.destroy
    mov rdx, _destroy_window
    xor rcx, rcx    ; обнуляем значения в регистрах
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data
    ;

    mov rdi, qword [ rel window ]
    call gtk_widget_show
    call gtk_main
    ret