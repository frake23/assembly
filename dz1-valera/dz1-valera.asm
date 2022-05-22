%include "./lib64.asm"

%macro write_string 2
    ; вывод
    ; 1 - адрес строки, 2 - длина строки
    mov     rax, 1          ; системная функция 1 (write)
    mov     rdi, 1          ; дескриптор файла stdout=1
    mov     rsi, %1         ; адрес выводимой строки
    mov     rdx, %2         ; длина строки
    syscall                 ; вызов системной функции
%endmacro

%macro read_string 2
    ; ввод
    ; 1 - буфер ввода, 2 - длина буфера ввода
    mov     rax, 0          ; системная функция 0 (read)
    mov     rdi, 0          ; дескриптор файла stdin=0
    mov     rsi, %1         ; адрес вводимой строки
    mov     rdx, %2         ; длина строки
    syscall                 ; вызов системной функции
%endmacro

%macro StrToInt 1
    ; перевод string в integer
    ; rsi должен содержать адрес строки для преобразования
    call    StrToInt64          ; вызов процедуры
    cmp     rbx, 0              ; сравнение кода возврата
    jne     StrToInt64.Error    ; обработка ошибки
    mov     %1, eax            
%endmacro

%macro IntToStr 2
    ; перевод integer в string
    mov     rsi, %2
    mov     eax, %1             ; получение числа из памяти
    cwde
    call    IntToStr64          ; вызов процедуры
    cmp     rbx, 0              ; сравнение кода возврата
    jne     StrToInt64.Error    ; обработка ошибки         
%endmacro

    section .data           ; сегмент инициализированных переменных
InputMsg    db      "Enter the line:", 10
lenInput    equ     $-InputMsg
OutputMsg   db      "Result line:"
lenOutput   equ     $-OutputMsg
newLine     db      10
spacesBuff db "                    "

    section .bss            ; сегмент неинициализированных переменных
InBuf       resb    10          ; буфер для вводимой строки
lenIn       equ     $-InBuf     ; длина буфера для вводимой строки
result      resb    64
lenRes      equ     $-result

wordBuff resb 20
buff    resb    16
startAddress resb   16
endAddress    resb   16
minStart resb 16
wlen resb 16
len resb 16

    section .text           ; сегмент кода
    global _start

_start:

    write_string InputMsg, lenInput

    sub rsp, 64

    read_string rsp, 64     ; вводим строку

    cld
    mov rbx, 3
    mov al, 32

    cycle:
        mov rdx, 1
        ; находим первое слово
        lea rdi, [rsp]
        mov ecx, 64
        repe scasb ; находим адрес начала слова
        sub rdi, 1
        mov [startAddress], rdi
        repne scasb ; находим адрес конца слова
        sub rdi, 1
        mov [endAddress], rdi
        push rdi
        mov rcx, [endAddress]
        sub rcx, [startAddress]
        mov [wlen], rcx
        mov rsi, [startAddress]
        mov [minStart], rsi
        lea rdi, [wordBuff]
        rep movsb
        cmp rdx, rbx
        je break_cmp_cycle
        cmp_cycle:
            pop rdi
            mov ecx, 64
            repe scasb ; находим адрес начала слова
            sub rdi, 1
            mov [startAddress], rdi
            repne scasb ; находим адрес конца слова
            push rdi
            sub rdi, 1
            mov [endAddress], rdi
            mov rcx, [endAddress]
            sub rcx, [startAddress]
            mov rsi, [startAddress]
            lea rdi, [wordBuff]
            repe cmpsb
            jbe less
            jmp continue_cmp_cycle
            less:
                mov rcx, [endAddress]
                sub rcx, [startAddress]
                mov [wlen], rcx
                mov rsi, [startAddress]
                lea rdi, [wordBuff]
                mov [minStart], rsi
                rep movsb
        continue_cmp_cycle:
            pop rdi
            inc rdx
            cmp rdx, rbx
            jne cmp_cycle
        break_cmp_cycle:
        mov rcx, [wlen]
        mov rdi, [minStart]
        lea rsi, [spacesBuff]
        rep movsb
        dec rbx
        mov rcx, [len]
        lea rdi, [result + rcx]
        mov rcx, [wlen]
        lea rsi, [wordBuff]
        rep movsb
        lea rsi, [spacesBuff]
        movsb
        mov rcx, [len]
        add rcx, 1
        add rcx, [wlen]
        mov [len], rcx
        cmp rbx, 0
        jne cycle

    write_string newLine, 1
    write_string OutputMsg, lenOutput

    ; вывод строки
    write_string newLine, 1
    write_string result, 64
    write_string newLine, 1

    mov     rax, 60         ; системная функция 60 (exit)
    xor     rdi, rdi        ; return code 0    
    syscall                 ; вызов системной функции