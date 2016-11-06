@ John Filipowicz
@ Itec 352 
@ Project 1: Selection Sort via Assembly

@ This program implements selection sort algorithm to sort an array of fixed sized 5 from least to greatest

@ Register Mapping:
@ r1 - address of first element in the array
@ r2 - outer loop counter
@ r3 - inner loop counter
@ r4 - address of current lowest item at or past r2
@ r5 - temp used in two spots
@ r6 - temp2 used in two spots
@ [r1, r_] - represents the r_ number of bits into the array starting at r1

.data
.balign 4

a: .word 25 		@ declaring and initializing the array
   .word 110
   .word 149
   .word 10
   .word 12

.text
.balign 4
.global main

main:
	ldr r1, =a	@ address of first element in a
	mov r2, #0	@ outer loop counter

outerloop:
	cmp r2, #17	@ 17 because bgte wouldn't work. This way we can use bpl
	bpl end

	mov r3, r2	@ inner loop counter
	mov r4, r2	@ offset to lowest number at or past r2

innerloop:
	cmp r3, #17
	bpl swap

  if_less:			@ Tag is never called, purely for clarity
	ldr r5, [r1, r4]	@ load value at a[r4/4] into r5
	ldr r6, [r1, r3]	@ load value at a[r3/4] into r6
	cmp r5, r6	
	bmi end_if 

	mov r4, r3

  end_if:
	add r3, r3, #4
	b innerloop

swap:
	ldr r5, [r1, r4] 	@ Store value at a[r4/4] in r5
	ldr r6, [r1, r2] 	@ Store value at a[r2/4] in r6
	str r6, [r1, r4] 	@ Store value in r6 into the addr at a[r4/4]
	str r5, [r1, r2] 	@ Store value in r5 into the addr at a[r2/4]

	add r2, r2, #4
	b outerloop

end:
	ldr r0, [r1, #+16] 	@ Store last array value into r0
	bx lr

