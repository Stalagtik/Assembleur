section .data
    msg_error db "Erreur: veuillez entrer un nombre entier positif.", 0
    buffer db "Veuillez entrer un nombre: ", 0
    msg_zero db "0", 0

section .bss
    num resb 5
    output resb 20

section .text
    global _start

_start:
    ;lire les paramètres de la ligne de commande
    pop rax             ;nombre de paramètres (incluant le nom du programme)
    pop rsi             ;sauter le nom du programme

    cmp rax, 2          ;vérifier si deux paramètres sont fournis
    je _param_provided  ;aller à _param_provided si vrai
    cmp rax, 1          ;vérifier si un seul paramètre est fourni
    je _no_param_provided ; aller à _no_param_provided si vrai

    jmp _error          ;aller à _error si aucune des conditions n'est remplie

_param_provided:
    pop rsi             ;obtenir le premier paramètre
    jmp _convert_param  ;aller à _convert_param

_no_param_provided:
    ;afficher le message pour entrer un nombre
    mov rax, 1          ;sys_write
    mov rdi, 1          ;file descriptor 1 (stdout)
    mov rsi, buffer     ;message à afficher
    mov rdx, 27         ;taille du message
    syscall

    ;lire l'entrée de l'utilisateur
    mov rax, 0          ;sys_read
    mov rdi, 0          ;file descriptor 0 (stdin)
    mov rsi, num        ;buffer pour lire l'entrée
    mov rdx, 5          ;taille du buffer
    syscall

    ;vérifier si aucune entrée n'a été fournie
    cmp rax, 0
    je _error           ;aller à _error si aucune entrée

    ;supprimer le saut de ligne si présent
    dec rax
    cmp byte [rsi+rax], 10
    jne _check_empty_input
    mov byte [rsi+rax], 0

_check_empty_input:
    cmp byte [rsi], 0
    je _error           ;aller à _error si l'entrée est vide

    mov rsi, num        ;déplacer le pointeur sur le buffer d'entrée

_convert_param:
    ;conversion de la chaîne en entier
    xor rax, rax        ;initialiser rax à 0
    xor rcx, rcx        ;initialiser rcx à 0
    xor rdx, rdx        ;initialiser rdx à 0
    mov r9, 10          ;base 10

_AtoI:
    movzx rbx, byte [rsi + rcx]
    cmp rbx, 0          ;fin de chaîne
    je _done_conversion ;aller à _done_conversion si fin de chaîne
    sub rbx, '0'
    cmp rbx, 0
    jb _error           ;aller à _error si caractère non valide
    cmp rbx, 9
    ja _error           ;aller à _error si caractère non valide

    imul rax, r9        ;multiplier rax par 10
    add rax, rbx        ;ajouter la valeur numérique du caractère
    inc rcx             ;avancer au caractère suivant
    jmp _AtoI           ;boucle jusqu'à la fin de la chaîne

_done_conversion:
    ;si le nombre est zéro, afficher zéro et terminer avec succès
    cmp rax, 0
    je _print_zero      ;aller à _print_zero si le nombre est 0

    ;calcul de la somme de 1 à N-1
    mov r11, rax        ;sauvegarder le nombre initial
    xor rax, rax        ;initialiser la somme à 0
    xor rcx, rcx        ;initialiser le compteur à 0

_calculate_sum:
    inc rcx             ;incrémenter le compteur
    cmp rcx, r11
    jge _done_sum       ;aller à _done_sum si le compteur atteint le nombre
    add rax, rcx        ;ajouter le compteur à la somme
    jmp _calculate_sum  ;boucle jusqu'à atteindre le nombre

_done_sum:
    ;conversion du résultat en chaîne
    lea rsi, [output + 20]
    mov byte [rsi], 0
    mov rbx, 10

_convert_to_string:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz _convert_to_string

_print_result:
    ;afficher le résultat
    mov rax, 1          ;sys_write
    mov rdi, 1          ;file descriptor 1 (stdout)
    lea rdx, [output + 20]
    sub rdx, rsi
    mov rsi, rsi
    syscall

    ;terminer le programme avec un code de sortie 0 (succès)
    mov rax, 60         ;sys_exit
    xor rdi, rdi
    syscall

_print_zero:
    ;afficher zéro
    mov rax, 1          ;sys_write
    mov rdi, 1          ;file descriptor 1 (stdout)
    mov rsi, msg_zero
    mov rdx, 1          ;taille du message
    syscall

    mov rax, 60         ;sys_exit
    syscall

_error:
    ;sorti 1 si erreur
    mov rax, 1          ;sys_write
    mov rdi, 1          ;file descriptor 1 (stdout)
    mov rsi, msg_error
    mov rdx, 48         ;taille du message d'erreur
    syscall

    ;terminer le programme avec un code de sortie 1 (échec)
    mov rax, 60         ; sys_exit
    mov rdi, 1
    syscall
