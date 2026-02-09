
org 100h

.model small
.stack 100h

.data

pin         db '1234$'
inputPin    db 5 dup('$')

menuMsg db 10,13,'===== SECURITY SYSTEM MENU =====',10,13
        db '1. Arm System',10,13
        db '2. Disarm System',10,13
        db '3. Simulate Intruder',10,13
        db '4. Exit',10,13
        db 'Enter choice: $'

loginMsg    db 10,13,'Enter PIN: $'
successMsg  db 10,13,'Access Granted!$'
failMsg     db 10,13,'Wrong PIN! Try Again.$'

armedMsg    db 10,13,'System Armed.$'
disarmedMsg db 10,13,'System Disarmed.$'

alertMsg    db 10,13,'*** INTRUDER DETECTED ***$'
alarmMsg    db 7,7,7,' ALARM ACTIVATED!$'

newline db 10,13,'$'

armedFlag db 0

.code

; ============================================
main proc

    mov ax, @data
    mov ds, ax

; ------------ LOGIN --------------
login:

    mov dx, offset loginMsg
    mov ah, 09h
    int 21h

    ; take 4 characters input
    mov cx, 4
    mov si, offset inputPin

readPin:
    mov ah, 01h
    int 21h
    mov [si], al
    inc si
    loop readPin

    ; compare PIN
    mov si, offset inputPin
    mov di, offset pin
    mov cx, 4

compare:
    mov al, [si]
    cmp al, [di]
    jne wrong
    inc si
    inc di
    loop compare

    mov dx, offset successMsg
    mov ah, 09h
    int 21h
    jmp menu

wrong:
    mov dx, offset failMsg
    mov ah, 09h
    int 21h
    jmp login


; ------------ MENU --------------
menu:

    mov dx, offset menuMsg
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    je arm

    cmp al, '2'
    je disarm

    cmp al, '3'
    je intruder

    cmp al, '4'
    je exit

    jmp menu


; ------------ ARM --------------
arm:
    mov armedFlag, 1

    mov dx, offset armedMsg
    mov ah, 09h
    int 21h
    jmp menu


; ------------ DISARM --------------
disarm:
    mov armedFlag, 0

    mov dx, offset disarmedMsg
    mov ah, 09h
    int 21h
    jmp menu


; ------------ INTRUDER --------------
intruder:

    cmp armedFlag, 1
    jne safe

    mov dx, offset alertMsg
    mov ah, 09h
    int 21h

    mov dx, offset alarmMsg
    mov ah, 09h
    int 21h

    jmp menu

safe:
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp menu


; ------------ EXIT --------------
exit:
    mov ah, 4Ch
    int 21h

main endp
end main

ret





