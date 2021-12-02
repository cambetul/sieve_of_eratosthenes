limit 		EQU	4								;limit = 20
index		EQU	0								;index = 0
ArraySize   EQU	limit*4+4						;Array size = (limit+1)*4 (limit+1 word each word 4 byte)
ArraySize2	EQU	limit+1							;Array size = (limit+1)*1 (limit+1 word each word 1 byte since it is bool array)

			AREA     My_Array, DATA, READWRITE		;Defined area will be placed to the data memory
			ALIGN	
primeNumbers 	SPACE    ArraySize						;Allocate space from memory for primeNumbers
end_primeNumbers
isPrimeNumbers 	SPACE    ArraySize2						;Allocate space from memory for isPrimeNumbers
end_isPrimeNumbers

			AREA factorial_array, code, readonly			;Defined area will be placed to the code memory
			ENTRY
			ALIGN 
			THUMB
__main		FUNCTION
			EXPORT __main
			LDR		r5,= primeNumbers						;Load start address of the allocated space for primeNumbers[]												
			LDR		r6,=isPrimeNumbers						;Load start address of the allocated space for isPrimeNumbers[]											
			MOVS	r1,#limit								;r1 = limit (parameter for functions)
			MOVS	r3,#0									;r3=i=0 (to compare i and limit)
			MOVS	r4,#0									;r4=i=0 (for index of array)
			B		soe										;branch soe

soe			CMP		r3,r1									;compare i and limit														
			BLE		loop1									;if i<=limit then branch to loop1 function									
			MOVS	r3,#2									;else r3=i=2		

loop2		MOVS	r4,r3									;r4 = r3
			MULS	r4,r3,r4								;r4 = i*i
			CMP		r4,r1									;compare r4 and r1 (i*i and limit)
			BLE		loop2_if								;if i*i <= limit than branch to loop2_if
			MOVS	r3,#2									;r3 = i = 2 (to compare i and limit)
			MOVS	r4,#index								;r4=index
			B		loop4_									;call loop4_ (branch)							

loop1		MOVS	r7, #0									;r7 = 0 (to use as parameter of STR)
			STR		r7,[r5,r4]								;primeNumbers[i] = 0
			MOVS	r7, #1									;r7 = 1 (to use as parameter of STR)
			STRB	r7,[r6,r3]								;isPrimeNumbers[i] = 1 = true
			ADDS	r3,r3,#1								;r3 = r3+1 (i++ to compare i and limit)								
			ADDS	r4,r4,#4								;r4 = r4+4 (i+=4 for index of array)								
			B		soe										;call soe function (branch)
			
loop2_if	LDRB	r2,[r6,r3]								;r2=isPrimeArray[i]						
			CMP		r2,#1									;compare isPrimeArray[i] and 1														
			BEQ		loop3_									;i it is 1 (true) then	call loop3_ (branch)									
			ADDS	r3,r3,#1								;else i++
			B		loop2									;branch loop2
			
loop3_		CMP		r4,r1									;compare r4 and r1 (i*i and limit)			
			BLE		loop3									;if i*i<=limit then call loop3 (branch)
			ADDS	r3,r3,#1								;i++
			B		loop2									;branch loop2

loop3		MOVS	r7,#0									;;r7 = 0 (to use as parameter of STR)
			STRB	r7,[r6,r4]								;isPrimeNumber[j] = false = 0
			ADDS	r4,r4,r3								;j=1*1+i..+2i...+3i...
			B		loop3_									;branch to loop3_
			
loop4_		CMP		r3,r1									;compare i and limit
			BGT		stop									;if greater  branch stop
			LDRB	r2,[r6,r3]								;r2 = isPrimeArray[i]
			CMP		r2,#1									;else if isPrimeArray[i] = true = 1
			BEQ		loop4									;branch loop4
			ADDS	r3,r3,#1								;else i++
			B		loop4_									;branch loop4_
		
loop4		STR		r3,[r5,r4]								;primeNumbers[index] = i												
			ADDS	r4,r4,#4								;index++ (index of primeNumbers array so add 4)
			ADDS 	r3,r3,#1								;i++
			B		loop4_									;branch loop4_
																											
stop		B		stop									;infinite loop

			ALIGN
			ENDFUNC
			END