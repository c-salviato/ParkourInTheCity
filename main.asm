bits 64
default rel

extern printf
extern Sleep
extern GetAsyncKeyState
extern GetTickCount64

section .data
    clear_str   db 27, "[2J", 27, "[H", 0  
    draw_fmt    db 27, "[%d;%dH%c", 0      
    map_fmt     db 27, "[1;1H%s", 0
    
    ; Largura do mapa: 100 caracteres jogáveis + 13 (CR) + 10 (LF) = 102
    map_width   equ 102
    map_height  equ 12
    
    ; --- LEVEL 1 (100 de largura x 12 de altura) ---
    map_data_1  db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 0
                
    ; --- LEVEL 2 (Mais buracos e prédios menores) ---
    map_data_2  db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 0

    ; --- LEVEL 3 (Prédios altos no começo, abismo no meio, plataformas curtas embaixo) ---
    map_data_3  db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "##########   ###########   #######   ############   ##########   ##########   ######################", 13, 10
                db "                                                                                                    ", 13, 10
                db "                                                                                                    ", 13, 10
                db "                                                                                                    ", 13, 10
                db "######                                                                                              ", 13, 10
                db "######                                                                                              ", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 13, 10
                db "######      ########      ######      #######       ##########      #######      ###################", 0

    ; Ajuste das coordenadas dos itens para caírem nos prédios de baixo do Level 3 (Linhas 9 a 12)
    item_spawn_x dq 15, 30, 42, 58, 72, 85, 90, 95
    item_spawn_y dq 9, 10, 11, 12, 10, 11, 12, 9

    ; --- LEVEL 4 (mais prédios, saltos mais apertados e 3 itens especiais) ---
    map_data_4  db "##########", "          ", "##########", "          ", "#####     ", "##########", "          ", "##########", "          ", "##########", 13, 10
                db "##########", "          ", "##########", "          ", "#####     ", "##########", "          ", "##########", "          ", "##########", 13, 10
                db "          ", "##########", "          ", "#####     ", "          ", "##########", "          ", "#####     ", "          ", "##########", 13, 10
                db "          ", "##########", "          ", "#####     ", "          ", "##########", "          ", "#####     ", "          ", "##########", 13, 10
                db "##########", "##########", "          ", "          ", "##########", "          ", "##########", "          ", "#####     ", "          ", 13, 10
                db "##########", "##########", "          ", "          ", "##########", "          ", "##########", "          ", "#####     ", "          ", 13, 10
                db "          ", "#####     ", "          ", "##########", "          ", "##########", "          ", "##########", "          ", "##########", 13, 10
                db "          ", "#####     ", "          ", "##########", "          ", "##########", "          ", "##########", "          ", "##########", 13, 10
                db "##########", "          ", "##########", "          ", "##########", "          ", "#####     ", "          ", "##########", "##########", 13, 10
                db "##########", "          ", "##########", "          ", "##########", "          ", "#####     ", "          ", "##########", "##########", 13, 10
                db "##########", "          ", "#####     ", "          ", "##########", "          ", "##########", "          ", "#####     ", "          ", 13, 10
                db "##########", "          ", "#####     ", "          ", "##########", "          ", "##########", "          ", "#####     ", "          ", 0

    level4_item_x dq 6, 45, 86
    level4_item_y dq 2, 6, 10
    level4_items_total dq 3
    level4_items_collected dq 0

    map_data_5  db "##########", "          ", "######    ", "   ###    ", "##########", "          ", "#######   ", "          ", "#####     ", "          ", 13, 10
                db "##########", "          ", "######    ", "   ###    ", "##########", "          ", "#######   ", "          ", "#####     ", "          ", 13, 10
                db "     #####", "##########", "          ", "#####     ", "          ", "##########", "   ####   ", "##########", "          ", "######    ", 13, 10
                db "##########", "   ####   ", "##########", "          ", "######    ", "          ", "##########", "    ####  ", "##########", "          ", 13, 10
                db "######    ", "          ", "##########", "  #####   ", "          ", "##########", "          ", "#######   ", "          ", "##########", 13, 10
                db "######    ", "          ", "##########", "  #####   ", "##########", "          ", "#######   ", "          ", "#####     ", "          ", 13, 10
                db "          ", "##########", "          ", "#####     ", "##########", "          ", "#######   ", "   ###    ", "##########", "          ", 13, 10
                db "          ", "##########", "          ", "#####     ", "##########", "          ", "#######   ", "   ###    ", "##########", "          ", 13, 10
                db "##########", "          ", "#####     ", "          ", "##########", "          ", "#######   ", "          ", "##########", "          ", 13, 10
                db "##########", "          ", "#####     ", "          ", "##########", "          ", "#######   ", "          ", "##########", "          ", 13, 10
                db "###       ", "##########", "          ", "#######   ", "          ", "##########", "          ", "######    ", "##########", "          ", 13, 10
                db "###       ", "##########", "          ", "#######   ", "          ", "##########", "          ", "######    ", "##########", "          ", 0

    level5_item_x dq 6, 28, 49, 70, 90
    level5_item_y dq 2, 4, 6, 9, 11
    level5_items_total dq 5
    level5_items_collected dq 0

    force_next_level dq 0
    game_start_tick  dq 0

    msg_menu    db "####################################################", 10
                db "#                                                  #", 10
                db "#              PARKOUR IN THE CITY                 #", 10
                db "#                                                  #", 10
                db "#   []   []    [][]   []     [][]   []   []        #", 10
                db "#  [##] [##]  [####] [##]   [####] [##] [##]       #", 10
                db "#                                                  #", 10
                db "####################################################", 10, 10
                db "        Pressione ESPACO para iniciar", 10, 0

    msg_death   db "####################################################", 10
                db "#                                                  #", 10
                db "#                    GAME OVER                     #", 10
                db "#                                                  #", 10
                db "#      ###   ###   ###    ###   ###   ###          #", 10
                db "#      # #   # #   # #    # #   # #   # #          #", 10
                db "#      ###   ###   ###    ###   ###   ###          #", 10
                db "#                                                  #", 10
                db "####################################################", 10, 10
                db "        Pressione Q para sair ou R para reiniciar", 10, 0
    msg_win     db 27, "[2J", 27, "[H"
                db "####################################################", 10
                db "#                                                  #", 10
                db "#         VOCE ZEROU PARKOUR IN THE CITY           #", 10
                db "#                                                  #", 10
                db "#   []   []    [][]   []     [][]   []   []        #", 10
                db "#  [##] [##]  [####] [##]   [####] [##] [##]       #", 10
                db "#   ||    ||    |||    ||     |||    ||    ||      #", 10
                db "#        Tempo total: %02llu:%02llu.%03llu        #", 10
                db "#         Q: sair   R: recomecar do inicio         #", 10
                db "####################################################", 10, 0
    
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

    call reset_game
    jmp menu_loop

reset_game:
    lea rax, [map_data_1]
    mov qword [current_map], rax
    mov qword [force_next_level], 0

    mov qword [player_x], 2
    mov qword [player_y], 2
    mov qword [player_z], 0
    mov qword [jump_timer], 0

    mov qword [level4_items_collected], 0
    mov qword [special_item_collected], 0
    call reset_level5_state

    mov rax, [special_item_x]
    mov rcx, [special_item_y]
    cmp rax, 0
    je .skip_level3_restore
    cmp rcx, 0
    je .skip_level3_restore

    lea rdx, [map_data_3]
    mov r8, rax
    dec r8
    mov r9, map_width
    imul r8, r9

    mov r10, rcx
    dec r10
    add r8, r10
    mov byte [rdx + r8], ' '

.skip_level3_restore:
    lea rdx, [map_data_4]
    mov byte [rdx + 107], ' '
    mov byte [rdx + 554], ' '
    mov byte [rdx + 1003], ' '

    mov qword [special_item_x], 0
    mov qword [special_item_y], 0

    call GetTickCount64
    mov qword [game_start_tick], rax
    ret

reset_level5_state:
    mov qword [level5_items_collected], 0

    lea r8, [level5_item_x]
    lea r9, [level5_item_y]
    lea r10, [map_data_5]

    xor r11d, r11d

.place_level5_items:
    cmp r11d, 5
    jge .done_place_level5_items

    mov rax, [r9 + r11*8]
    dec rax
    mov rbx, map_width
    imul rax, rbx

    mov rdx, [r8 + r11*8]
    dec rdx
    add rax, rdx
    mov byte [r10 + rax], '!'

    inc r11d
    jmp .place_level5_items

.done_place_level5_items:
    ret

enter_level4:
    lea r11, [map_data_4]
    mov qword [current_map], r11

    mov qword [level4_items_collected], 0

    mov byte [r11 + 107], '!'
    mov byte [r11 + 554], '!'
    mov byte [r11 + 1003], '!'

    mov qword [player_x], 2
    mov qword [player_y], 2
    mov qword [player_z], 0
    mov qword [jump_timer], 0
    ret

enter_level5:
    call reset_level5_state

    lea r11, [map_data_5]
    mov qword [current_map], r11

    mov qword [player_x], 6
    mov qword [player_y], 3
    mov qword [player_z], 0
    mov qword [jump_timer], 0
    ret

menu_loop:
    lea rcx, [clear_str]
    call printf

    lea rcx, [msg_menu]
    call printf

.menu_wait_input:
    mov rcx, 0x20
    call GetAsyncKeyState
    test ax, 0x8000
    jz .menu_idle

.menu_wait_release:
    mov rcx, 0x20
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .menu_wait_release

    call reset_game
    jmp game_loop

.menu_idle:
    mov rcx, 45
    call Sleep
    jmp menu_loop

game_loop:
    ; 1. LER TECLADO
    mov rcx, 0x50           ; 'P'
    call GetAsyncKeyState
    test ax, 0x8000
    jz .check_w

    mov qword [force_next_level], 1

.wait_p_release:
    mov rcx, 0x50           ; 'P'
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .wait_p_release

    jmp .next_level

.check_w:
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

.pre_check_bounds:
    mov rax, [current_map]
    lea rbx, [map_data_5]
    cmp rax, rbx
    jne .check_bounds

.check_bounds:
    ; 3. COLISÕES E LIMITES
    cmp qword [player_x], 1
    jl .game_over
    
    ; Se chegou no limite direito do mapa jogável, processa a transição de fase
    cmp qword [player_x], 100
    jl .check_y_bounds

    lea rax, [map_data_3]
    mov rbx, [current_map]
    cmp rax, rbx
    je .check_level3_exit

    lea rax, [map_data_5]
    cmp rax, rbx
    je .check_level5_exit

    lea rax, [map_data_4]
    cmp rax, rbx
    je .check_level4_exit

    jmp .next_level

.check_level3_exit:
    cmp qword [special_item_collected], 0
    je .block_level3_exit

    jmp .next_level

.block_level3_exit:
    mov qword [player_x], 74
    jmp .check_y_bounds

.check_level4_exit:
    jmp .next_level

.check_level5_exit:
    jmp .win_game

.block_level4_exit:
    mov qword [player_x], 74
    jmp .check_y_bounds

.block_level5_exit:
    mov qword [player_x], 74
    jmp .check_y_bounds
    
.check_y_bounds:
    cmp qword [player_y], 1
    jl .game_over

    cmp qword [player_y], map_height
    jg .game_over

.check_matrix:
    mov rax, [player_y]
    dec rax
    mov rbx, map_width
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
    je .game_over

    jmp .render

.check_item:
    mov rbx, [current_map]
    lea rdx, [map_data_3]
    cmp rbx, rdx
    je .check_item_level3

    lea rdx, [map_data_5]
    cmp rbx, rdx
    je .check_item_level5

    lea rdx, [map_data_4]
    cmp rbx, rdx
    je .check_item_level4

    jmp .render

.check_item_level3:
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
    mov rbx, map_width
    imul rax, rbx

    mov rcx, [special_item_x]
    dec rcx
    add rax, rcx
    mov byte [rdx + rax], '#'
    
    ; Redireciona o fluxo para pular a tela de Game Over!
    jmp .render

.check_item_level4:
    cmp cl, '!'
    jne .render

    mov rax, [player_x]
    cmp rax, [level4_item_x]
    je .check_level4_item_1
    cmp rax, [level4_item_x + 8]
    je .check_level4_item_2
    cmp rax, [level4_item_x + 16]
    je .check_level4_item_3
    jmp .render

.check_level4_item_1:
    mov rax, [player_y]
    cmp rax, [level4_item_y]
    jne .render
    jmp .collect_level4_item

.check_level4_item_2:
    mov rax, [player_y]
    cmp rax, [level4_item_y + 8]
    jne .render
    jmp .collect_level4_item

.check_level4_item_3:
    mov rax, [player_y]
    cmp rax, [level4_item_y + 16]
    jne .render

.collect_level4_item:
    mov rdx, [current_map]

    mov rax, [player_y]
    dec rax
    mov rbx, map_width
    imul rax, rbx

    mov rcx, [player_x]
    dec rcx
    add rax, rcx
    mov byte [rdx + rax], '#'

    inc qword [level4_items_collected]
    jmp .render

.check_item_level5:
    cmp cl, '!'
    jne .render

    mov rax, [player_x]
    cmp rax, [level5_item_x]
    je .check_level5_item_1
    cmp rax, [level5_item_x + 8]
    je .check_level5_item_2
    cmp rax, [level5_item_x + 16]
    je .check_level5_item_3
    cmp rax, [level5_item_x + 24]
    je .check_level5_item_4
    cmp rax, [level5_item_x + 32]
    je .check_level5_item_5
    jmp .render

.check_level5_item_1:
    mov rax, [player_y]
    cmp rax, [level5_item_y]
    jne .render
    jmp .collect_level5_item

.check_level5_item_2:
    mov rax, [player_y]
    cmp rax, [level5_item_y + 8]
    jne .render
    jmp .collect_level5_item

.check_level5_item_3:
    mov rax, [player_y]
    cmp rax, [level5_item_y + 16]
    jne .render
    jmp .collect_level5_item

.check_level5_item_4:
    mov rax, [player_y]
    cmp rax, [level5_item_y + 24]
    jne .render
    jmp .collect_level5_item

.check_level5_item_5:
    mov rax, [player_y]
    cmp rax, [level5_item_y + 32]
    jne .render

.collect_level5_item:
    mov rdx, [current_map]

    mov rax, [player_y]
    dec rax
    mov rbx, map_width
    imul rax, rbx

    mov rcx, [player_x]
    dec rcx
    add rax, rcx
    mov byte [rdx + rax], '#'

    inc qword [level5_items_collected]
    jmp .render

.game_over:
    lea rcx, [clear_str]
    call printf

    lea rcx, [msg_death]
    call printf

.game_over_wait:
    mov rcx, 0x51           ; 'Q'
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .quit_game

    mov rcx, 0x52           ; 'R'
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .restart_game

    mov rcx, 45
    call Sleep
    jmp .game_over_wait

.quit_game:
    jmp .end_game

.restart_game:
    call reset_game
    jmp game_loop

.next_level:
    ; Verifica qual mapa está carregado agora comparando o ponteiro
    mov r10, [force_next_level]
    mov qword [force_next_level], 0

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
    mov r9, map_width
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
    jne .check_level_4

    cmp r10, 0
    jne .enter_level4_from_level3

    cmp qword [special_item_collected], 0
    je .block_level3_exit

.enter_level4_from_level3:
    call enter_level4
    jmp game_loop

.check_level_4:
    lea rax, [map_data_4]
    cmp rax, rbx
    jne .win_game

    cmp r10, 0
    jne .enter_level5_from_level4

.enter_level5_from_level4:
    call enter_level5
    jmp game_loop

.win_game:
    call GetTickCount64
    sub rax, [game_start_tick]

    mov r11, rax

    mov rax, r11
    xor edx, edx
    mov r10, 60000
    div r10
    mov r8, rax

    mov rax, rdx
    xor edx, edx
    mov r10, 1000
    div r10
    mov r9, rdx
    mov rdx, rax

    lea rcx, [msg_win]
    call printf

.win_game_wait:
    mov rcx, 0x51           ; 'Q'
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .win_quit_game

    mov rcx, 0x52           ; 'R'
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .win_restart_game

    mov rcx, 45
    call Sleep
    jmp .win_game_wait

.win_quit_game:
    jmp .end_game

.win_restart_game:
    call reset_game
    jmp game_loop

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