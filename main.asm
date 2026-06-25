bits 64
default rel

extern printf
extern Sleep
extern GetAsyncKeyState

section .data
    clear_str   db 27, "[2J", 27, "[H", 0  
    draw_fmt    db 27, "[%d;%dH%c", 0      
    map_fmt     db 27, "[1;1H%s", 0
    
    ; Largura mapa: 75 caracteres + 13 (CR) + 10 (LF) = 77
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

    ; --- LEVEL 3 ---
    map_data_3  db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########", 13, 10
                db "                                                                           ", 13, 10
                db "######                                                                     ", 13, 10
                db "######      ########      ######      #######       ##########      #######", 13, 10
                db "######      ########      ######      #######       ##########      #######", 0

    item_spawn_x dq 2, 15, 29, 40, 2, 14, 28, 40
    item_spawn_y dq 1, 1, 2, 2, 6, 6, 7, 7

    msg_death   db 27, "[2J", 27, "[H", "HAHAHA VOCE CAIU NO BURACO! GAME OVER.", 10, 0
    msg_win     db 27, "[2J", 27, "[H", "PARABENS! VOCE ZEROU O JOGO!", 10, 0
    
    ; Ponteiro que guarda qual mapa está sendo jogado agora (começa no Level 1)
    current_map dq map_data_1

    special_item_x          dq 0
    special_item_y          dq 0
    special_item_collected  dq 0
    
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
    jl .check_y_bounds

    lea rax, [map_data_3]
    mov rbx, [current_map]
    cmp rax, rbx
    jne .next_level

    cmp qword [special_item_collected], 0
    je .block_level3_exit

    jmp .next_level

.block_level3_exit:
    mov qword [player_x], 74
    jmp .check_y_bounds
    
.check_y_bounds:
    cmp qword [player_y], 1
    jl .game_over

    lea rax, [map_data_3]
    mov rbx, [current_map]
    cmp rax, rbx
    jne .limit_y_5

    cmp qword [player_y], 7
    jg .game_over
    jmp .check_matrix

.limit_y_5:
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
    jne .check_item         
    
    cmp qword [jump_timer], 0
    jne .render             

.check_item:
    lea rdx, [map_data_3]
    mov rbx, [current_map]
    cmp rdx, rbx
    jne .render

    cmp qword [special_item_collected], 1
    je .render

    mov rax, [player_x]
    cmp rax, [special_item_x]
    jne .render

    mov rax, [player_y]
    cmp rax, [special_item_y]
    jne .render

    ; --- ITEM COLETADO ---
    mov qword [special_item_collected], 1

    ; Apaga o item do mapa (troca por '#')
    mov rax, [special_item_y]
    dec rax
    mov rbx, 77
    imul rax, rbx

    mov rcx, [special_item_x]
    dec rcx
    add rax, rcx
    mov byte [rdx + rax], '#'
    
    ; Redireciona o fluxo para pular a tela de Game Over!
    jmp .render

.game_over:
    lea rcx, [msg_death]
    call printf
    jmp .end_game

.next_level:
    ; Verifica qual mapa está carregado agora comparando o ponteiro
    lea rax, [map_data_1]
    mov rbx, [current_map]
    cmp rax, rbx
    jne .check_level_2

    ; Se era o mapa 1, carrega o mapa 2
    lea rax, [map_data_2]
    mov qword [current_map], rax
    
    ; Reseta o jogador para o início da tela
    mov qword [player_x], 2
    mov qword [player_y], 2
    jmp game_loop

.check_level_2:
    lea rax, [map_data_2]
    cmp rax, rbx
    jne .check_level_3

    lea r11, [map_data_3]
    mov qword [current_map], r11

    rdtsc
    and eax, 7

    lea r8, [item_spawn_x]
    lea r9, [item_spawn_y]

    mov rcx, [r8 + rax*8]
    mov rdx, [r9 + rax*8]
    mov qword [special_item_x], rcx
    mov qword [special_item_y], rdx
    mov qword [special_item_collected], 0

    mov r8, rdx
    dec r8
    mov r9, 77
    imul r8, r9

    mov r10, rcx
    dec r10
    add r8, r10
    mov byte [r11 + r8], '!'

    mov qword [player_x], 2
    mov qword [player_y], 2
    jmp game_loop

.check_level_3:
    lea rax, [map_data_3]
    cmp rax, rbx
    jne .win_game

    cmp qword [special_item_collected], 0
    je .block_level3_exit

    jmp .win_game

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