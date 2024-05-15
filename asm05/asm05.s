section .bss
    num1 resb 10
    num2 resb 10
    result resb 21

section .text
    global _start

_start:
    mov rdi, [rsp]
    cmp rdi, 3
    jl insufficient_args

    ;--------Convertit le premier argument en entier---------
    mov rsi, [rsp+16]
    call atoi
    mov [num1], rax

    ;--------Convertit le deuxième argument en entier---------
    mov rsi, [rsp+24]
    call atoi
    mov [num2], rax

    ;--------Effectue l'addition des deux nombre et stocke le résultat---------
    mov rax, [num1]
    add rax, [num2]

    ;--------Convertit le résultat en chaîne de caractères---------
    mov rdi, result
    call itoa

    lea rsi, [result]
    mov rax, 1
    mov rdi, 1
    mov rdx, 21
    syscall

    xor rdi, rdi
    mov rax, 60
    syscall

insufficient_args:
    mov rdi, 1
    mov rax, 60
    syscall

atoi:
    ;--------Fonction pour convertir une chaîne ASCII en entier---------
    xor rax, rax
    .loop:
        ;--------Charge le caractère actuel qui est dans rsi---------
        movzx rcx, byte [rsi]
        ;--------Vérifie si le caractère est le caractère nul (fin de chaîne)---------
        test rcx, rcx
        jz .done
        sub rcx, '0'
        imul rax, rax, 10
        add rax, rcx
        inc rsi
        jmp .loop
    .done:
        ret

itoa:
    ;--------Fonction pour convertir un entier en chaîne ASCII---------
    mov rbx, 10
    lea rdi, [rdi + 20]
    mov byte [rdi], 0
    .convert:
        dec rdi
        xor rdx, rdx
        div rbx
        add dl, '0'
        mov [rdi], dl
        test rax, rax
        jnz .convert
        ret
