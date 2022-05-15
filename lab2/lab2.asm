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
    mov     ax, %1             ; получение числа из памяти
    cwde
    call    IntToStr64          ; вызов процедуры
    cmp     rbx, 0              ; сравнение кода возврата
    jne     StrToInt64.Error    ; обработка ошибки         
%endmacro

    section .data
InputMsg db "Enter a, c, k, l", 10
lenInput equ $-InputMsg
aInput db "a = "
aLen equ $-aInput
cInput db "c = "
cLen equ $-cInput
kInput db "k = "
kLen equ $-kInput
lInput db "l = "
lLen equ $-lInput
OutputMsg db "Result: x = "
lenOutput equ $-OutputMsg
ErrorMsg db "c cannot be 0", 10
lenError equ $-ErrorMsg

    section .bss
InBuf resb 10
lenIn equ $-InBuf
OutBuf resb 10
a resw 1
c resw 1
k resw 1
l resw 1
x resw 1

    section .text
    global _start

_start:
    ; ввод
    
    write_string InputMsg, lenInput

    write_string aInput, aLen
    read_string InBuf, lenIn
    StrToInt [a]

    write_string cInput, cLen
    read_string InBuf, lenIn
    StrToInt [c]

    write_string kInput, kLen
    read_string InBuf, lenIn
    StrToInt [k]

    write_string lInput, lLen
    read_string InBuf, lenIn
    StrToInt [l]

    mov ax, [c]
    cmp ax, 0
    je catch

    ; вычисления

    mov AX, [l]  ; ax = l;
    sub AX, [a]  ; ax -= a;
    imul AX      ; ax *= ax; // dx:ax = ax*ax;
    mov BX, [c]  ; bx = c;
    idiv BX      ; ax = dx:ax / bx;
    add AX, [k]  ; ax += k;
    sub AX, [l]  ; ax -= l;
    mov BX, [c]  ; bx = c;
    sar BX, 1    ; bx >> 1;
    add AX, BX   ; ax += bx;
    mov [x], AX  ; x = ax
    
    ; вывод

    xor rbx, rbx
    write_string OutputMsg, lenOutput
    IntToStr [x], OutBuf
    mov RBX, RAX
    write_string OutBuf, RBX
    jmp exit

    catch:
        write_string ErrorMsg, lenError

    exit:
        mov     rax, 60         ; системная функция 60 (exit)
        xor     rdi, rdi        ; return code 0    
        syscall                 ; вызов системной функции