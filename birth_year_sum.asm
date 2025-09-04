.data

input_message: .asciiz "Enter the birth year of a participant: "
output_message: .asciiz "The sum of your birth years is: "

.text

	li $t0, 0 # Birth year sum
	li $t1, 4 # Amount of participants
	

age_input:

	la $a0, input_message
	li $v0, 4 # 4 is for printing strings
	syscall

	li $v0, 5 # 5 is for user input for an int
	syscall

	add $t0, $t0, $v0 # Adds the input year
	
	subi $t1, $t1, 1
	
	bge $t1, 1, age_input
	
	la $a0, output_message
	li $v0, 4 
	syscall
	
	move $a0, $t0
	
	li $v0, 1 # 1 prints a word
	syscall
	
	li $v0, 10 # Exit code
	syscall
	
