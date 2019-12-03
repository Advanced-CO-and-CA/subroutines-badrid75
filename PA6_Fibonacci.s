/******************************************************************************
* file: PA6_Fibonacci.s
* author: Badrinath
* Implements Recursive Fibonacci number generation.
* Input -> Fibonacci number to be genreated
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/
@ BSS section
      .bss	  
@ DATA SECTION
      .data

Program_summary_msg_1 : .asciz "Fibonacci Generation - Input 'N' and returns 'N'-th Fibonacci number of the Fibonacci sequence \n"
Program_summary_msg_2 : .asciz "Series starts from 0 i.e., 0,1,1,2,3,5,8,13,21.. \n"

Input_Num_Msg:   .asciz  " Enter the Fibonacci number to be found -> "
Fibonacci_Msg:   .asciz  "Fibonacii number is  -> "

.align
InFileHandle:   .word 0



.equ SWI_PrStr,0x69     @ Write a null-ending string 
.equ SWI_GetInt, 0x6c   @ Get int
.equ Stdout, 1          @ Set output target to be Stdout
.equ SWI_PrInt,0x6b     @ Write an Integer
.equ SWI_Exit, 0x11     @ Stop execution
.equ Stdout, 1
.equ Stdin,  0
@ TEXT section
      .text
	  
.globl Get_Fibonacci_Number
arg1   .req r0
retval .req r1


_main:

	mov r0, #0x0
	mov r1, #0x0
	mov r2, #0x0
	mov r3, #0x0
	mov r4, #0x0
	mov r5, #0x0
	mov r6, #0x0 
	mov r7, #0x0 
    mov r8, #0x0
	mov r9, #0x0
	
	// r13 ->stack
	// r14 -> lr
	// r15 -> pc
	
	
	// Print the program name
	mov r0, #Stdout
	ldr r1, =Program_summary_msg_1
	swi SWI_PrStr
	
	// Print the program name
	mov r0, #Stdout
	ldr r1, =Program_summary_msg_2
	swi SWI_PrStr
	
	
	
	// Print the request message
	mov r0, #Stdout
	ldr r1, =Input_Num_Msg
	swi SWI_PrStr 
	
	// Get the number of elements and store	
	mov r0, #Stdin
	swi SWI_GetInt
	
	mov r3, r0
	
	mov r0, #Stdout
	ldr r1, = Fibonacci_Msg
	swi SWI_PrStr
	
	// r0 contains the nth Fibonacci to be found
	mov arg1, r3	 
	bl Get_Fibonacci_Number
	
		
	// retval in r1 contains the Fibonacci number
	// Print the integer
	mov r0, #Stdout
	swi SWI_PrInt
     
END:
	
	swi 0x11


//===========================================================================================
//int Get_Fibonacci(n) implements the algo below for binary search
// {
//    if ( n == 0 )
//       return 0;
//    else if ( n == 1 )
//       return 1;
//    else
//       return ( Get_Fibonacci_Number(n-1) + Get_Fibonacci_Number(n-2) );
// } 
//=============================================================================================
Get_Fibonacci_Number:

	push {r2-r5, lr}

	#setup the stack
    #sub     sp, sp, #20
	#r0 contains the number to which Fib is to be calculated

	#This is compare 0, of fibonacci F0 and f1 = 1
	mov r3, arg1
	mov r2, r3
	cmp r3, #0
	bne check_if_1
	mov r4, #0
	b return_from_func
	
	// check if N = 1
check_if_1:	
	#if it is zero, then Fib is "1"
	cmp r3, #1
	bne continue_1
	mov r4, #1
	b return_from_func
	
continue_1:
	// Need to do recursive of Fib(n-1) + Fib(n-2)
	sub r3, #1
	mov arg1, r3
	bl Get_Fibonacci_Number
	#return value in r1
	mov r4, r1

	mov r3, r2
	sub r3, #2
	mov arg1, r3
	bl Get_Fibonacci_Number
	
	add r4, r4, r1
	
 return_from_func:

	mov     retval, r4
	pop     {r2-r5, pc}
	
	
.end
