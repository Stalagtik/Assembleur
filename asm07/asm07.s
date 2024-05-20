section .bss
    number resb 5   ; Buffer pour lire le nombre
    buffer resb 12  ; Buffer pour stocker la sortie

section .text
    global _start

_start:
    ; Lire le nombre de l'entrée standard
    mov eax, 3      ; sys_read
    mov ebx, 0      ; stdin
    mov ecx, number ; adresse du buffer
    mov edx, 5      ; taille du buffer
    int 0x80

    ; Vérifier si aucune donnée n'a été lue
    cmp eax, 0
    je _exit_error  ; sortir avec code d'erreur 1 si aucune donnée n'est lue (eax = 0)

    ; S'il y a une erreur de lecture (eax < 0), gérer également ce cas
    jl _exit_error  ; sortir avec code d'erreur 1 si erreur de lecture (eax < 0)

    mov ecx, number
    xor eax, eax    ; nettoyer eax pour commencer la conversion

_conversion:
    mov dl, byte [ecx]
    sub dl, '0'
    cmp dl, 9
    ja _endconversion  ; finir la conversion si non numérique
    imul eax, 10
    add eax, edx
    inc ecx
    jmp _conversion

_endconversion:
    cmp eax, 1       ; vérifier si le nombre lu est 1
    je _display_zero ; afficher 0 directement si 1
    test eax, eax    ; vérifier si le nombre lu est 0
    jz _display_zero ; afficher 0 directement si 0
    dec eax          ; décrémenter eax pour commencer la somme de n-1 à 1
    mov ebx, eax     ; stocker la valeur de n-1 dans ebx
    xor eax, eax     ; réinitialiser eax pour la somme

_somme:
    add eax, ebx     ; ajouter ebx à eax
    dec ebx          ; décrémenter ebx
    jnz _somme       ; continuer tant que ebx n'est pas 0

    ; Conversion du résultat (eax) en chaîne de caractères pour l'affichage
    mov ebx, 10
    lea ecx, [buffer + 11]
    mov byte [ecx], 0

_loop:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz _loop

    ; Écrire le résultat sur la sortie standard
    mov eax, 4
    mov ebx, 1      ; stdout
    lea edx, [buffer + 11]
    sub edx, ecx
    int 0x80

_exit_success:
    mov eax, 1
    xor ebx, ebx
    int 0x80

_display_zero:
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov byte [ecx], '0'
    mov byte [ecx+1], 0
    mov edx, 1
    int 0x80
    jmp _exit_success

_exit_error:
    mov eax, 1
    mov ebx, 1
    int 0x80
