    global _Z14reverse_stringPcPsS_
    extern _Z6outputc

    section .data

    section .bss

    section .text

_Z14reverse_stringPcPsS_:
    ; [rbp - 8] - source
    ; [rbp - 16] - indexes
    ; [rbp - 24] - result
    ; [rbp - 26] - счетчик массива с индексами
    ; [rbp - 28] - счетчик слов
    ; [rbp - 30] - счетчик

    push rbp
    mov rbp, rsp

    push rdi
    push rsi
    push rdx

    sub rsp, 6

    cld
    
    mov rbx, 0
    mov rsi, [rbp - 8]
    mov rdi, [rbp - 24]

    xor rdx, rdx

    while:

        mov rdx, [rbp - 16]
        add dl,  [rbp - 26]
        mov word bx, [rdx]
        cmp bx, 0
        je copy_rest
        while_not_found:
            mov al, [rsi]
            cmp al, 32
            jne continue_while
            cmp al, 0
            je break
            movsb
            jmp while_not_found
            continue_while:

            inc word [rbp - 28]
            mov ax, [rbp - 28]
            cmp ax, bx
            je reverse_word
            
            continue_word:
            mov al, [rsi]
            cmp al, 32
            je while_not_found
            movsb
            jmp continue_word
            reverse_word:
                push rbx
                push rsi
                mov rbx, 0
                start_reverse:
                    xor rax, rax
                    mov rax, [rsi + rbx]
                    cmp al, 32
                    je continue_reversing
                    cmp al, 0
                    je continue_reversing
                    push rax
                    inc rbx
                    jmp start_reverse
                continue_reversing:
                    mov [rbp - 32], bx
                    cont_rev:
                    cmp rbx, 0
                    je break_reverse
                    mov rsi, rsp
                    movsb
                    pop rax
                    dec rbx
                    jmp cont_rev
                break_reverse:
                    pop rsi
                    add si, [rbp - 32]
                    pop rbx
                    add word [rbp-26], 2
                    jmp while
    copy_rest:
        mov al, [rsi]
        cmp al, 0
        je break
        movsb
        jmp copy_rest
    break:
        mov word [rbp-26], 0
        lea rsi, [rbp - 26]
        movsb


    mov rsp, rbp
    pop rbp

    ret