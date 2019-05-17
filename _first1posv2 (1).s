first1pos:

	beqz $a0 return1
	li $t7, 0x80000000 # given mask
	li $t2, 31 # index
	and $t1, $a0, $t7 # do mask
	beqz $t1 helperLoop

	j return2

helperLoop:

	srl $t7, $t7, 1 # shift mask to right
	addi $t2, $t2, -1
	and $t1, $a0, $t7 # do mask
	beqz $t1, helperLoop

	j return2

return1:

	addi $v0, $zero, -1
	jr $ra
	return2:
	move $v0, $t2
	jr $ra