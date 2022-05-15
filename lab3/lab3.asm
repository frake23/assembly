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

    section .data
InputMsg db "Enter a, x, k", 10
lenInput equ $-InputMsg
aInput db "a = "
aLen equ $-aInput
kInput db "k = "
kLen equ $-kInput
xInput db "x = "
xLen equ $-xInput
OutputMsg db "Result: f = "
lenOutput equ $-OutputMsg
ErrorMsg db "k cannot be 0", 10
lenError equ $-ErrorMsg

    section .bss
InBuf resb 10
lenIn equ $-InBuf
OutBuf resb 10
lenOut equ $-OutBuf
a resw 1
x resw 1
k resw 1
f resd 1

    section .text
    global _start

_start:
    ; ввод
    
    write_string InputMsg, lenInput

    write_string aInput, aLen
    read_string InBuf, lenIn
    StrToInt [a]

    write_string xInput, xLen
    read_string InBuf, lenIn
    StrToInt [x]
    
    write_string kInput, kLen
    read_string InBuf, lenIn
    StrToInt [k]

    mov ax, [k]
    cmp ax, 0
    je catch

    ; вычисления

    mov ax, [a]
    mov bx, [k]
    imul bx
    cmp dx, 0
    jge greater
    less:
        mov ax, [a]
        imul bx
        mov cx, dx
        shl ecx, 16
        mov cx, ax
        mov ax, 120
        xor dx, dx
        idiv bx
        add cx, ax
        mov eax, ecx
        jmp continue
    greater:
        cmp ax, 0
        je less
        mov ax, [a]
        mov bx, [x]
        imul bx
        shl edx, 16
        mov dx, ax
        mov eax, edx
    continue:
        mov [f], eax

    ; вывод

    xor rbx, rbx
    write_string OutputMsg, lenOutput
    IntToStr [f], OutBuf
    mov RBX, RAX
    write_string OutBuf, RBX
    jmp exit

    catch:
        write_string ErrorMsg, lenError

    exit:
        mov     rax, 60         ; системная функция 60 (exit)
        xor     rdi, rdi        ; return code 0    
        syscall                 ; вызов системной функции