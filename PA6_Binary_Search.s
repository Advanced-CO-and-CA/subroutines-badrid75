/******************************************************************************
* file: PA6_Binary_Search
* author: Badrinath
* Implements binary search, uses SWI to get user input
* Input -> Number of elements, ordered list one after the other
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/
@ BSS section
      .bss	  
@ DATA SECTION
      .data
Program_summary_msg : .asciz "Array search - Binary search. Input aordered (low to high) array and element to serach. Returns  index or -1 if not present \n"
InFileError: .asciz "Unable to open input file\n"
Input_Num_Msg: .asciz  " Enter the number of elements N-> "
Input_Data_Request_Msg: .asciz "Input the N number of sorted integers in ascending order \n"
Input_Single_Element_Msg: .asciz "Enter the element -> "
Data_Input_Complete_Nsg: .asciz "Data input done \n"
Search_Elem_Input_Msg: .asciz "Input the element to search -> "
Index_Found_Msg: .asciz "Index in which the element is found -> "

.align
InFileHandle:   .word 0
NUM_ELEMENTS:   .word 0
ELEM_TO_SEARCH: .word 0
ORDERED_INPUT_DATA: .space 10 


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
	ldr  r4, =ORDERED_INPUT_DATA
	
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
	
	bl BINARY_SEARCH
	
	// r0 contains the return value and index, move it
	// to r1
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

BINARY_SEARCH:

	push {r4, r5, r6, r7, r8, r9, sl, fp, lr}      

	mvn retval, #0
	mov r5, #0



	ldr r2, =ORDERED_INPUT_DATA


	// Get the number of elements in r3
	ldr r3, =NUM_ELEMENTS
	ldr r3, [r3]  

	// mid = 0
	// low = 0
	// high = num elements =1
	mov r4, #0
	mov r5, #0
	mov r6, r3
	sub r6, r6, #1


	// r2 -> Input array
	// r3 -> Num elements
	// r4 -> low
	// r5 -> mid
	// r6 -> high

	// Implements the following algorithim
	// while (lower <= higher) {
        //   // invariants: value > arr[i] for all i < low
        //   // value < arr[i] //for all i > high;
        //   mid = (lower + higher) / 2;
        //   if (arr[mid] > value)
        //       higher = mid - 1;
        //   else if (arr[mid] < value)
        //       lower = mid + 1;
        //   else
	    //	return mid;
        //  }


  bs_loop1:
  	cmp r4, r6 
    bgt bs_loop1_exit

	// mid = low + high / 2
	add r7, r4, r6
	mov r5, r7, LSR#1

	// if A[mid] > value

	mov r9, r5, LSL#2
	ldr r8, [r2, r9]
	cmp r8, arg1

        //   if (A[mid] > value)
        //    high = mid - 1;
	subgt r7, r5, #1
	movgt r6, r7

	bgt bs_loop1

        // else if (A[mid] < value
        //       low = mid + 1;
	addlt r7, r5, #1
	movlt r4, r7
	blt   bs_loop1

	moveq retval, r5

bs_loop1_exit:
	// If we are here, we are equal
	// We have to return 
	// mov retval, r5
	pop {r4, r5, r6, r7, r8, r9, sl, fp, pc}      
