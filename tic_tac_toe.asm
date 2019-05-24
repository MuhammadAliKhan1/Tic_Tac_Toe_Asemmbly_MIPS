#Group: Muhamamd Ali Khan(CS172058)
#       Waqas Abdul Wahid(CS172050)
.data

#variables
square:     .byte 'O','1','2','3','4','5','6','7','8','9'   
slots:      .word  0 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1
player:     .word 1
i:          .word -1
choice:     .word 0
mark:       .byte '_'
X:          .byte 'X'
O:          .byte 'O'

newline:    .asciiz "\n"
space:      .asciiz " "

player_string:          .asciiz "\nPlayer "
input_string:           .asciiz ", enter a number: "
invalid_move_string:    .asciiz "\nInvalid move.\n"
win_string:             .asciiz " win.\n "
draw_string:            .asciiz "Game draw.\n"

#BOARD PROCEDURE STRING
title_string:               .asciiz           "\n\nTic Tac Toe\n\n" 
player_symbol_string:       .asciiz   "\nPlayer 1 (X) - Player 2 (O)\n\n"
board_string_one:           .asciiz       "     |     |     \n"
board_string_two:           .asciiz       " |  "
board_string_two_spaced:    .asciiz       "   |  "
board_string_three:         .asciiz     "_____|_____|_____\n"

#*****************************
#MAIN FUNCTION START
#*******************************
.text 
main:

    li $t9,2 
    li $t0,-1

    game_progress:
        bne     $t0,-1, end_game_progress   #(-1) INDICATES GAME IS IN PROGRESS
        jal     board   #FUNCTION CALL TO DRAW BOARD   
        lw      $t0,player  #$t0 = player 
        div     $t0,$t9     #$t0/$t9 
        mfhi    $a0         #REMAINDER STORED IN $a0 
        jal     setPlayer   #PLAYER IS SET UPON THE BASIS OF REMAINDER(FUNCTION CALL)
        jal     setMark     #MARK IS SET UPON THE PLAYER 1-(X)  2-(O)
        lw      $t0,player  

        li      $v0,4
        la      $a0,player_string
        syscall
        
        li      $v0,1
        move    $a0,$t0
        syscall
        
        li      $v0,4
        la      $a0,input_string
        syscall

        li      $v0,5
        syscall
        sw      $v0,choice  #CHOICE INPUT
        jal     setChoice   #CHOICE SETTER FUNCTION CALL
        jal     checkWin    #CHECKWIN FUNCTION CALL

        lw      $t0,player  
        add     $t0,$t0,1
        sw      $t0,player  #INCREMENT IN PLAYER VARIABLE

        lw      $t0,i       #GAME STATUS IS LOADED INTO $t0
        b   game_progress

    end_game_progress:
    jal board
    lw      $t0,i   #GAME STATUS LOADED INTO REGISTER
    
    beq     $t0,1,print_player_win
    b       print_draw  

    print_player_win:
        lw      $t0,player
        sub     $t0,$t0,1

        li      $v0,4
        la      $a0,player_string
        syscall

        li      $v0,1
        move    $a0,$t0
        syscall

        li      $v0,4
        la      $a0,win_string
        syscall
        
    b end

    print_draw:

        li      $v0,4
        la      $a0,draw_string
        syscall
    b end
end:
li      $v0,10
syscall
#*****************************
#MAIN FUNCTION END
#*******************************


#**********************************************
#FUNCTION TO SET TURNS OF PLAYER 1 AND PLAYER 2
#**********************************************
.globl setPlayer

    setPlayer:
        beq     $a0,0,set_player_2
        b       set_player_1

    set_player_2:
        li      $t0,2
        sw      $t0,player
        b       return_setPlayer
    set_player_1:
        li      $t0,1
        sw      $t0,player
        b       return_setPlayer
    return_setPlayer:
        jr      $ra
.end    setPlayer
#***********
#END
#***********

#***********************************************************
#FUNCTION TO SET MARK FOR THE PLAYER 
#IF ITS THE PLAYER 1 TURN THAN MARK(VAR) WILL BE SET TO 'X'
#IF PLAYER 2 THAN 'O'
#*********************************************
.globl  setMark
    setMark:
    	
    	lw  	$t0,player
    	lb	    $t1,X
    	lb	    $t2,O
        
        beq     $t0,1,setX
        b       setO
    
    setX:
        sb      $t1,mark
        b       return_setMark
    setO:
        sb      $t2,mark
        b       return_setMark

    return_setMark:
        jr      $ra
.end    setMark
#***********
#END
#***********

#*********************************************
#    FUNCTION TO RETURN GAME STATUS
#	1 FOR GAME IS OVER WITH RESULT
#	-1 FOR GAME IS IN PROGRESS
#	O GAME IS OVER AND NO RESULT
#**********************************************
.globl checkWin

    checkWin:
    li      $t0,1
    lb      $t1,square($t0)
    li      $t0,2
    lb      $t2,square($t0)
    li      $t0,3
    lb      $t3,square($t0)
    li      $t0,4
    lb      $t4,square($t0)
    li      $t0,5
    lb      $t5,square($t0)
    li      $t0,6
    lb      $t6,square($t0)
    li      $t0,7
    lb      $t7,square($t0)
    li      $t0,8
    lb      $t8,square($t0)
    li      $t0,9
    lb      $t9,square($t0)
    li      $t0,0

    beq     $t1,$t2,inc_1
    c_1:
    beq     $t2,$t3,inc_2
    c_2:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t4,$t5,inc_3
    c_3:
    beq     $t5,$t6,inc_4 
    c_4:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t7,$t8,inc_5
    c_5:
    beq     $t8,$t9,inc_6
    c_6:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t1,$t4,inc_7
    c_7:
    beq     $t4,$t7,inc_8
    c_8:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t2,$t5,inc_9
    c_9:
    beq     $t5,$t8,inc_10
    c_10:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t3,$t6,inc_11
    c_11:
    beq     $t6,$t9,inc_12
    c_12:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t1,$t5,inc_13
    c_13:
    beq     $t5,$t9,inc_14
    c_14:
    beq     $t0,2,return_one
    li      $t0,0

    beq     $t3,$t5,inc_15
    c_15:
    beq     $t5,$t7,inc_16
    c_16:
    beq     $t0,2,return_one
    li      $t0,0
    li      $t1,4

    slot_check:
        beq     $t1,40,end_loop

        lw      $t2,slots($t1)
        beq     $t2,0,inc_17
        c_17:
        add     $t1,$t1,4
        b slot_check
    end_loop:
        beq     $t0,9,return_zero
        b       return_negative_one
    
    inc_1:
        add $t0,$t0,1
        b c_1
    inc_2:
        add $t0,$t0,1
        b c_2
    inc_3:
        add $t0,$t0,1
        b c_3
    inc_4:
        add $t0,$t0,1
        b c_4
    inc_5:
        add $t0,$t0,1
        b c_5
    inc_6:
        add $t0,$t0,1
        b c_6
    inc_7:
        add $t0,$t0,1
        b c_7
    inc_8:
        add $t0,$t0,1
        b c_8
    inc_9:
        add $t0,$t0,1
        b c_9
    inc_10:
        add $t0,$t0,1
        b c_10
    inc_11:
        add $t0,$t0,1
        b c_11
    inc_12:
        add $t0,$t0,1
        b c_12
    inc_13:
        add $t0,$t0,1
        b c_13
    inc_14:
        add $t0,$t0,1
        b c_14
    inc_15:
        add $t0,$t0,1
        b c_15
    inc_16:
        add $t0,$t0,1
        b c_16
    inc_17:
        add $t0,$t0,1
        b c_17

    return_one:
        li  $t0,1
        sw  $t0,i
        b return_checkWin
    return_zero:
        li  $t0,0
        sw  $t0,i
        b return_checkWin
    return_negative_one:
        li  $t0,-1
        sw  $t0,i
        b return_checkWin

    return_checkWin:
        li  $t9,2
        jr $ra
.end checkWin
#***********
#END
#***********

#*************************************************************************************
#FUNCTION TO CHECK IF 
#THE SLOT IS FILLED OR NOT OF THE PARTICULAR INDEX WITH 'X' or 'O'
#**************************************************************************************
.globl setChoice
        
    setChoice:
        
    	lw      $t0,choice
    	lw      $t1,player
    	lb      $t2,mark
    	li      $t4,4
    	li      $t6,0
    
        beq     $t0,1,check_slot    
        beq     $t0,2,check_slot    
        beq     $t0,3,check_slot
        beq     $t0,4,check_slot
        beq     $t0,5,check_slot
        beq     $t0,6,check_slot
        beq     $t0,7,check_slot
        beq     $t0,8,check_slot
        beq     $t0,9,check_slot
        b       invalid_slot

    check_slot:
        mult    $t0,$t4
        mflo    $t5

        lw      $t3,slots($t5)
        beq     $t3,1,fill_slot
        
        b       invalid_slot
    fill_slot:
        sb      $t2,square($t0)
        sw      $t6,slots($t5)
        b       return_setChoice
    invalid_slot:
        li      $v0,4
        la      $a0,invalid_move_string
        syscall
        
        sub     $t1,$t1,1
        sw      $t1,player
        b       return_setChoice 

    return_setChoice:
        jr      $ra
.end setChoice
#***********
#END
#***********

#*******************************************************************
#     FUNCTION TO DRAW BOARD OF TIC TAC TOE WITH PLAYERS MARK
#********************************************************************
.globl board
    board:
        li      $v0,4
        la      $a0,title_string
        syscall

        li      $v0,4
        la      $a0,player_symbol_string
        syscall

        li      $v0,4
        la      $a0,board_string_one
        syscall

        li      $t1,1
        loop:
            bgt     $t1,9,print_board_string_one

            lb      $t0,square($t1)

            li      $v0,11
            move    $a0,$t0
            syscall

            li      $v0,4
            la      $a0,space
            syscall

            beq     $t1,3,skip
            beq     $t1,6,skip
            beq     $t1,9,skip
            beq     $t1,1,print_board_string_two_spaced
            beq     $t1,4,print_board_string_two_spaced
            beq     $t1,7,print_board_string_two_spaced

            li      $v0,4
            la      $a0,board_string_two
            syscall
            skip:
            beq     $t1,3,print_newline
            beq     $t1,6,print_newline
            beq     $t1,9,print_newline
            continue_1:
            beq     $t1,3,print_board_string_three
            beq     $t1,6,print_board_string_three
        
        continue_2:
                add     $t1,$t1,1
            b   loop

        print_board_string_three:
        
            li      $v0,4
            la      $a0,board_string_three
            syscall
            li      $v0,4
            la      $a0,board_string_one
            syscall
        
            b       continue_2

        print_newline:
            li      $v0,4
            la      $a0,newline
            syscall
            b       continue_1
        print_board_string_one:
            li      $v0,4
            la      $a0,board_string_one
            syscall   
            b       return_board
        print_board_string_two_spaced:
            li      $v0,4
            la      $a0,board_string_two_spaced
            syscall
            b       skip
    return_board:
        jr      $ra
.end board
#***********
#END
#***********
