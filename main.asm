bits 64
default rel

segment .data
    msg db "teste para ver se funciona", 0Dh, 0Ah, 0

segment .text
    global main
    extern printf

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32          ; Reserva shadow space para a função externa

    lea rcx, [msg]       ; 1º argumento: ponteiro para a string
    call printf          ; Chama a função printf da biblioteca C do Windows

    xor eax, eax         ; Retorna 0
    add rsp, 32          ; Limpa o shadow space
    pop rbp
    ret