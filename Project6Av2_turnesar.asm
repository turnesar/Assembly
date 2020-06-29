TITLE Project6Av2_turnesar(Project6Av2_turnesar.asm)

; Author: Sarah Turner
; Last Modified : 14MAR2019
; OSU email address : turnesar@oregonstate.edu
; Course number / section: CS271_400
; Project Number : 6A              Due Date : 17MAR2019
; Description: Implements ReadVal(string->int) & WriteVal(int->string) procedures and macros for getString and displayString
; gets 10 valid integers(32 bit or less) from the user and stores the numbers in an array using readVal.Displays the
; integers, their sum, and their average using writeVal .Unsigned integers from user input are validated inside readVal.

INCLUDE Irvine32.inc

; *****************************getString MACRO******************************
;    description: macro that displays prompt, saves input and inputSize into memory locations
;    receives: prompt string reference, string input by reference, length of input by value
;    returns: n / a
;    preconditions: prompt, input are addresses, size of input is by value
;    registers changed : edx, ecx
; **********************************************************************
getString           MACRO   prompt, input, inputSize
push  ecx
push  edx

     mov       edx, prompt
     call WriteString
     mov       edx, input
     mov       ecx, inputSize
     call ReadString

pop edx
pop ecx
ENDM

; ********************************displayString*************************
;    description: macro that displays string passed by reference
;    receives: string address
;    returns: n / a
;    preconditions: string address passed
;    registers changed : edx
; ******************************************************************
displayString       MACRO  memoryLoc
push edx

     mov       edx, memoryLoc
     call WriteString

pop edx
ENDM

; end of the macro section


.data


intro1         BYTE  "Prog 6, Low level IO    by Sarah Turner", 0          ;  name of program
intro2         BYTE  "Please provide 10 unsigned decimal integers.  ", 0
intro3         BYTE  "Each number needs to fit inside a 32 bit register.  ", 0
intro4         BYTE  "After you have finished putting in the 10 numbers, I will display a list of them, their sum, and average value.  ", 0
requestNum     BYTE  "Please enter an unsigned integer ", 0
error          BYTE  "Ummm...unsigned integer that fits in the 32 bit register please: ", 0
list           BYTE  "You entered these numbers: ", 0
stringOne      BYTE  15 DUP(?)          ; used for displayList
stringTwo      BYTE  15 DUP(?)          ; used for sumAvg 
sumOf          BYTE  "Sum of integers is: ", 0
avgOf          BYTE  "Average of integers is: ", 0
arrayNum       DWORD 10 DUP(0)          ; array of 10 to hold numbers
spaces         BYTE  "       ", 0       ; spaces between  numbers, used in displayList 
goodBye        BYTE  "Whew, this one took embarrassingly long, but now we're done!", 0


.code
; **********************************MAIN****************************
; main
;    description: calls processes for program
;    receives: n / a
;    returns: n / a
;    preconditions: none
;    registers changed : none
; ****************************************************************
main PROC

     push OFFSET intro1
     push OFFSET intro2
     push OFFSET intro3
     push OFFSET intro4
     call introduction        ;displays strings that are pushed

     push OFFSET error
     push OFFSET arrayNum
     push OFFSET requestNum
     call getUserData         ;cycles through arrayNum to add inputs and calls subprocedure readVal  

     push OFFSET stringOne
     push OFFSET arrayNum
     push OFFSET list
     push OFFSET spaces
     call displayList         ;cycles through arrayNum and calls subprocedure WriteVal to display them 

     push OFFSET stringTwo
     push OFFSET arrayNum
     push OFFSET sumOf
     push OFFSET avgOf
     call sumAverage          ;calculates sum and average and calls subprocedure writeVal to display them 

     push OFFSET goodBye
     call byebye

exit

main ENDP

; *****************INTRODUCTION********************
;
;    introduction
;    description: displays introduction, title and author, and directions
;    receives: @intro4 20
;              @intro3 16
;              @intro2 12
;              @intro1 8 
;    returns: n / a
;    preconditions: n / a
;    registers changed : EDX
; ********************************************************
introduction PROC

          push ebp
          mov       ebp, esp

          displayString[ebp + 20] ; intro1
          call crlf
          call crlf
          displayString[ebp + 16]; intro2
          call crlf
          displayString[ebp + 12]; intro3
          displayString[ebp + 8]; intro4
          call crlf
          call crlf

          pop ebp
          ret 16
introduction ENDP

; **********************************getUserData*************
;
;  getUserData
;     description: cycles through array, calls subprocedure readVal for each index
;                  to convert string input to integer. 
;     Receives:
;               @error       16
;               @arrayNum    12
;               @requestNum  8 
;     returns: n / a
;     preconditions: none  
;     registers changed : edi, ecx    
; ******************************************************
getUserData PROC

          push ebp
          mov       ebp, esp

          mov        ecx, 10            ;loop counter for array 
          mov        edi, [ebp + 12]    ; array

     GETDATA:
          push [ebp + 16]               ; error string
          push [ebp + 8]                ; request Number string 
          push  edi                     ; array index by address 
          call readVal

          ; mov eax, [edi]   used for testing
          ; call WriteInt

          add        edi, 4             ; next spot in array
          loop GETDATA


          ; mov edi, [ebp + 12]  used for testing 
          ; mov ecx, 10
          ; looptest:
          ; mov eax, [edi]
          ; call WriteInt
          ; add edi, 4
          ; loop looptest


          pop ebp
          ret 12
getUserData    ENDP


; **************************displayList*********************
; displayList
;    description: loops through array and calls subprocedure writeVal to translate array Int to string 
;    Receives:
;           @ string 20
;           @ arrayNum 16
;           @ list 12
;           @ spaces 8 
;    Returns: n / a
;    registers changed : esi, ecx, eax 
;    reference:
; *******************************************************************
displayList  PROC
          push ebp
          mov        ebp, esp

          displayString[ebp + 12]            ; string to introduce list
          call crlf
     
          mov       esi, [ebp + 16]          ; array starting address
          mov       ecx, 10                  ; number of integers to print
     PRINT:
          push [ebp + 20]; string
          mov       eax, [esi]
          push eax                           ; push value of array index
          call WriteVal
          displayString[ebp + 8]             ; display spaces
          add esi, 4                         ; increment to next array value
          loop PRINT

          call crlf
          pop ebp
          ret 16

displayList ENDP

; **********************************sumAverage*******************
;  sumAverage
;     description: receives an array and calculates and displays the sum and average
;                   calls subprocedure writeVal to display them                     
;     receives:
;               @ string 20
;               @ arrayNum 16
;               @ sumOf 12
;               @ avgOf 8
;     returns: n / a
;     precondition: assumes array is already sorted
;     registers changed : esi, eax, edx, ebx
; ***********************************************************
sumAverage PROC

               push ebp
               mov       ebp, esp
               call crlf
               mov       esi, [ebp + 16]          ; array
               mov       ecx, 9                   ;9 because we load the first value before the loop 
               mov       eax, [esi]               ;load first value of array into eax 

               displayString[ebp + 12]            ; string introducing sum

     SUM:
               add       esi, 4                   ;increment to next value 
               mov       ebx, [esi]
               add       eax, ebx                 ;sum them 
               loop      SUM

               push[ebp + 20]                     ; string
               push eax                           ;push sum value 
               call      WriteVal
               call crlf

               mov       edx, 0
               mov       ebx, 10
               div ebx                            ;now average is in eax 

               displayString[ebp + 8]             ;string introducing average 

               push[ebp + 20]                     ;string 
               push eax                           ;push average value 
               call WriteVal
               call crlf

               pop ebp
               ret 16

sumAverage  ENDP

; ********************WriteVal********************
;
;   writeVal
;      description: This takes the integer provided by value, first we get a count and divide by factors of ten while pushing the 
;                   remainder.  So '123' divided by 10, is 12 R 3. We now have a stack of the number where the top is the first number,
;                   and we have a count in ecx.  Next we pop each value into our local DWORD then move it into al by setting is a BYTE with PTR  
;                   finally we add 48 to convert it to its correct char value per the ascii table, and store the values in the string provided.
;                   then call display on the string 
;      receives:  @string 12
;                 number 8 
;      returns:   n / a
;      preconditions: value of number has already been validated by previous procedures 
;      registers changed : eax, ebx, ecx, edx, edi
;      references: demo6.asm and page 301 (LOCAL directive)
;                  went down the rabbit hole reading about ATODW in M32lib and borrowed some logic for my translation 
;            site: http://www.masmforum.com/board/index.php?PHPSESSID=786dd40408172108b65a5a36b09c88c0&topic=1774.0         
; ********************************************************
writeVal    PROC
     LOCAL temp:DWORD ;local variable used for translating remainders to the string 
          push eax
          push ebx
          push ecx
          push edx
          push edi

          mov       eax, [ebp + 8]      ; we are printing this number 
          mov       ecx, 0              ; initialize our counter

     ReverseCount:
          mov       edx, 0              ; get ready to divide and conquer
          mov       ebx, 10
          div ebx                       ; dividing our number by 10 will let us translate it one numero at a time 
          push edx                      ; push remainder
          inc ecx             
          test      eax, eax            ; if its zero, we are done 
          jnz reverseCount              ; now we have the remainders pushed in edx and the count in ecx 
 
          mov       edi, [ebp+12]       ;string in edi 

     saving: 
          pop  temp                     ;pop remainder value into our local variable -> reference site in comment block above 
          mov       al, BYTE PTR temp   ;now move that value into al with use of a BYTE PTR     
          add       al, 48              ;convert using ascii 
          stosb                         ;save to our string in edi 
          loop saving                   ;loop using our ecx count 

          mov al, 0
          stosb                         ;adding the terminator 

 
          displayString [ebp+12]        ;display converted value 

          pop edi
          pop edx
          pop ecx
          pop ebx
          pop eax
          ret 8
writeVal  ENDP

; ***********************************readVal*******************
;  exchangeNum
;     description: gets a number from the user and stores it as a string in 
;                   local variable 'input'. Then validates the string 
;                   by checking if it is an integer and its length. 
;                   once validated, then loads each char, converts it to 
;                   an int, validates for size as we add and stores the final value in DWORD temp. Then
;                    temp is saved in the array index location 
;     receives:
;          @error 16
;          @requestNum 12
;          @array[a] 8
;    returns: n/a 
;     precondition: receives two addresses with values in them
;     registers changed : eax, ebx, ecx, edx, esi 
;     references: demo6.asm, page 301 local directive, page 195 XOR 
;     this explanation: https://stackoverflow.com/questions/6933477/how-to-convert-string-to-integer-in-masm    
; ***********************************************************

ReadVal PROC   
          LOCAL input[11]:BYTE, temp:DWORD        ;user input and used as accumulator for integer because Im getting occasional errors with registers 
          push eax 
          push ebx 
          push esi
          push ecx
          push edx 
          
     inputLoop:
          mov       eax, [ebp + 12]          ; request the number
          lea       ebx, input               ; making sure we pass our input by reference
          getString eax, ebx, LENGTHOF input ; changed to locals when I realized I could not do LENGTHOF otherwise
          lea       eax, input               ; user string in eax
          mov       esi, eax                 ; now user string in esi
          mov       ebx, ecx                 ;save the length in ebx too, macro put it into ecx  
          cld

     stringcheck:
          lodsb  
          cmp       al,0                ;are we at the end?
          je endOfString  
          cmp       al, 48     
          jl invalid
          cmp       al, 57              ;if outside of these ascii values then the char is not an integer 
          jg invalid
          loop stringCheck 


    endOfString:
          cmp       ecx, ebx 
          je invalid                    ;string length check 
          mov       ecx, LENGTHOF input ; loop counter
          mov       ebx, 0             
          lea       eax, temp           
          mov       [eax], ebx          ;initialize variable 
          lea       eax, input          ;string to load  
          mov       esi, eax
          mov       eax, 0              ;zero out registers  
          mov       edx, 0 
          xor edx, eax                  ;clear flags 
          cld 

     converting:
          lodsb
          cmp       eax, 0              ;done converting 
          je numTime  
          sub       eax, 48             ;convert to char 
          mov       ebx, eax            ;save into ebx for later  
          mov       eax, temp           ;accumulator value 
          mov       edx, 10 
          mul edx                       
          jc invalid                    ;number too large 
          add       eax, ebx 
          jc invalid                    ;number too large 
          mov       temp, eax           ;store our number as we continue adding 
          mov       eax, 0
          loop converting

  invalid :
          displayString[ebp + 16]       ;error 
          call crlf
          mov eax, 0                    ;clear the decks
          mov ebx, 0
          mov ecx, 0
          mov edx, 0
          xor edx, eax 
          jmp inputLoop


  numTime :                             ;temp has a valid number 
          mov       eax, temp 
                                        ; call WriteInt ; used for testing  
          mov       ebx, [ebp+8]        ;array index address 
          mov       [ebx], eax          ; copy int form of input to current element
     
          pop edx
          pop ecx
          pop esi 
          pop ebx
          pop eax 

          ret 12
     ReadVal ENDP


; *****************byebye********************
;
;    byebye
;    description: displays goodbye message
;    receives: @goodbye 8
;    returns: n / a
;    preconditions: n / a
;    registers changed : none 
; ********************************************************
byebye PROC

     push ebp
     mov       ebp, esp

     call crlf
     displayString[ebp + 8]; goodBye message
     call crlf 

     pop ebp
     ret 8
byebye ENDP

; (insert additional procedures here)

END main