.include "./macros.asm"

#############################################################
# Quicksort.s - Quicksort assembly implementation		#
#  -- the syscalls have been translated to calls to macros 	#
#     in macros.asm							#
#############################################################

    	.data
array:  	.word		58, 4, 20, 17, 11, 16, 11, 8, 5, 4, 3, 1
size:   	.word 	11
new_line: 	.asciiz 	"\n"
separator: 	.asciiz 	", "

    	.text
    	.globl  main

#*****************************************
#* [quickSort]
#* @param  $a0	[Array to be sorted]
#* @param  $a1 	[Starting index]
#* @param  $a3 	[Ending index]
#* @return void
#*****************************************
quickSort:
	#--------stack--------#
	addi 	$sp, $sp, -24		# 5 words
	sw	$ra, 20($sp)		# return address
	sw	$a0, 16($sp)		# array address
	sw	$a1, 12($sp)		# lower index
	sw	$a2, 8($sp)			# array size - 1
	
	#--------code--------#
	bge	$a1, $a2, continueQS	# if (low < high)
	
	jal 	partition			# int pi = partition(arr, low, high);
	move	$t0, $v0			# Copying - partition index
	
	addi 	$a2, $t0, -1		# pi - 1
	jal quickSort			# quickSort(arr, low, pi - 1);
	
	addi 	$a1, $t0, 1			# pi + 1
	lw	$a2, 8($sp)			# high
	jal quickSort			# quickSort(arr, pi + 1, high);
	
	#--------unstack--------#
	continueQS:
	lw 	$ra, 20($sp)
	lw	$a0, 16($sp)		
	lw	$a1, 12($sp)		
	lw	$a2, 8($sp)	
	addi 	$sp, $sp, 24
	jr	$ra

	
#*****************************************
#* [partition]
#* @param  $a0	[Array to be sorted]
#* @param  $a1 	[Starting index]
#* @param  $a3 	[Ending index]
#* @return $v0	[pivot index]
#*****************************************
partition:
	#--------stack--------#
	addi 	$sp, $sp, -24		# 5 words
	sw	$ra, 20($sp)		# return address
	sw	$a0, 16($sp)		# array address
	sw	$a1, 12($sp)		# ower index
	sw	$a2, 8($sp)			# array size - 1
	
	#--------code--------#
	get($t0, array, $a2)		# int pivot = arr[high];
	 
	addi 	$t1, $a1, -1		# int i = (low - 1);
	addi	$t2, $a1, 0			# int j = low;

	pLoop:				# for (int j = low; j <= high- 1; j++)
	addi	$t3, $a2, -1		# high- 1
	bgt	$t2, $t3, continueP	# j <= high- 1;

	get($t4, array, $t2)		# arr[j]
	
	bgt	$t4, $t0, continueP	# if (arr[j] <= pivot)
	
	addi  $t1, $t1, 1			# i++; 
	swap(array, $t1, $t2, $t8, $t9) # swap(&arr[i], &arr[j]);
	
	addi  $t2, $t2, 1			# j++
	j pLoop				# End for
	
	continueP:
	addi  $v0, $t1, 1			# return (i + 1);
	swap(array, $v0, $a2, $t8, $t9) # swap(&arr[i + 1], &arr[high]);
		
	#--------unstack--------#
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)		
	lw	$a1, 12($sp)		
	lw	$a2, 8($sp)			
	addi 	$sp, $sp, 24		
	jr 	$ra


#*****************************************
#* [main]
#* @param  none
#* @return void
#*****************************************	
main:
	#--------stack--------#
	add 	$sp, $sp, -28		# Create stack
	sw  	$ra, 24($sp)		# Save return address
	
	#--------code--------#
	move 	$t0, $zero			# output
	lw 	$t1, size($zero)
	print_array(array, $t0, $t1, separator, $t3)
	
	la	$a0, array			# arr
	li	$a1, 0			# 0
	lw	$t0, size($zero)		# int n = sizeof(arr);
	addi	$a2, $t0, -1		# n-1
	jal quickSort			# quickSort(arr, 0, n-1);
	
	move 	$t0, $zero			# output
	lw 	$t1, size($zero)
	print_str(new_line)
	print_str(new_line)
	print_array(array, $t0, $t1, separator, $t3)
	
	#--------unstack--------#
	lw	$ra, 24($sp)		# Load return address
	addi	$sp, $sp, 28		# Delete stack
	
	#--------done--------#
	done

