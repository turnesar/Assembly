TITLE Program1(Program1.asm)

; Author: Sarah Turner
; Last Modified :
; OSU email address : turnesar@oregonstate.eduP
; Course number / section: CS271_400
; Project Number : 1               Due Date : 20JAN2019
; Description: Displays name, title, instructions, user enters 2 numbers, shows calculations and terminates

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

numOne         DWORD ? ;  first value for user entry
numTwo         DWORD ? ;  second value for user entry
sum            DWORD ? ;  used to print sum
difference     DWORD ? ;  used to print difference
product        DWORD ? ;  used to print product
quotient       DWORD ? ;  used to print quotient
remainder      DWORD ? ;  used to print remainder
intro1         BYTE  "Simple Math Demo    by Sarah Turner", 0
instruct1      BYTE  "Enter 2 numbers, and then the sum, difference, product, quotient, and remainder will be shown", 0
prompt1        BYTE  "Enter your first number", 0
prompt2        BYTE  "Enter your second number", 0
plusSign       BYTE  " + ", 0; ascii 43
minusSign      BYTE  " - ", 0; ascii 45
multiSign      BYTE  " x ", 0; ascii 120
divSign        BYTE  " ÷ ", 0; ascii character 246
equalSign      BYTE  " = ", 0; ascii character 205
remainString   BYTE  " remainder ", 0
goodBye        BYTE   "Peace out ", 0

.code
main PROC

; introduce myself and prog
mov  edx, OFFSET intro1
call WriteString
call CrlF

; get user numbers
mov  edx, OFFSET prompt1
call WriteString
call ReadInt
mov   numOne, eax
mov   eax, numOne
call CrlF
mov  edx, OFFSET  prompt2
call WriteString
call ReadInt
mov numTwo, eax
mov eax, numTwo
call CrlF


; sum calculation
mov eax, numOne
add eax, numTwo
mov sum, eax
mov eax, numOne
call WriteDec
mov edx, OFFSET plusSign
call WriteString
call CrLF
mov eax, numTwo
call WriteDec
mov edx, OFFSET equalSign
call WriteString
call CrLF
mov eax, sum
call WriteDec

; difference calculation
mov eax, numOne
sub eax, numTwo
mov difference, eax
mov eax, numOne
call WriteDec
mov edx, OFFSET minusSign
call WriteString
call CrLF
mov eax, numTwo
call WriteDec
mov edx, OFFSET equalSign
call WriteString
call CrLF
mov eax, difference
call WriteDec


; product calculation
mov eax, numOne
mov ebx, numTwo
mul ebx
mov product, eax
mov eax, numOne
call WriteDec
mov edx, OFFSET multiSign
call WriteString
call CrLF
mov eax, numTwo
call WriteDec
call Crlf
mov edx, OFFSET equalSign
call WriteString
call CrLF
mov eax, product
call WriteDec
call crlf


; quotient and remainder calculation
mov eax, numOne
mov ebx, numTwo
mov edx, 0
div ebx
mov quotient, eax
mov remainder, edx
mov eax, numOne
call WriteDec
; mov ah, 246
; call WriteDec
; call WriteString
call CrLF
mov eax, numTwo
call WriteDec
mov edx, OFFSET equalSign
call WriteString
call CrLF
mov eax, quotient
call WriteDec
mov edx, OFFSET remainString
call WriteString
call CrLF
mov eax, remainder
call WriteDec


; print goodbye
mov  edx, OFFSET goodBye
call WriteString
call Crlf

exit; exit to operating system
main ENDP

; (insert additional procedures here)

END main
