TITLE Project4_turnesarV2(Project4_turnesarV2.asm)

; Author: Sarah Turner
; Last Modified : 10Feb2019
; OSU email address : turnesar@oregonstate.edu
; Course number / section: CS271_400
; Project Number : 4              Due Date : 17FEB2019
; Description: Program that gets users name and greets them, gets a validated number
; between 1 - 400.  program calculates and displays all composite numbers up to and
; including the nth composite.  10 per line displayed. EC for aligning numbers

INCLUDE Irvine32.inc

LOWER_LIMIT EQU 1;
UPPER_LIMIT EQU 400;

.data


intro          BYTE  "Composites     by Sarah Turner", 0; name of program
introExtra     BYTE  "---**EC: output columns are aligned** ---", 0; extra credit note
directions     BYTE  "Please enter the amount of composite numbers to calculate in the range from 1 to 400", 0; 
requestNum     BYTE  "Enter number: ", 0
error          BYTE  "The number you entered is out of range [1-400], enter another number", 0; invalid input
userNumber     DWORD ? ; user input for number of composites desired
newLine        DWORD 2; used to count numbers until a newline is needed
compNum        DWORD 4; holds the composite numbers
primeTest      DWORD 2, 3, 5, 7, 1; used to determine if composite or prime
singleSpaces   BYTE  "       ", 0; spaces between single digit numbers
doubleSpaces   BYTE  "      ", 0; spaces between double digit numbers
tripleSpaces   BYTE  "     ", 0; spaces between triple digit numbers
Goodbye        BYTE  "Whew, all done, thanks!  Verified by Sarah Turner", 0; ending message 

.code
; *****************INTRODUCTION********************
; 
;    introduction
;    description: displays introdution, title and author, extra credit request and directions 
;    receives: n / a
;    returns: n / a
;    preconditions: n/a
;    registers changed: EDX 
; ********************************************************
introduction PROC
     ;title author and extra credit 
          mov       edx, OFFSET intro
          call WriteString
          call crlf
          call crlf 
          mov       edx, OFFSET introExtra
          call WriteString 
          call crlf 
          call crlf 

     ;give instructions to user
          mov       edx, OFFSET directions
          call WriteString
          call crlf

          ret            ;return to main 
introduction ENDP

; **********************************GETUSERINPUT*************
;
;  getUserData
;     description: Takes input for printing composites, calls validation
;                  stores value in userNumber variable  
;     Receives: eax into userNumber 
;     returns: n / a
;     preconditions: processes numbers only
;     registers changed: ECX has userNumber and ECX has userNumber, EDX has request for number 
; ******************************************************
getUserData PROC

     GETDATA:
     ;gets user input for number of composites  
          mov       edx, OFFSET requestNum
          call WriteString
          call ReadInt 
          mov       userNumber, eax
          call      validate ;calls validate to make sure the number is good
          cmp       eax, 0
          je        GETDATA         
          mov       ecx, userNumber 
          mov       eax, compNum 
          ret       ;return to main  
getUserData    ENDP

; ****************************VALIDATION*************************
;
;    validation
;      gets user input and compares to upper and lower limit, returns  
;     Receives: EAX has userNumber
;     Returns: modifiied EAX based on valid or invalid input 
;     preconditions: recieves number from getUserData
;     registers changed: EAX change to zero reflects invalid input, EDX could have error message 
;*****************************************************************
validate  PROC
     ;validation of number using constants 1-400
          cmp       eax, LOWER_LIMIT    ;comparison to lower limit of 1
          jl        INVALID   
          cmp       eax, UPPER_LIMIT  ;testing for upper limit of 400  
          jg        INVALID    
          jmp       VALID     ;else is valid input 

     VALID:
          ret                                ;return to getUserData 

     INVALID: 
          mov       edx, OFFSET error        ;display error 
          call WriteString
          call crlf
          mov       eax, 0
          mov       userNumber, eax
          ret       ;return to getUserData  
                             
validate  ENDP

; **************************SHOW COMPOSITES*********************
; showComposites
;    description: loops through to print composites and starts newline every 10 numbers, calls isComposite to verify numbers 
;    Receives: userNUmber into ecx like 'for' loop, current composite number in eax 
;    Returns: n/a 
;    preconditions: userNumber is verified to be greater than 0
;    registers changed: modifies EAX to increment through composites, decrements ECX to run LOOPNZ, EDX will have spaces in it 
;*********************************************************************
showComposites  PROC 

     .IF (eax <=7) ;special if needed because numbers less than and equal to 7 will not work in isComposite 
     LOWNUM:   
           mov        eax, compNum
           call WriteDec
           add        eax, 2
           mov        compNum, eax
           mov        edx, OFFSET singleSpaces
           call WriteString
           sub        ecx, 1
           mov        userNumber, ecx   
           cmp        ecx, 0            ;check to ensure not all composites have been printed yet 
           je         RETURN
           cmp        eax, 8
           je         GETCOMPOSITE      ;numbers are high enough to leave this loop 
           jmp        LOWNUM
     .ENDIF

     GETCOMPOSITE:  
           call isComposite        ;call to check if number is composite or prime 
           mov       eax, compNum    
           call WriteDec
           cmp       eax, 10        ;different spacing depending on the number of digits aligns columns
           jl        SINGLE
           cmp       eax, 100
           jl        DOUBLE
           jmp       TRIPLE

     COMEBACK : ;return to loop after printing spaces 
           add      eax,1
           mov       compNum, eax
           mov       ebx, newLine 
           add       ebx, 1
           mov       newLine, ebx
           cmp       ebx, 10
           je        ADDNEWLINE; enters a newline every 10 numbers after comparing to counter   

     BACKFROMNEW: 
           LOOPNZ    GETCOMPOSITE  ;will exit loop with userNumber decrements to zero, goes to return  
           ret        ;return to main   
                
     ADDNEWLINE:
          call crlf; adds a new line if needed and then jumps back into composite loop sequence 
          mov       ebx, 0
          mov       newLine, ebx
          jmp       BACKFROMNEW 

     SINGLE:        ;provides spaces for single digits 
          mov       edx, OFFSET singleSpaces
          call WriteString
          jmp       COMEBACK

     DOUBLE:        ;provides spaces for double digits 
          mov        edx, OFFSET doubleSpaces
          call WriteString
          jmp       COMEBACK

     TRIPLE:        ;provides spaces for triple digits 
          mov        edx, OFFSET tripleSpaces
          call WriteString
          jmp       COMEBACK 
           

RETURN: 
           ret 
showComposites ENDP 

;********************IS COMPOSITE********************
;
;   isComposite
;      description: determines numbers that are composites my dividing them by 2,3,5,7. Any
                    0 remainder integer is a composite. When '1' is reached
;                   in array then number with no remainders previously then it is a prime. 
;      receives: last composite in eax 
;      returns:  updated composite in eax 
;      preconditions: recevies incremented number in eax 
;      registers changed: EBX contains array integers, EAX modifed as stated, EDX contains remainders
;********************************************************
isComposite    PROC 

NEWNUM: 
          mov       esi, OFFSET primeTest   ;resets the array of divisors 
 
NEXTCOMP: 
          mov       edx, 0                   ;preps for remainder 
          mov       eax, compNum
          mov       ebx, [esi]               ;divide by number in array 
          div       ebx
          mov       eax, compNum             ;move back the original number 
          cmp       edx, 0
          je        FOUNDONE                 ;composite number found 
          inc       esi                      ;go to next number in array 
          mov       ebx, [esi]
          cmp       ebx, 1                   ;show if we are at the end of divisors
          je        NEXTNUM                  ;this number is prime, need to increment 
          jmp       NEXTCOMP                 ;loop back through and divide by the next number in array 
         
NEXTNUM:  ;increment number and start whole isComposite cycle again for next number                 
          add  eax, 1
          mov compNum, eax  
          jmp NEWNUM  
               
FOUNDONE:
           ret           ;returns to showComposites with compNum in EAX as the next composite number 
isComposite  ENDP

; ***********************************BYEBYE*******************
;  farewell
;     description: prints a farewell message by programmer
;     receives: n / a
;     returns: n / a
;     precondition: n/a
;     registers changed: EDX has farewell message  
; ***********************************************************

farewell PROC
     ; displays goodbye message
          call crlf
          mov       edx, OFFSET Goodbye
          call WriteString
          call crlf
          ret ;return to main 

farewell  ENDP

; **********************************MAIN****************************
; main
;    description: calls processes for program 
;    receives: n / a
;    returns: n / a
;    preconditions: none
;    registers changed: none  
;****************************************************************
main PROC 

call introduction
call getUserData
call showComposites
call farewell 

exit 

main ENDP

; (insert additional procedures here)

END main
