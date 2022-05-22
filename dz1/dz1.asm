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

    section .bss            ; сегмент неинициализированных переменных
InBuf       resb    10          ; буфер для вводимой строки
lenIn       equ     $-InBuf     ; длина буфера для вводимой строки
result      resb    56
lenRes      equ     $-result

    section .text           ; сегмент кода
    global _start

_start:

    write_string InputMsg, lenInput

    read_string rsp, 56     ; вводим строку

    mov rcx, 0              ; rcx - индекс символа в строке, введенной пользователем
    mov rbx, 1
    mov rdx, 0
    while:
        cmp byte [rsp + rcx], 32        ; сравниваем символ в строке с пробелом
        je end_of_word                 ; иначе прыгаем на end_of_word
        cmp byte [rsp + rcx], 10
        je end_of_word
        not_space:
            test rbx, 1
            jz even
            odd:
                lea rdi, [result + rcx]
                movsb
                jmp continue_not_space
            even:
                xor rax, rax
                mov rax, rcx
                sub rax, rdx
                add rax, 5
                sub rax, rdx
                lea rdi, [result + rax]
                movsb
            continue_not_space:
            inc rdx
            jmp continue
        end_of_word:
            lea rdi, [result + rcx]
            movsb

            xor rdx, rdx
            inc rbx
            cmp byte [rsp + rcx], 10
            je break_while
        continue:
            inc rcx                     ; переходим к следующему символу в строке
            jmp while                   ; переходим к следующей итерации цикла
    break_while:
        xor rbx, rbx

    write_string newLine, 1
    write_string OutputMsg, lenOutput

    ; вывод строки
    write_string newLine, 1
    write_string result, 56

    mov     rax, 60         ; системная функция 60 (exit)
    xor     rdi, rdi        ; return code 0    
    syscall                 ; вызов системной функции