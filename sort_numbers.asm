.data

sorted: .word 4,3,9,5,2,1 # need to sort these in ascending order
len: .word 6
newline: .asciiz "\n"

.text

main:
	la $s0, sorted
	lw $s1, len

	sub $t0, $s1, 1 # t0 = len -1

	li $t1, 0 # i = 0 Outer loop counter
	
outer_loop:
	bge $t1, $t0, print_counter # if i >= (len - 1): print sorted
	
	li $t2, 0 # j = 0 Inner loop counter
	
inner_loop:
	# the inner loop must always run len - i - 1 times 
	sub $t6, $s1, $t1 # t6 = len - i
	sub $t6, $t6, 1 # t6 = len - i - 1
	
	bge $t2, $t6, increment_outer # j >= (len -i -1)
	
###################### Accessing sorted	[j]
	
	# sll shifts the bits of a register value to the left, each int takes 4 bytes
	# and it needs to be relative to the position in the array aka "j"
	# and we use 2 because we are shifting two bits so 2² = 4
	sll $t3, $t2, 2
	add $t4, $s0, $t3
	lw $t5, 0($t4) # This is to access the address of the element itself
	
###################### Accessing sorted	[j+1]
	
	addi $t3, $t3, 4 # t3 is already going to be in the correct, so this is like [j+1]
	add $t7, $s0, $t3
	lw $t8, 0($t7)
	
###################### Comparing and swapping elements
	
	# we use this backwards logic, because MIPS doesnt automatically return so we would have to jump back if we used bge, 
	# which would mean re running a lot of code and make it recursive so it gets reallly messy.
	ble $t5, $t8, skip_swap  # if [j] > [j+1]: swap
	sw $t8, 0($t4) # [j] = [j+1] this is stored in reverse so t8 goes in 0(t4)
	sw $t5, 0($t7) # [j+1] = [j] 
	
skip_swap:
	
	addi $t2, $t2, 1 # this is just j++
	j inner_loop
	
increment_outer:
	addi $t1, $t1, 1 # i++
	j outer_loop

###################### Printing the sorted array elements

# We jump to this first since I'm reusing the counter
print_counter:
	li $t2, 0 # print counter

print_sorted:

	bge $t2, $s1, stop_print
	# we gotta redo this step 
	sll $t3, $t2, 2
	add $t4, $s0, $t3
	lw $a0, 0($t4)
	
	li $v0, 1 # 1 is print_int
	syscall 
	
	la $a0, newline
	li $v0, 4 # 4 is print_string
	syscall
	
	addi $t2, $t2, 1 # i++
	j print_sorted
	
stop_print:
	li $v0, 10 # 10 is exit
	syscall
	
