TITLE Project2_turnesar(Project2_turnesar.asm)

; Author: Sarah Turner
; Last Modified : 19JAN2019
; OSU email address : turnesar@oregonstate.edu
; Course number / section: CS271_400
; Project Number : 2              Due Date : 27JAN2019
; Description: Program that gets a user validated range between 1 - 46 and then prints those values with 5 integers per line.
; Also welcomes the user by their defined name in the beginning and says goodbye by defined name at the end. 

INCLUDE Irvine32.inc

UPPER_LIMIT = 46  ;constant upper limit

.data


intro          BYTE  "Freakin' Fibonacci     by Sarah Turner", 0
askName        BYTE  "Please give me your name: ", 0
userName	     BYTE	  33 DUP(0); string to be entered by user
greetUser      BYTE  "Welcome ", 0
directions1    BYTE  "You will enter the number of Fibonacci terms to be displayed.", 0
directions2    BYTE  "Give the number as an integer in the range [1 .. 46]", 0
requestNum     BYTE  "How many Fibonacci terms do you want? ",0
userNumber     DWORD ? ; user input for terms
fibNum1        DWORD 1 ;
fibNumSum      DWORD 0 ; 
fibNum2        DWORD 1 ; 
counter        DWORD 0 ; 
error          BYTE  "Out of range. Enter a number in [1 .. 46]",0
spaces         BYTE  "       ",0
Goodbye        BYTE  "Thank you for playing ",0

.code
main PROC

; introduce myself and prog
          mov  edx, OFFSET intro
          call WriteString
          call CrlF

; get user name and greet
          mov		edx, OFFSET askName
          call	WriteString
          mov		edx, OFFSET userName
          mov		ecx, 32
          call	ReadString
          call crlf
          mov       edx, OFFSET greetUser
          call WriteString
          mov       edx, OFFSET userName
          call WriteString
          mov       al, 33
          call WriteChar
          call crlf

;give directions and get value

          mov       edx, OFFSET directions1
          call WriteString
          call crlf
          mov       edx, OFFSET directions2
          call WriteString
          call crlf
          call crlf
          mov       edx, OFFSET requestNum
          call WriteString
          call ReadInt   
          mov       userNumber, eax
          call crlf
          cmp       eax, UPPER_LIMIT
          jg        INVALID
          cmp       eax, 0
          jle        INVALID         
          ;validate userNumber to be less than 46 and greater than 0
 
VALID: 
     ; initialize for fib sequence after validation 
          mov       eax, fibNum1  
          mov       ecx, userNumber 
          mov       ebx, fibNum2

FIBLOOP:  ;write the integer and then evaluate to see if we need to go to the next line    
          call WriteDec
          mov       edx, OFFSET spaces
          call WriteString
          mov       eax, counter
          add       eax, 1
          mov       counter, eax
          cmp       eax, 5
          je       NEWLINE  ; enters a newline every 5 numbers  
    
DOTHELOOP: ;adds the two numbers in sequence, assign 2nd to 1st number and sum to the second number 
          mov       eax, fibNum1
          mov       ebx, fibNum2
          add       eax, ebx
          mov       fibNumSum, eax
          mov       eax, fibNum2
          mov       fibNum1, eax
          mov       eax, fibNumSum
          mov       fibNum2, eax
          mov       eax, fibNumSum
          mov       eax, fibNum1 ;sets next number to be read 
          loop      FIBLOOP; back to the top of the loop
          jmp       BYEBYE ; goes to the end of program 

NEWLINE:
          call crlf; adds a new line and then jumps back into the fib loop sequence 
          mov eax, 0
          mov counter, eax
          jmp  DOTHELOOP

INVALID :
          mov       edx, OFFSET error
          call WriteString
          call crlf
          mov       edx, OFFSET requestNum
          call WriteString
          call ReadInt
          mov       userNumber, eax
          call crlf
          cmp       eax, UPPER_LIMIT
          jg        INVALID  ;stay in loop if greater than limit 
          cmp       eax, 0
          jle        INVALID ;stay in loop if less than 0 
          cmp       eax, UPPER_LIMIT
          jle       VALID ;valid input go to the valid loop sequence 
  
BYEBYE:
          call crlf
          call crlf
          mov       edx, OFFSET Goodbye
          call WriteString
          mov       edx, OFFSET userName
          call WriteString
          mov       al, 33
          call WriteChar
          call crlf 

exit; exit to operating system

main ENDP

; (insert additional procedures here)

END main
