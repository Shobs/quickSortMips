.macro print_array($array, $min, $max, $sep, $tmp)
    start:
    bge $min, $max, end
    get($tmp, $array, $min)
    print_int($tmp)
    print_str($sep)
    addi $min, $min, 1
    j start
    end:
.end_macro 

.macro print_int($int)
    move $a0, $int
    li $v0, 1
    syscall 
.end_macro

.macro print_str($str)
    la $a0, $str
    li $v0, 4
    syscall
.end_macro

.macro swap($array, $arg1, $arg2, $tmp1, $tmp2)
    sll $arg1, $arg1, 2
    sll $arg2, $arg2, 2
    lw $tmp1, $array($arg1)
    lw $tmp2, $array($arg2)
    sw $tmp1, $array($arg2) 
    sw $tmp2, $array($arg1)
    srl $arg1, $arg1, 2
    srl $arg2, $arg2, 2
.end_macro

.macro get($target, $array, $index)
    sll $index,$index, 2
    lw $target, $array($index)
    srl $index, $index , 2
.end_macro

.macro set($value, $array, $index)
    sll $index, $index, 2
    sw $value, $array($index)
    srl $index, $index, 2
.end_macro

.macro done
    li $v0,10
    syscall
.end_macro  
