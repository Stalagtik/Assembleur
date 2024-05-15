section .bss
    num1 resb 10
    num2 resb 10
    result resb 21

section .text
    global _start

_start:
    mov rsi, [rsp+16]
    call atoi

    push rax

    mov rsi, [rsp+24+8]
    call atoi

    pop rcx
    add rax, rcx ;

    mov rdi, result
    call itoa

    mov rdx, result + 20
    sub rdx, rsi
    mov rsi, rsi
    mov rdi, 1
    mov rax, 1
    syscall

    xor rdi, rdi
    mov rax, 60
    syscall

atoi:
    xor rax, rax
    .loop:
        movzx rcx, byte [rsi]
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
    mov rbx, 10
    lea rdi, [rdi + 20]
    mov byte [rdi], 0
    mov rsi, rdi


.convert:
    dec rdi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    test rax, rax
    jnz .convert
    mov rsi, rdi

    ret