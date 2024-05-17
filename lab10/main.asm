bits 64
global main

%define GTK_WIN_POS_CENTER 1
%define GTK_BORDER_WIDTH 10

extern sprintf
extern find_root


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
extern gtk_container_set_border_width
extern gtk_button_new_with_label
extern gtk_label_new
extern gtk_widget_show_all

extern gtk_grid_new
extern gtk_container_add
extern gtk_grid_attach
extern gtk_adjustment_new
extern gtk_spin_button_new_with_range
extern gtk_spin_button_set_value
extern gtk_spin_button_set_digits
extern gtk_spin_button_get_value
extern gtk_spin_button_get_value_as_int
extern gtk_label_set_text



section .bss
window: resq 1
label_a: resq 1 
label_b: resq 1
label_iters: resq 1
label_root: resq 1
label_out_root: resq 1
spin_a: resq 1
spin_b: resq 1
spin_iter: resq 1

button: resq 1
grid: resq 1

section .data
min_x: dq -1000.0
max_x: dq 1000.0
step_x: dq 0.1
cur_xa: dq 0.3
cur_xb: dq 0.6
min_iters: dq 0.0
max_iters: dq 100.0
step_iters: dq 1.0
cur_iters: dq 10.0
result_buffer: db 100 dup(0)
double_result: dq 0
double_a: dq 0.0
double_b: dq 0.0
int_iters: dq 0

section .rodata
signal:
.clicked: db "clicked", 0
.destroy: db "destroy", 0

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
    ; mov rdi, qword [ rel window ]
    ; mov rsi, GTK_WIN_WIDTH
    ; mov rdx, GTK_WIN_HEIGHT
    ; call gtk_window_set_default_size
    mov rdi, qword [rel window]
    mov rsi, GTK_BORDER_WIDTH
    call gtk_container_set_border_width

    mov rdi, qword [ rel window ]
    mov rsi, GTK_WIN_POS_CENTER
    call gtk_window_set_position

    ; Создание контейнера
    call gtk_grid_new
    mov qword [rel grid], rax

    mov rdi, qword [rel window]
    mov rsi, qword [rel grid]
    call gtk_container_add

    ; Создание лэйблов и полей ввода
    mov rdi, label_a_text
    call gtk_label_new
    mov qword [rel label_a], rax

    mov rdi, label_b_text
    call gtk_label_new
    mov qword [rel label_b], rax

    mov rdi, label_iters_text
    call gtk_label_new
    mov qword [rel label_iters], rax

    mov rdi, label_root_text
    call gtk_label_new
    mov qword [rel label_root], rax

    mov rdi, result_buffer
    call gtk_label_new
    mov qword [rel label_out_root], rax
    ;

    ; Создание spinbox
    movq xmm0, [min_x]
    movq xmm1, [max_x]
    movq xmm2, [step_x]
    call gtk_spin_button_new_with_range
    mov qword [rel spin_a], rax
    mov rdi, qword [rel spin_a]
    movq xmm0, [cur_xa]
    call gtk_spin_button_set_value

    movq xmm0, [min_x]
    movq xmm1, [max_x]
    movq xmm2, [step_x]
    call gtk_spin_button_new_with_range
    mov qword [rel spin_b], rax
    mov rdi, qword [rel spin_b]
    movq xmm0, [cur_xb]
    call gtk_spin_button_set_value

    movq xmm0, [min_iters]
    movq xmm1, [max_iters]
    movq xmm2, [step_iters]
    call gtk_spin_button_new_with_range
    mov qword [rel spin_iter], rax
    mov rdi, qword [rel spin_iter]
    movq xmm0, [cur_iters]
    call gtk_spin_button_set_value
    mov rdi, qword [rel spin_iter]
    mov rsi, 0
    call gtk_spin_button_set_digits
    ;

    ; Создание кнопки
    mov rdi, button_text
    call gtk_button_new_with_label
    mov qword [rel button], rax

    ; Добавление виджетов в контейнер
    mov rdi, qword [rel grid]
    mov rsi, qword [rel label_a]
    mov rdx, 0
    mov rcx, 0
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel spin_a]
    mov rdx, 1
    mov rcx, 0
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel label_b]
    mov rdx, 0
    mov rcx, 1
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel spin_b]
    mov rdx, 1
    mov rcx, 1
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel label_iters]
    mov rdx, 0
    mov rcx, 2
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel spin_iter]
    mov rdx, 1
    mov rcx, 2
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel label_root]
    mov rdx, 0
    mov rcx, 4
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel label_out_root]
    mov rdx, 1
    mov rcx, 4
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    mov rdi, qword [rel grid]
    mov rsi, qword [rel button]
    mov rdx, 0
    mov rcx, 5
    mov r8d, 2
    mov r9d, 1
    call gtk_grid_attach

    ; Установка обработчика нажатия кнопки
    mov rdi, qword [rel button]
    mov rsi, signal.clicked
    mov rdx, button_clicked_handler
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    mov rdi, qword [ rel window ]
    mov rsi, signal.destroy
    mov rdx, gtk_main_quit
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data
    mov rdi, qword [ rel window ]
    call gtk_widget_show_all
    call gtk_main
    ret

button_clicked_handler:
    push rbp
    mov rbp, rsp
    mov rdi, qword [rel spin_a]
    call gtk_spin_button_get_value
    movq qword [rel double_a], xmm0
    pop rbp

    push rbp
    mov rbp, rsp
    mov rdi, qword [rel spin_b]
    call gtk_spin_button_get_value
    movq qword [rel double_b], xmm0
    pop rbp

    push rbp
    mov rbp, rsp
    mov rdi, qword [rel spin_iter]
    call gtk_spin_button_get_value_as_int
    mov [rel int_iters], rax
    pop rbp

    movq xmm0, qword [double_a]
    movq xmm1, qword [double_b]
    mov rdi, [rel int_iters]
    push rbp
    mov rbp, rsp
    call find_root
    movq qword [rel double_result], xmm0
    pop rbp
    
show_result:
    push rbp
    movsd xmm0, qword [double_result]
    mov rdi, result_buffer
    mov rsi, double_format
    mov	eax, 1
    call sprintf
    pop rbp

    mov rdi, qword [rel label_out_root]
    mov rsi, result_buffer
    call gtk_label_set_text
    ret
