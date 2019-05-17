.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of list: "
str3: .asciiz "Enter a key to search for: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
#myArray:   .word 1, 4, 5, 7, 9, 12, 15, 17, 20, 21, 30
#arraySize: .word 11
space: .asciiz " "
nextline: .asciiz "\n"

.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp -8
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5
	syscall
	move $s0, $v0
	move $t0, $0
	la $s1, original_list
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	li $v0, 4 
	la $a0, str2 
	syscall 
	move $a0, $s1
	move $a1, $s0
	jal printList
	
	jal inSort
	sw $v0, 4($sp)
	li $v0, 4 
	la $a0, str2 
	syscall  
	lw $a0, 4($sp)
	jal printList
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	li $v0, 5
	syscall
	move $a2, $v0
	lw $a0, 4($sp)
	jal bSearch
	
	beq $v0, $0, notFound
	li $v0, 4 
	la $a0, strYes 
	syscall 
	j end
	
notFound:
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	lw $ra, 0($sp)
	addi $sp, $sp 8
	li $v0, 10 
	syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	move $t0, $a0
	move $t1, $a1
	li $t2, 0
loop:
	beq $t2, $t1, exit
	li $v0, 1
	lw $a0, 0($t0)
	syscall
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	j loop
exit:
	li $v0, 4
	la $a0, nextline
	syscall
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	move $t0, $a0
	move $t1, $a1
	li $t2, 1

sortLoop:
	move $t0, $a0
	beq $t2, $t1, sortLoopEnd2
	move $t3, $t2

sortLoop2:
	move $t0, $a0
	mul $t4, $t3, 4
	add $t0, $t0, $t4
	beq $t3, 0, next
	lw $t5, 0($t0)
	lw $t6, -4($t0)
	bge $t5, $t6, next
	lw $t7, 0($t0)
	sw $t6, 0($t0)
	sw $t7, -4($t0)
	addi $t3, $t3, -1
	j sortLoop2

next:
	addi $t2, $t2, 1
	j sortLoop

sortLoopEnd2:
	la $v0, 0($a0)
	
	jr $ra
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
bSearch:
	#Your implementation of bSearch here
move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	li $s5, 0

	addi $s1, $s1, -1
	

	bgt $s3, $s1, rightcheck
	loop2:
	blt $s1, $s3, bfalse 
	

	sub $t0, $s1, $s3
	div $t0, $t0, 2
	add $s5, $s3, $t0
	

	sll $t1, $s5, 2
	add $t2, $s0, $t1
	lw $t1, ($t2)
	
	
	beq $t1, $s2, btrue
	

	li $t4, 0
	li $t5, 0
	
	slti $t4, $a3, 1
	slti $t5, $a1, 1
	
	add $t4, $t4, $t5
	li $t5, 2
	beq $t4, $t5, bfalse
	
	bgt $t1, $s2, bsgt
	
	blt $t1, $s2, bslt
	
	
	
	bsgt:
	sub $a1, $s5, $s3
	j bSearch
	
	bslt:
	addi $a3, $s5, 1
	j bSearch
	
	btrue:
	li $v0, 1
	jr $ra
	bfalse:
	li $v0, 0
	jr $ra

	rightcheck:
		sll $t6, $s1, 2
		add $t6, $s0, $t6
		lw $t7, ($t6)
		beq $a2, $t7, btrue
		
	j loop2
	
