/******************************************************************************
* file: PA6_Brute_Search
* author: Badrinath
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/
@ BSS section
      .bss	  
@ DATA SECTION
      .data

Program_summary_msg : .asciz "Array search - Brute search. Input array and element to serach. Returns  index or -1 if not present \n"
Input_Num_Msg: .asciz  " Enter the number of elements N-> "
Input_Data_Request_Msg: .asciz "Input the N number of integers \n"
Input_Single_Element_Msg: .asciz "Enter the element -> "
Data_Input_Complete_Nsg: .asciz "Data input done \n"
Search_Elem_Input_Msg: .asciz "Input the element to search -> "
Index_Found_Msg: .asciz "Index in which the element is found -> "

.align
InFileHandle:   .word 0
NUM_ELEMENTS:   .word 0
ELEM_TO_SEARCH: .word 0
INPUT_DATA: .space 10 


.equ SWI_PrStr,0x69     @ Write a null-ending string 
.equ SWI_GetInt, 0x6c   @ Get int
.equ Stdout, 1          @ Set output target to be Stdout
.equ SWI_PrInt,0x6b     @ Write an Integer
.equ SWI_Exit, 0x11     @ Stop execution
.equ Stdout, 1
.equ Stdin,  0
@ TEXT section
      .text
	  
.globl _main
.global BINARY_SEARCH

retval .req r0
arg1   .req r1
	  
	  

.globl _main
	
	// Print the program name
	mov r0, #Stdout
	ldr r1, =Program_summary_msg
	swi SWI_PrStr
	
	// Print the request message
	mov r0, #Stdout
	ldr r1, =Input_Num_Msg
	swi SWI_PrStr 
	
	// Get the number of elements and store	
	mov r0, #Stdin
	swi SWI_GetInt
	ldr r1, =NUM_ELEMENTS
	str r0, [r1]
	
	// Loop and get NUM_ELEMENTS of input integers
	
	mov  r3, r0
	ldr  r4, =INPUT_DATA
	
	mov r0, #Stdout
	ldr r1, =Input_Data_Request_Msg
	swi SWI_PrStr
	
get_input_loop:

	cmp r3, #0
	beq data_input_done
	
	mov r0, #Stdout
	ldr r1, =Input_Single_Element_Msg
	swi SWI_PrStr
	
	//Get the integers
	// Get the number of elements and store	
	mov r0, #Stdin
	swi SWI_GetInt
	
	// Store in the array
	str r0, [r4], #4
	sub r3, r3, #1
	b get_input_loop
data_input_done:
		
	mov r0, #Stdout
	ldr r1, =Data_Input_Complete_Nsg
	swi SWI_PrStr
	
	mov r0, #Stdout
	ldr r1, =Search_Elem_Input_Msg
	swi SWI_PrStr
	
	// Get the element to search
	mov r0, #Stdin
	swi SWI_GetInt
	
	ldr r1, =ELEM_TO_SEARCH
	str r0, [r1]
	
	
	mov r0, #Stdout
	ldr r1, = Index_Found_Msg
	swi SWI_PrStr
	
	
	ldr arg1, =ELEM_TO_SEARCH
	ldr arg1, [arg1]

	// Call the function to get the index of 
	// the element searched
	
	bl SEARCH
	
	// r0 contains the return value and index
	// Print the integer
	mov r1, r0
	mov r0, #Stdout
	swi SWI_PrInt
	
	swi 0x11


//==================================================================================
// Brute search of unordered array
// Input (arg1 - r1) - Element to search
// Input (arg0 - r0) - Index of the element
//
//=====================================================================================

SEARCH:
	push {r4, r5, r6, r7, r8, r9, sl, fp, lr}      

	mvn retval, #0
	mov r5, #0
	ldr r2, =INPUT_DATA


	// Get the number of elements in r3
	ldr r3, =NUM_ELEMENTS
	ldr r3, [r3]   

brute_loop:

	cmp  r3, #0
	beq  end_brute_search_loop

	ldr  r4, [r2], #4
	cmp  r4, arg1
	moveq retval, r5
	beq  end_brute_search_loop


	sub r3, #1 
	add r5, #1

	b brute_loop

end_brute_search_loop:

	pop {r4, r5, r6, r7, r8, r9, sl, fp, pc}      

.end
