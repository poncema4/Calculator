%include "io.inc"

section .text
global main
main:
    mov ebp, esp  ;; For correct debugging

    ;; Prints out prompt1 for the user
    PRINT_STRING prompt1
    GET_DEC 4, eax  ;; Gets the user's first input
    PRINT_DEC 4, eax    ;; Prints the user's first input to visually see it
    mov [num1], eax  ;; Stores the user's first input from eax -> [num1]
    NEWLINE

    ;; Prints out prompt2 for the user
    PRINT_STRING prompt2
    GET_DEC 4, eax    ;; Gets the user's second input
    PRINT_DEC 4, eax    ;; Prints the user's second input to visually see it
    mov [num2], eax   ;; Stores the user's second input from eax -> [num2]
    NEWLINE

    ;; Prints out prompt3 for the user
    PRINT_STRING prompt3
    jmp get_operation   ;; Jumps to the get_operation conditional statement 

;; Contract: edx (dl) -> char (operation)
;; Purpose: Reads a single character from the user's input that represents the
;; arithmetic operation (+,-,*,/)
get_operation:
    GET_CHAR edx ;; Gets the user's third input which is the operation
    
    ;; SOLVED PROBLEM: The problem in SASM is when a user hits ENTER when inputting 
    ;; values, the program reads it as 10, so in order for the program to work and 
    ;; ignore the ASCII 10 that it understands first time running it, we need to 
    ;; recall the function again knowing that edx will be 10 the first time its ran, 
    ;; but the second time it is ran it will properly handle the correct operation 
    ;; and be able to work as a normal functional calculator
    
    cmp dl, 10                   ;; Checks if char is a newline (ASCII 10)
    je get_operation             ;; If the newline was read, re-run the function
    mov [operation], dl          ;; Stores the user's third input from dl (Lower 8 bits) -> [operation]
    NEWLINE

    ;; Loads num1, num2 from memory into eax and ebx register
    mov eax, [num1]   ;; Loads the user's first input into eax register 
    mov ebx, [num2]   ;; Loads the user's second input into ebx register

    ;; Compares the user's input operation to the correct char
    cmp dl, '+'       
    je add_function   ;; Checks if the operation is add operation
    cmp dl, '-'       
    je sub_function   ;; Checks if the operation is sub operation
    cmp dl, '*'       
    je mul_function   ;; Checks if the operation is mul operation
    cmp dl, '/'       
    je div_function   ;; Checks if the operation is div operation
    jmp invalid_operation     ;; If it is none of the valid operations, jump to invalid_operation   

;; Contract: eax[num1] + ebx[num2] -> answer
;; Purpose: Add the registers eax[num1] and ebx[num2], then jump to answer
add_function:
    add eax, ebx ;; eax = eax + ebx
    jmp answer

;; Contract: eax[num1] - ebx[num2] -> answer
;; Purpose: Subtract the registers eax[num1] and ebx[num2], then jump to answer
sub_function:
    sub eax, ebx ;; eax = eax - ebx
    jmp answer

;; Contract: eax[num1] * ebx[num2] -> answer
;; Purpose: Multiply the registers eax[num1] and ebx[num2], then jump to answer
mul_function:
    mul ebx ;; eax = eax * ebx
    jmp answer

;; Contract: eax[num1] / ebx[num2] -> answer
;; Purpose: Divide the registers eax[num1] and ebx[num2], then jump to answer, 
;; also checking if the second input is 0, if it is, which is not standard for a calculator
div_function:
    cmp ebx, 0  ;; Checks if the second input is 0
    je div_by_zero ;; If it is, jump to div_by_zero function
    xor edx, edx ;; Clear edx register before dividing
    div ebx ;; eax = eax / ebx                
    jmp answer

;; Contract: eax[num1] / 0 -> string
;; Purpose: Print out the error message if the user is trying to divide by 0
div_by_zero:
    PRINT_STRING divbyzeromsg ;; Print error message than jump to exit
    jmp exit

;; Contract: !(+,-,*,/) -> string
;; Purpose: Print out the error message if the user is trying to input an invalid operation
invalid_operation:
    PRINT_STRING invalidmsg ;; Print error message than jump to exit
    jmp exit
    
;; Contract: eax[num1], ebx[num2] -> answer
;; Purpose: Print out the message after applying the proper operation to [num1] and [num2]
answer:
    PRINT_STRING resultmsg       
    PRINT_DEC 4, eax          
    NEWLINE

;; Contract: eax, eax -> 0
;;           -> output
;; Purpose: Exit the program and xor eax, eax then return the answer, to avoid any crashes
;; bugs or errors from happening
exit:
    xor eax, eax
    ret                          

section .data
prompt1 db "Enter first integer: ", 0
prompt2 db "Enter second integer: ", 0
prompt3 db "Enter operation (+, -, *, /): ", 0
resultmsg db "Answer: ", 0
divbyzeromsg db "Error: Cannot divide by 0", 0
invalidmsg db "Error: Not a valid operation", 0
num1 dd 0
num2 dd 0
operation db 0
result dd 0
