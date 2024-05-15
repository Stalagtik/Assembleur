global _start

section .data
    message db 'Entrez un nombre: ', 0xA

section .bss
    number resb 32

section .text

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, 17
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, number
    mov rdx, 32
    syscall

    ;--------Ajuste la taille de l'entrée pour exclure le caractère de nouvelle ligne---------
    sub rax, 1
    mov rcx, rax
    lea rsi, [number]

    xor rdi, rdi

convert_decimal:
    ;--------Convertit les caractères de l'entrée en un entier stocké dans rdi---------
    xor rax, rax
    movzx rax, byte [rsi]
    sub rax, '0'
    cmp rax, 10
    jae estPremier
    imul rdi, rdi, 10
    add rdi, rax
    inc rsi
    loop convert_decimal

estPremier:
    ;--------Détermine si le nombre est premier---------
    cmp rdi, 2
    jb pasPremier
    je premier
    mov rcx, rdi
    shr rcx, 1
    mov rsi, 2

test_prime:
    ;--------Teste pour chaque nombre jusqu'à rdi/2---------
    mov rax, rdi
    xor rdx, rdx
    div rsi
    cmp rdx, 0
    je pasPremier
    inc rsi
    cmp rsi, rcx
    jbe test_prime

premier:
    mov rax, 60 
    mov rdi, 0
    syscall

pasPremier:
    mov rax, 60
    mov rdi, 1
    syscall
