##############  counter ######################################################################################
# 这是一个简单的mips汇编语言编写的计数程序，用户输入一个整数n，则程序一次输出从1到n的整数，输出一个换行一次。
# 程序具有简单的错误处理功能。
########## 10-20-2008  ###########################################################################################

#------------代码 segment-------------------#

.text
.globl main

inner_loop:
    move $s7, $ra                          #参数传递 $a0 数字数组的首地址  $a1 当前需要冒泡的数组的位置 从0开始
    bubble:
        la $a0, array
        beq $a1, $zero, return
        li $t6, 4
        sub $a1, $a1, $t6
        add $t0, $a0, $a1
        lw $t1, 0($t0)
        add $t0, $t0, 4
        lw $t2, 0($t0)
        slt $t3, $t1, $t2
        beq $t3, $zero, return        #没有需要调换的数字就代表这一次循环已经成功让之前的所有数字都按顺序排列
        lw $t1, 0($t0)
        li $t5,4                 #t0 是后一位数 这个分支代表需要和前一个数进行调换
        sub $t0, $t0, $t5
        lw $t2, 0($t0)
        sw $t1, 0($t0)
        add $t0, $t0, $t6
        sw $t2, 0($t0)
        j bubble
              #交换完毕 汇编真继而难写
        return: 
            move $ra,$s7
        
            jr $ra
outter_loop:
    move $v1, $ra
    li $a2, 0
    li $s0, 40
    loop:
        addi $a2, $a2, 4
        move $a1, $a2
        jal inner_loop
        bne $a2, $s0, loop
    move $ra, $v1
    jr $ra                 #参数传递 $a0 数字数组的首地址
error:                               # 错误处理，若输入整数不再指定范围内，从新输入
    li      $v0,   4                 # 打印字符串，输出
    la      $a0,   errormsg          # 取字符串errormsg首地址->$a0
    syscall                          # 系统调用

    j get                            # 转重新输入
         

get:
    li  $s1, 0
    li  $s2, 10
    li      $v0,   4                 # 打印字符串，输出
    la      $a0,   msg1
    syscall
    la  $t7, array      
    #la   $t8, msg2
    #addi $t8, $t8, 24
    warning:
        beq $s1, $zero, next

        li      $v0,   4                 # 打印字符串，输出
        la      $a0,   msg2
        syscall
        

        #lw $t9, 0($t8)
        #li $s6, 1
        #sub $t9, $t9, $s6
        #sw $t9,0($t8)

        next:li    $v0,   5                 # 接收键盘输入一整数（作为上届），接收到的数据存放在$v0中
        syscall
        

        sw    $v0, 0($t7)
        addi $t7, $t7, 4
        addi $s1, $s1, 1
        bne $s1, $s2, warning
    jr $ra
out:
    la $a2, array
    li    $s1,  0
    li    $s2,  10
    li    $v0,  4                 # 打印字符串，输出
    la    $a0,   msg3
    syscall

    li    $s3,  4
    li    $s4, 44
    single_out:
        add $t5, $a2, $s3
        
        lw $a0,0($t5)                   # 取字符串地址 
        li $v0, 1                     # 4号 功能调用，输出字符串 
        syscall

        la $a0,new_line
        li $v0, 4
        syscall
        li $t7,4
        add $s3, $s3, $t7
        bne $s3, $s4, single_out
    la $a0,new_line
    li $v0, 4
    syscall
    jr $ra



    
main:
    jal get
    jal outter_loop
    jal out

    li      $v0,    10               # 退出，返回系统
    syscall

#-------------------数据 segment--------------------#       

.data
    msg1:
        .asciiz "you can key in 10 numbers one by one:"
    msg2:
       .asciiz "you still need to key in 9 times:"
    msg3:
        .asciiz "the sorted array will be like\n"    
    errormsg:
       .asciiz "out of range(1 to 20)\n" # 字符串定义，.asciiz类型定义字符串，最后以"00"字符作为终止符结束
    new_line:  
       .asciiz "\n"    
    array:
        .space 40
    space_key:                             # 变量名称
        .asciiz " "
###----end of file     