TITLE Project5_turnesar(Project5_turnesar.asm)

; Author: Sarah Turner
; Last Modified : 27Feb2019
; OSU email address : turnesar@oregonstate.edu
; Course number / section: CS271_400
; Project Number : 5              Due Date : 3MAR2019
; Description: Program introduces itself, gets user request in range 10 - 200.
; Then generates that number random integers in the range 100 - 999 in an array.
; Then displays them before sorting, 10 per line.The sorts in descending
; order(largest first).Calculate and display median value, round it if necessary.Display
; sorted list, 10 per line. 

INCLUDE Irvine32.inc

LOWERLIMIT EQU 10;
UPPERLIMIT EQU 200;
LOWER EQU 100; 
HIGHER EQU 999; 

.data


intro1         BYTE  "Rando Integer Sort     by Sarah Turner", 0;  name of program
intro2         BYTE  "This program generates random numbers in the range 100-999,", 0 
intro3         BYTE  " displays the original list, sorts the list, and calculates ", 0
intro4         BYTE  "the median value. Finally, it displays the list in sorted order.", 0
requestNum     BYTE  "How many numbers should be generated (range 10-200): ", 0; request from user 
error          BYTE  "enter another number: ", 0; when out of range number is entered 
unsorted       BYTE  "The unsorted random numbers: ", 0;
medianString   BYTE  "The median is ", 0; 
sorted         BYTE  "The sorted list: ",0; 
userNumber     DWORD ? ; user input for number of composites desired
arrayNum       DWORD 2*UPPERLIMIT DUP(?); array of maximum size to hold the numbers shown
spaces         BYTE  "       ", 0; spaces between single digit numbers


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
call introduction

push OFFSET error
push OFFSET userNumber
push OFFSET requestNum
call getUserData

push OFFSET arrayNum
push userNumber
call fillArray

push OFFSET arrayNum
push OFFSET unsorted
push OFFSET spaces
push userNumber
call displayList

push OFFSET arrayNum
push userNumber
call sortList

push OFFSET arrayNum
push userNumber
push OFFSET medianString
call displayMedian

push OFFSET arrayNum
push OFFSET sorted
push OFFSET spaces
push userNumber
call displayList

exit

main ENDP

; *****************INTRODUCTION********************
; 
;    introduction
;    description: displays introduction, title and author, extra credit request and directions
;    receives: @intro4 20
;              @intro3 16
;              @intro2 12
;              @intro1 8< - pointer  
;    returns: n / a
;    preconditions: n/a
;    registers changed: EDX 
; ********************************************************
introduction PROC
       
          push ebp 
          mov       ebp, esp 

          mov       edx, [ebp+20]       ;intro1
          call WriteString
          call crlf
          call crlf 
          mov       edx, [ebp+16]       ;intro2
          call WriteString 
          call crlf 
          mov       edx, [ebp+12]       ;intro3
          call WriteString 
          call crlf 
          mov       edx, [ebp +8]       ;intro4
          call WriteString
          call crlf 
          call crlf 

          pop ebp 
          ret 16          
introduction ENDP

; **********************************GETUSERINPUT*************
;
;  getUserData
;     description: Takes input for printing numbers, validates, then
;                  stores value in userNumber address  
;     Receives: @error       16
;               @userNumber  12  
;               @requestNum  8<-pointer            
;     returns: n / a
;     preconditions: processes numbers only
;     registers changed: EAX has userNumber and EBX used to transfer to address, EDX has request for number or error  
; ******************************************************
getUserData PROC

push ebp
mov ebp, esp 

     GETDATA:
          mov       edx, [ebp+8]        ;requestNum 
          call WriteString
          call ReadInt 
          cmp       eax, LOWERLIMIT     ;comparison to lower limit of 10
          jl        INVALID
          cmp       eax, UPPERLIMIT     ;testing for upper limit of 200
          jg        INVALID
          mov       ebx, [ebp+12]       ;address of userNumber  
          mov       [ebx], eax          ;store input into address of userNumber 
          jmp  ALLDONE  
     INVALID:
          mov       edx, [ebp+16]
          call WriteString 
          call crlf 
          mov       eax, 0
          jmp GETDATA 
     ALLDONE:
          pop ebp 
          ret 12     
getUserData    ENDP


; **************************FILL ARRAY*********************
; fillArray
;    description: seeds the randomrange procedure. Loops through the array based on 
;    validated number from user.  Fills array with random integers 
;    Receives: @arrayNum  12
;               userNumber 8 <-pointer 
;    Returns: n/a
;    preconditions: validated user defined userNumber 
;    registers changed : ebp, eax, esi, ecx
;    reference: slide 7 in lecture 20 
; *********************************************************************
fillArray PROC
          push ebp
          mov       ebp, esp
          call Randomize                ;seed the randomRange 
          mov       esi, [ebp+12]       ;array start 
          mov       ecx, [ebp+8]        ;userNumber 
     GETARANDO:
          mov       eax, HIGHER 
          sub       eax, LOWER
          inc eax
          call RandomRange
          add       eax, LOWER          ;now EAX holds our random number 
          mov       [esi], eax          ;put it into the array  
          add       esi, 4              ;next spot in array 
          loop getaRando

          pop ebp
          ret 8
fillArray ENDP

; **************************DISPLAY LIST*********************
; displayList
;    description:  recieves address of array, two strings, and number of integers to print.
;                  loops through the integers in array and prints them, starting a newline every 10.  
;    Receives: 
;           @ arrayNum 20
;           @ (string to introduce list)16
;           @ spaces 12
;           value userNumber 8 < -pointer 
;    Returns: n / a
;    registers changed : pushad/popad used 
;    reference: Lecture 20, slide 3 used as a reference
; *********************************************************************
          displayList  PROC
          push      ebp 
          mov       ebp, esp
          mov       edx, [ebp + 16]; string to introduce list
          call WriteString
          call crlf
          mov       esi, [ebp + 20] ;array starting address
          mov       ecx, 0          ;counts number of integers to print
          mov       ebx, 0          ;used for newline counting 
     
     PRINT: 
          mov      eax, [esi]       ;move  value into eax 
          call WriteDec
          inc ecx                   ;add 1 to number of values printed 
          inc ebx                   ;add 1 to number of values before newline 
          cmp       ebx, 10         ;do we need to print a newline ?
          je NEXTLINE
          mov       edx, [ebp + 12] ;spaces string  
          call WriteString
         
     ONWEGO:                        ;come back here after a newline 
          add       esi, 4          ; increment to next array value
          mov       edx, [ebp + 8]  ;number of values to print 
          cmp       ecx, edx        ;have we printed them all?
          jae ALLDONE 
          jmp PRINT                 ;if not keep going            
          
     NEXTLINE:                     ;jump here to enter a newline after 10 values, then reset the ebx register 
          call crlf
          mov ebx, 0
          jmp ONWEGO

     ALLDONE:
          call crlf 
          pop ebp 
          ret 16

displayList ENDP 

;********************SORT LIST ********************
;
;   sortList 
;      description:  Uses the selection sort to sort the array of random positive numbers. 
;      calls nested procedure to swap values at passed array addresses. 
;      for (k = 0; k < request - 1; k++) {             for(ecx=0; ecx<edx;ecx++){ <-push edx to reuse in inner loop 
;                    i = k;                                          ebx=ecx 
;     for (j = k + 1; j < request; j++) {                   for(eax; eax<edx;eax++){
;          if (array[j] > array[i])                              if(edi[eax]<=esi[ebx])
;               i = j;                                                     eax=ebx <-descending order (j=i)
;       }                                                   }
;      exchange(array[k], array[i]);                         call exchangeNum(@array[k], @array[i])
;      }                                                    }
;      receives:  @ arrayNum 12
;                 value userNumber 8< -pointer
;      returns:   n/a 
;      preconditions: array contains positive integers 
;      registers changed: esi, edi, eax, ebx, ecx, edx
;      references: Section 8.2.7 of textbook, selection sort algorithm in prog05 assignment 
; ********************************************************
sortList    PROC
          push ebp
          mov ebp, esp
          mov       esi, [ebp + 12]              ;array start address 
          mov       edx, [ebp + 8]               ;userNumber (request)
          dec edx                                ;outerloop uses k<request -1, edx = request-1
          mov       ecx, 0                       ;ecx is k

    OUTERLOOP:
          mov       ebx, ecx                     ;ebx is i, i = k
          mov       eax, ebx 
          inc eax                                ;eax is j, j=k+1
          push edx                               ;push edx so it can be used in the inner loop too 
          mov       edx, [ebp + 8]               ;edx = userNumber (request)
         
    INNERLOOP:
          mov       edi, [esi + [eax * 4]]       ;edi becomes array[j]
          cmp       edi, [esi+  [ebx * 4]]       ;compare array[j] to array[i] 
          jle  NOSWAPPING                        ;skip over j=i, if less than or equal 
          mov       ebx, eax                     ;j=i     

     NOSWAPPING:
          inc eax                                ; j++
          cmp       edx, 1                       ; at the end of the innerloop, ready to exit to outerloop and exchange
          je  EXCHANGE                           ;jump to exchange at the outerloop   
          dec edx                                ;decrement request to test for innerloop ending     
          jmp INNERLOOP                          ;else still in innerloop  

     EXCHANGE:                
          lea       edi, [esi + [ecx * 4]]        ; load address of indirect operand of array[k] into edi and push
          push edi
          lea       edi, [esi + [ebx * 4]]        ; load address of indirect operand of array[i] into edi and push, this value was exceeding array size, changed array size 
          push edi
          call exchangeNum
          pop edx                                ;have outerloop request value now 
          inc ecx                                ;k++ 
          cmp       edx, 0;0                      ;checks to see if we are done with the outerloop 
          je ALLDONE                         
          dec edx                                ;decrements request for outerloop 
          jmp OUTERLOOP                          ;outerloop starts again  

     ALLDONE:       
          pop ebp 
          ret 8

sortList  ENDP

; ***********************************EXCHANGENUM*******************
;  exchangeNum
;     description: receives two addresses of array indexes and then swaps the values at those addresses 
;     receives:
;         @array[k] 40
;         @array[i] 36 < -pointer
;     returns: swapped values
;     precondition: receives two addresses with values in them
;     registers changed : esi, eax, edi
;     references: Section 8.4.6 of textbook
; ***********************************************************
exchangeNum PROC
          pushad

          mov        ebp, esp
          mov       eax, [ebp+40]            ;array[k]
          mov       ecx, [eax]
          mov       ebx, [ebp+36]            ;array[i]
          mov       edx, [ebx]
          mov       [eax], edx
          mov       [ebx], ecx

          popad
          ret 8
exchangeNum ENDP 
     
; **********************************DISPLAY MEDIAN*******************
;  displayMedian
;     description: receives an array and calculates and displays the median
;     receives: 
;              @ arrayNum 16
;              userNumber 12
;              @ medianString 8<-pointer 
;     returns: n/a 
;     precondition: assumes array is already sorted 
;     registers changed:   esi, eax, edx, ebx
; ***********************************************************

displayMedian PROC

          push ebp
          mov       ebp, esp
          call crlf
          mov       esi, [ebp + 16]          ; array
          mov       edx, [ebp + 8]           ; string introducing it
          call WriteString
     
          mov       edx, 0                   ; clear edx for dividing
          mov       eax, [ebp + 12]          ; this is the userNumber
          mov       ebx, 2
          div ebx
          cmp       edx, 0                   ; determine if even or not
          je EVENNUM
          mov       ebx, 4
          mul ebx                            ; multiply eax by 4 to determine array position
          add       esi, eax                 ; add to the array start address 
          mov       eax, [esi]  
          jmp WRITEIT

     EVENNUM: 
          dec eax                            ; have to  decrement, arrays start at 0
          mov       ebx, 4
          mul ebx                            ; determine halfpoint of array
          add       esi, eax
          mov       ebx, [esi]               ; one halfpoint of array
          add       esi, 4
          mov       eax, [esi]               ; other halfpoint of array
          add       eax, ebx
          mov       ebx, 2
          div ebx                            ; avearage of two integers in eax 
          .IF(edx > 0)
                    inc eax                  ; round up if there is a 0.5 remainder
          .ENDIF 

     WRITEIT:
          call WriteDec
          call crlf 
          call crlf

          pop ebp
          ret 12

displayMedian  ENDP



; (insert additional procedures here)

END main
