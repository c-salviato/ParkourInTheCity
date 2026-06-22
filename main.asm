bits 64
default rel

extern _kbhit
extern _getch
extern printf
extern Sleep

section .data
    clear_str   db 27, "[2J", 27, "[H", 0  
    draw_fmt    db 27, "[%d;%dH%c", 0      
    
    player_x    dq 10
    player_y    dq 10
    player_z    dq 0
    jump_timer  dq 0      ; Controla quantos frames o jogador fica no ar

section .text
    global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

game_loop:
    ; 1. LER TECLADO
    call _kbhit
    cmp rax, 0
    je .update_physics    ; Se não apertou nada, vai direto pra física

    call _getch
    
    ; Compara qual tecla foi pressionada (minúsculas)
    cmp al, 'w'
    je .move_up
    cmp al, 's'
    je .move_down
    cmp al, 'a'
    je .move_left
    cmp al, 'd'
    je .move_right
    cmp al, ' '           ; Tecla Espaço
    je .jump
    jmp .update_physics

.move_up:
    dec qword [player_y]
    jmp .update_physics
.move_down:
    inc qword [player_y]
    jmp .update_physics
.move_left:
    dec qword [player_x]
    jmp .update_physics
.move_right:
    inc qword [player_x]
    jmp .update_physics
    
.jump:
    cmp qword [jump_timer], 0   ; Só permite pular se estiver no chão (timer = 0)
    jne .update_physics
    mov qword [jump_timer], 8   ; Duração do pulo (8 frames)
    jmp .update_physics

.update_physics:
    ; 2. FÍSICA DO PULO (Gravidade)
    cmp qword [jump_timer], 0
    je .grounded
    
    dec qword [jump_timer]      ; Diminui o tempo no ar
    
    ; Se timer > 4, está na parte mais alta do pulo (Z=2)
    cmp qword [jump_timer], 4
    jge .pico_pulo
    
    ; Senão, está subindo ou quase caindo (Z=1)
    mov qword [player_z], 1
    jmp .render

.pico_pulo:
    mov qword [player_z], 2
    jmp .render

.grounded:
    mov qword [player_z], 0

.render:
    ; 3. LIMPAR A TELA
    lea rcx, [clear_str]
    call printf

    ; 4. DESENHAR O JOGADOR
    mov r9, '.'             ; Caractere no chão
    
    mov rax, [player_z]
    cmp rax, 1
    je .set_medium
    cmp rax, 2
    jge .set_large
    jmp .do_draw

.set_medium:
    mov r9, 'o'             ; Subindo/Descendo
    jmp .do_draw

.set_large:
    mov r9, 'O'             ; Pico do pulo

.do_draw:
    lea rcx, [draw_fmt]
    mov rdx, [player_y]
    mov r8,  [player_x]
    call printf

.frame_delay:
    ; 5. CONTROLAR FPS
    mov rcx, 33             ; ~30 FPS
    call Sleep
    jmp game_loop

    ; Finalização padrão
    add rsp, 32
    pop rbp
    xor rax, rax
    ret