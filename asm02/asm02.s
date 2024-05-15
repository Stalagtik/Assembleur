global _start

section .data
number dd '1337',0

section .bss
input resb 3

section .text

_start:
mov eax, 0
mov edi, 0
mov rsi, input
mov edx, 3
syscall

;--------compare le deuxième byte de l'entré à "4"---------
mov al, [input]
cmp al, 0x34
jne _not_equal

;--------compare le deuxième byte de l'entré à "2"---------
mov al, [input + 1]
cmp al, 0x32
jne _not_equal


mov al, [input + 2]
cmp al, 0x0A
jne _not_equal

;--------si tout les test sont passé, print "1337"---------
mov rax, 1
mov rdi, 1
mov rsi, number
mov rdx, 4
syscall

mov rax, 60
mov rdi, 0
syscall

_not_equal:
mov rax, 60
mov rdi, 1
syscall