bits 64
default rel

extern printf
extern Sleep
extern GetAsyncKeyState
extern GetTickCount64

%include "data.asm"

section .text
global main

%include "game.asm"