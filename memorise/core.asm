## Cont�m procedimentos necess�rios para a execu��o da l�gica central do jogo.
 
.include "random.asm"
.include "sound_efects.asm"
.include "utilities.asm"

# Procedimento para a impress�o da sequ�ncia de n�meros informada como argumento.
.macro print_numbers($numbers, $size)
	la $t0, $numbers # carrega o primeiro endere�o da sequ�ncia de n�meros 
	move $t1, $size # contador do loop.

	loop_print_numbers:
		sub $t1, $t1, 1 # decrementa o contador.
		lw $t2, 0 ($t0) # carrega o n�mero atual.
		print_integer($t2)
		print_string(" ") # imprime um espa�o entre os n�meros
		addi $t0, $t0, 4 # incrementa o ponteiro para o array.
		bne $t1, $0, loop_print_numbers
	print_string("\n") # quebra a linha ap�s o �ltimo n�mero
.end_macro

.macro read_numbers($random_numbers, $user_numbers, $size)
	# Salva o par�metro $size na stack.
	sw $size, 16 ($sp)

	# Ponteiro para o array de n�meros rand�micos.
	la $t0, $random_numbers
	# Ponteiro para o array de n�meros que ser�o informados pelo usu�rio.
	la $t1, $user_numbers
	# Posi��o atual que ser� exibida ao usu�rio. 
	li $t2, 0

	print_string("A seguir, informe o numero correspondente a cada posicao\n\n")
	lw $size, 16 ($sp) # restaura da stack

	loop_read_numbers:
		sub $size, $size, 1 # decrementa o contador
		sw $size, 16 ($sp) # salva o novo valor na stack
		addi $t2, $t2, 1 # incrementa a posi��o
		print_integer($t2)
		print_string(": ")
		# Obt�m o n�mero e o atribui ao registrador $t3
		read_integer($t3)
		# Armazena o valor no array 
		sw $t3, 0 ($t1)
		addi $t1, $t1, 4 # incrementa o ponteiro
		lw $size, 16 ($sp) # restaura novamente da stack
		bne $size, $0, loop_read_numbers
.end_macro

# Define as configura��es do n�vel atual do jogo, isto �, determina a quantidade de n�meros a ser exibida,
# a quantidade de sequ�ncias e o tempo de memoriza��o.
# Ap�s ser chamado o procedimento armazena os resultados nos registradores $a0, $a1 e $a2. 
.macro set_level_configurations($level, $numbers_per_level, $sequences_per_level, $time_per_level)
	# A seguir, carregamos os endere�os dos arrays na mem�ria que cont�m as configura��es para o n�vel atual do jogo.    
	la $t0, $numbers_per_level
	la $t1, $sequences_per_level
	la $t2, $time_per_level

	# A seguir, determinamos qual o �ndice dos arrays cont�m as configura��es para o n�vel atual do jogo.
	lw $t3, $level # carrega o n�vel da mem�ria
	sub $t3, $t3, 1
	li $t4, 4
	mult $t3, $t4
	# move o valor de LO para o registrador $t3.
	mflo $t3

	# O registrador $t3 cont�m o valor base para o deslocamento pelos arrays. 
	add $t0, $t0, $t3
	add $t1, $t1, $t3
		add $t2, $t2, $t3
   
	# Por fim, deixamos os valores de retorno nos registradores $a0, $a1 e $a2
	lw $a0, 0 ($t0)
		lw $a1, 0 ($t1)
			lw $a2, 0 ($t2)
.end_macro

.macro make_attempt($random_numbers, $user_numbers, $quantity_of_numbers, $number_of_sequences, $time)
	# Salvamos os valores dos par�metros na stack.
	# Isso � necess�rio para emular uma "stack frame" e evitar conflitos com os procedimentos chamados mais abaixo.  
	sw $quantity_of_numbers, 0 ($sp)
	sw $time, 4 ($sp)
 
	loop_make_attempt:
		sub $number_of_sequences, $number_of_sequences, 1 # decrementa o contador
		sw $number_of_sequences, 8 ($sp) # salvamos na stack
		# Gera os n�meros rand�micos
		generate_random_numbers($random_numbers, $quantity_of_numbers)
		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		print_numbers($random_numbers, $quantity_of_numbers)
		lw $time, 4 ($sp) # restaura da stack 
		clock($time)
		clear
		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		read_numbers($random_numbers, $user_numbers, $quantity_of_numbers)

		# Restauramos todos os par�metros para a continuidade do loop
		lw $quantity_of_numbers, 0 ($sp)
		lw $time, 4 ($sp)
		lw $number_of_sequences, 8 ($sp)
		bne $number_of_sequences, $0, loop_make_attempt  
.end_macro  
