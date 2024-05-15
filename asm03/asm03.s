global _start

section .data
    number db '1337', 0x0A

section .text

_start:
    ;--------Vérifie si aucun argument n'est passé---------
    mov rdi, [rsp]
    cmp rdi, 1
    je no_args

    ;--------Récupère le premier argument passé au programme---------
    mov rsi, [rsp + 16]

    ;--------Compare le premier caractère de l'argument à "4"---------
    mov al, [rsi]
    cmp al, 0x34
    jne not_42

    ;--------Compare le deuxième caractère de l'argument à "2"---------
    mov al, [rsi + 1]
    cmp al, 0x32
    jne not_42

    ;--------Vérifie si le troisième caractère est un caractère nul (pour vérifié si c'est bien la fin de la chaine)---------
    mov al, [rsi + 2]
    cmp al, 0x00
    jne not_42

    ;--------Si tous les test sont passés, affiche "1337"---------
    mov rax, 1
    mov rdi, 1
    mov rsi, number
    mov rdx, 5
    syscall


    mov rax, 60
    mov rdi, 0
    syscall

not_42:
    mov rax, 60
    mov rdi, 1
    syscall

no_args:
    mov rax, 60
    mov rdi, 1
    syscall
