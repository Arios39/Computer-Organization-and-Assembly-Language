main:
	lui	$a0,0x8000
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001
	jal	first1pos
	jal	printv0
	li	$a0,1
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall

first1pos:

addiu $sp, $sp, -4
sw $ra, 0($sp)
jal first1posshift
lw $ra, 0($sp)
addiu $sp, $sp, 4
jr $ra

first1posshift:
beq $a0, 0, endNone # if a0 == 0, return -1
li $t0, 0 # counter for the position

loop:

sll $a0, $a0, 1 # shift by one to the left
slti $t1, $a0, 0 # if a0 < 0
beq $t1, 1, endPos 
addi $t0, $t0, 1 
j loop
endPos:

move $v0, $t0
jr $ra
endNone:

li $v0, -1
jr $ra
first1posmask: 
	printv0:
addi $sp,$sp,-4
sw $ra,0($sp)
add $a0,$v0,$0
li $v0,1
syscall
li $v0,11
li $a0,'\n'
syscall
lw $ra,0($sp)
addi $sp,$sp,4
jr $ra