bits 64
default rel

extern printf
extern Sleep
extern GetAsyncKeyState

section .data
    clear_str   db 27, "[2J", 27, "[H", 0  
    draw_fmt    db 27, "[%d;%dH%c", 0      
    map_fmt     db 27, "[1;1H%s", 0
    
    ; Largura exata do seu novo mapa: 75 caracteres + 13 (CR) + 10 (LF) = 77
    map_width   equ 77
    
    ; --- LEVEL 1 ---
    map_data_1  db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########", 0
                
    ; --- LEVEL 2  ---
    map_data_2  db "######      ########      ######      #######       ##########      #######", 13, 10
                db "######      ########      ######      #######       ##########      #######", 13, 10
                db "######      ########      ######      #######       ##########      #######", 13, 10
                db "######      ########      ######      #######       ##########      #######", 13, 10
                db "######      ########      ######      #######       ##########      #######", 0

    msg_death   db 27, "[2J", 27, "[H", "VOCE CAIU NO BURACO! GAME OVER.", 10, 0
    msg_win     db 27, "[2J", 27, "[H", "PARABENS! VOCE ZEROU O JOGO!", 10, 0
    
    ; Ponteiro que guarda qual mapa está sendo jogado agora (começa no Level 1)
    current_map dq map_data_1
    
    player_x    dq 2
    player_y    dq 2
    player_z    dq 0
    jump_timer  dq 0

section .text
    global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

game_loop:
    ; 1. LER TECLADO
    mov rcx, 0x57           ; 'W'
    call GetAsyncKeyState
    test ax, 0x8000
    jz .check_s
    dec qword [player_y]
    
.check_s:
    mov rcx, 0x53           ; 'S'
    call GetAsyncKeyState
    test ax, 0x8000
    jz .check_a
    inc qword [player_y]
    
.check_a:
    mov rcx, 0x41           ; 'A'
    call GetAsyncKeyState
    test ax, 0x8000
    jz .check_d
    dec qword [player_x]
    
.check_d:
    mov rcx, 0x44           ; 'D'
    call GetAsyncKeyState
    test ax, 0x8000
    jz .check_space
    inc qword [player_x]

.check_space:
    mov rcx, 0x20           ; 'ESPAÇO'
    call GetAsyncKeyState
    test ax, 0x8000
    jz .update_physics

.jump:
    cmp qword [jump_timer], 0
    jne .update_physics
    mov qword [jump_timer], 8

.update_physics:
    ; 2. FÍSICA DO PULO
    cmp qword [jump_timer], 0
    je .grounded
    
    dec qword [jump_timer]
    
    cmp qword [jump_timer], 4
    jge .pico_pulo
    
    mov qword [player_z], 1
    jmp .check_bounds

.pico_pulo:
    mov qword [player_z], 2
    jmp .check_bounds

.grounded:
    mov qword [player_z], 0

.check_bounds:
    ; 3. COLISÕES E LIMITES
    cmp qword [player_x], 1
    jl .game_over
    
    ; Se chegou no limite direito (X=75), processa a transição de fase
    cmp qword [player_x], 75
    jge .next_level
    
    cmp qword [player_y], 1
    jl .game_over
    cmp qword [player_y], 5
    jg .game_over

.check_matrix:
    mov rax, [player_y]
    dec rax
    mov rbx, 77             ; NOVO map_width (77 bytes por linha)
    mul rbx                 
    
    mov rcx, [player_x]
    dec rcx
    add rax, rcx            
    
    ; Acessa a memória usando o ponteiro current_map em vez de um mapa fixo
    mov rbx, [current_map]
    mov cl, byte [rbx + rax]
    
    cmp cl, ' '
    jne .render             
    
    cmp qword [jump_timer], 0
    jne .render             

.game_over:
    lea rcx, [msg_death]
    call printf
    jmp .end_game

.next_level:
    ; Verifica qual mapa está carregado agora comparando o ponteiro
    lea rax, [map_data_1]
    mov rbx, [current_map]
    cmp rax, rbx
    jne .win_game           ; Se não é o mapa 1, significa que estava no 2. O jogador venceu!

    ; Se era o mapa 1, carrega o mapa 2
    lea rax, [map_data_2]
    mov qword [current_map], rax
    
    ; Reseta o jogador para o início da tela
    mov qword [player_x], 2
    mov qword [player_y], 2
    jmp game_loop

.win_game:
    lea rcx, [msg_win]
    call printf
    jmp .end_game

.render:
    ; 4.1 LIMPAR A TELA
    lea rcx, [clear_str]
    call printf

    ; 4.2 DESENHAR O MAPA 
    lea rcx, [map_fmt]
    mov rdx, [current_map]  ; Passa o ponteiro dinâmico para o printf
    call printf

    ; 4.3 DESENHAR O JOGADOR
    mov r9, '.'             
    
    mov rax, [player_z]
    cmp rax, 1
    je .set_medium
    cmp rax, 2
    jge .set_large
    jmp .do_draw

.set_medium:
    mov r9, 'o'
    jmp .do_draw

.set_large:
    mov r9, 'O'

.do_draw:
    lea rcx, [draw_fmt]
    mov rdx, [player_y]
    mov r8,  [player_x]
    call printf

.frame_delay:
    ; 5. CONTROLAR FPS
    mov rcx, 45
    call Sleep
    jmp game_loop

.end_game:
    add rsp, 32
    pop rbp
    xor rax, rax
    ret