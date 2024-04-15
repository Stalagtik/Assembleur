section .bss
    number resb 5
    buffer resb 12
section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, number
    mov edx, 5
    int 0x80

    ; Convertir l'entrée de l'utilisateur en un entier
    mov ecx, number
    xor eax, eax

boucleConvertion:
    mov dl, byte [ecx]
    sub dl, '0'
    cmp dl, 9
    ja finConvertion
    imul eax, 10
    add eax, edx
    inc ecx
    jmp boucleConvertion

finConvertion:
    dec eax

    mov ecx, eax
    xor eax, eax

sommeBoucle:
    add eax, ecx
    loop sommeBoucle

    lea ecx, [buffer + 11]
    mov byte [ecx], 0
    mov ebx, 10

itoa_boucle:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz itoa_boucle

    mov eax, 4
    mov ebx, 1
    mov ecx, ecx
    lea edx, [buffer + 11]
    sub edx, ecx
    int 0x80

    mov eax, 1
    mov rdi, 0
    int 0x80
