//====================================================================================================================
// GENERAL INFORMATION:
//      Created by:                     Olga Chitsvarina.
//      Date of creation:               January 07, 2017.
//      Date of last modification:      January 07, 2017.
//
// ABOUT THE PROGRAM:
//      This is an assembly language program. It calculates the values of y = -25x^2 - 150x + 231 function in the 
//	range 0 <= x <= 100.   
//
//====================================================================================================================
// DEFINE M4 MACROS:
define(x_r, x19)				// Define register x19 with the macros name - x_r.
define(y_r, x20)				// Define register x20 with the macros name - y_r.
define(temp_r, x21)				// Define register x21 with the macros name - temp_r.
define(counter_r, x22)				// Define register x22 with the macros name - counter_r.

//====================================================================================================================
// EQUATES:
range_bottom = 0				// This number corresponds to the minimum x value.	
range_top = 100					// This number corresponds to the maximum x value.

//====================================================================================================================
// STRING LITERALS:
test_string:	.string "Test number: %d\n"   	// String that is used to print information regarding the test number.
x_string:  	.string "x-value: %d\n"       	// String that is used to print information regarding the x value.
y_string:  	.string "y-value: %d\n"       	// String that is used to print information regarding the y value.
                                       		// String that is used to print the separation line (divider):
end_string:     .string "====================================================== \n"
                                       
//====================================================================================================================
// MAIN:
         	.balign 4                     	// Instructions must be word alligned.
         	.global main                  	// Make the label "main" globally visible to linker (Operating System).
main:   
        stp     x29, x30, [sp,-16]!    		// Save the state, allocate stack memory for the function.
        mov     x29, sp                		// Updates fp to the current sp.
 
	mov	counter_r, xzr			// counter = 0.
        mov     x_r, (range_bottom-1)		// Initialize  x to min x value-1.

	adrp	x0, end_string			// Set 1st argument to pass to printf() (high-order bits).
	add	x0, x0, :lo12:end_string	// Set 2nd argument to pass to printf() (low-order bits).
	bl	printf				// Branch and link to printf().

	b 	test 				// Branch to loop test. 

top:						// Start of the loop body.
	add	counter_r, counter_r, 1		// Increment counter by 1.    
        add     x_r, x_r, 1			// Increment x by 1.

	mul	y_r, x_r, x_r			// y = x^2.
	mov	temp_r, -25			// temp = -25
	mul	y_r, y_r, temp_r		// y = -25x^2.
	mov	temp_r, 150			// temp = 150.
	msub	y_r, temp_r, x_r, y_r		// y = -25x^2 - 150x.
	add	y_r, y_r, 231			// y = -25x^2 - 150x + 231.
	        
        adrp    x0,  test_string            	// Set 1st argument to pass to printf (high-order bits).
        add     x0,  x0, :lo12:test_string  	// Set 1st argument to pass to printf (low-order bits).
        mov     x1,  counter_r            	// Set 2nd argument to pass to printf (counter number).
        bl      printf                  	// Branch and link to printf() method.

        adrp    x0,  x_string             	// Set 1st argument to pass to printf (high-order bits).
        add     x0,  x0, :lo12:x_string   	// Set 1st argument to pass to printf (low-order bits).
        mov     x1,  x_r               		// Pass the second argument to printf (x-value).
        bl      printf                  	// Branch and link to printf() method.

        adrp    x0,  y_string             	// Set 1st argument to pass to printf(high-order bits).
        add     x0,  x0, :lo12:y_string   	// Set 1st argument to pass to printf(low-order bits).
        mov     x1,  y_r               		// Set 2nd argument to pass to printf (y-value).
        bl      printf                  	// Branch and link to printf() method.

        adrp    x0,  end_string                	// Set 1st argument to pass to printf (high-order bits).
        add     x0,  x0, :lo12:end_string      	// Set 1st argument to pass to printf (low-order  bits).
 	bl      printf              		// Branch and link to printf() method.

test: 						// Loop test.
	cmp     x_r, range_top                 	// Compare x-value and max-value of x.
        b.lt    top                     	// If x-value is less than max x-value, go to loop body, else go to done. 

done:   					// All values of the function in the given range were calculated.
        mov     x0, 0                   	// Return 0 in main() method.
        ldp     x29, x30, [sp], 16      	// Return memory allocated.
        ret                             	// Return back to the calling code.

//=====================================================================================================================

