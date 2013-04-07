## Cont�m procedimentos necess�rios para a execu��o da l�gica central do jogo.
 
.include "random.asm"
.include "sound_efects.asm"
.include "utilities.asm"

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

# Procedimento para imprimir as informa��es de cada tentativa.
# Par�metros:
# $level: registrador com o dado correspondente ao n�vel atual do jogo
# $current_sequence: registrador com o dado da sequ�ncia atual
# $sequences: registrador com o n�mero total de sequ�ncias
# $time: registrador com o tempo de dura��o dos n�meros na tela 
.macro print_attempt_info($level, $current_sequence, $sequences, $time)
	sub $sp, $sp, 16  # cria uma stack frame para esse procedimento

	# Armazena os par�metros na stack para evitar conflitos com os procedimentos posteriores
	sw $level, 0 ($sp)
	sw $current_sequence, 4 ($sp)
	sw $sequences, 8 ($sp)
	sw $time, 12 ($sp) 

	print_string("Nivel ")
	lw $level, 0 ($sp)
	print_integer($level)
	print_string(", sequencia ")
	lw $current_sequence, 4 ($sp) 
	print_integer($current_sequence)
	print_string(" de ")
	lw $sequences, 8 ($sp)
	print_integer($sequences)
	print_string("\n\n")
	print_string("Veja os numeros a seguir com bastante atencao. Voce tera cerca de ")
	lw $time, 12 ($sp)
	print_integer($time)
	print_string(" segundos para memoriza-los.\n\n")
	sleep(2000) # aguarda 2 segundos antes de retornar

	addi $sp, $sp, 16 # restaura a stack
.end_macro

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

# L� os n�meros digitados pelo usu�rio e os insere na mem�ria.
# Par�metros:
# $random_numbers e $user_numbers: labels para os respectivos arrays na mem�ria.
# $size: quantidade de n�meros nos arrays 
.macro read_numbers($random_numbers, $user_numbers, $size)
	sub $sp, $sp, 4 # cria a stack frame

	sw $size, 0 ($sp) # armazena o par�metro na stack

	# Ponteiro para o array de n�meros rand�micos.
	la $t0, $random_numbers
	# Ponteiro para o array de n�meros que ser�o informados pelo usu�rio.
	la $t1, $user_numbers
	# Posi��o atual que ser� exibida ao usu�rio. 
	li $t2, 0

	print_string("A seguir, informe o numero correspondente a cada posicao\n\n")
	lw $size, 0 ($sp) # restaura da stack

	loop_read_numbers:
		sub $size, $size, 1 # decrementa o contador
		sw $size, 0 ($sp) # salva o novo valor na stack
		addi $t2, $t2, 1 # incrementa a posi��o
		print_integer($t2)
		print_string(": ")
		# Obt�m o n�mero e o atribui ao registrador $t3
		read_integer($t3)
		# Armazena o valor no array 
		sw $t3, 0 ($t1)
		addi $t1, $t1, 4 # incrementa o ponteiro
		lw $size, 0 ($sp) # restaura novamente da stack
		bne $size, $0, loop_read_numbers

	clear
	addi $sp, $sp, 4
.end_macro

# Fun��o que calcula o �ndice atual de acertos do usu�rio e atualiza a pontua��o geral.
# Ap�s a execu��o o �ndice de acertos da tentativa � retornado atrav�s do registrador $v0. 
.macro compute_score($random_numbers, $user_numbers, $size, $score)
	# Ponteiros para os arrays na mem�ria
	la $t0, $random_numbers
	la $t1, $user_numbers
	li $t2, 0 # acertos na tentativa atual

	loop_compute_score:
		sub $size, $size, 1 # decrementa o contador
		# Obt�m os valores nos �ndices atuais dos arrays
		lw $t3, 0 ($t0)
		lw $t4, 0 ($t1)
		# Incrementa os ponteiros para a itera��o seguinte.
		addi $t0, $t0, 4
		addi $t1, $t1, 4 

		# Se os valores dos registradores forem diferentes, desvia para a instru��o
			# que verifica se o loop deve continuar. 
		bne $t3, $t4, end_loop_compute_score
		# Caso contr�rio, incrementa o valor dos acertos atuais.
		addi $t2, $t2, 1 
		end_loop_compute_score: 
		bne $size, $0, loop_compute_score

	# Atualiza a pontua��o geral do jogador
	lw $t5, $score
	add $t5, $t5, $t2
	sw $t5, $score
	# Deixa o valor dos acertos atuais no registrador $v0
	move $v0, $t2 
.end_macro

# Fun��o que executa a tentativa atual a partir dos par�metros informados.
# Ao ser executada os seguintes passos ocorrem:
# 1- Os n�meros rand�micos s�o exibidos no console.
# 2- O "clock" sonoro contabiliza o tempo em que os n�meros ficar�o vis�veis.
# 3- Ocorre a leitura dos n�meros informados pelo usu�rio.
# 4- O �ndice de acertos da tentativa atual � calculado e a pontua��o geral � atualizada.
# O n�mero de acertos � retornado atrav�s do registrador $v0.      
.macro run_attempt($random_numbers, $user_numbers, $level, $quantity_of_numbers, $number_of_sequences, $time, $score)
	sub $sp, $sp, 24 # ajusta a stack

	move $t0, $number_of_sequences # contador para o loop
	move $t1, $0 # armazenar� o valor da sequ�ncia tual
	li $t2, 0 # armazenar� a quantidade de acertos 

	# Salvamos os valores a serem utilizados posteriormente na stack 
	sw $quantity_of_numbers, 0 ($sp)
	sw $number_of_sequences, 4 ($sp)
	sw $time, 8 ($sp)
	sw $t2, 20 ($sp)

	loop_make_attempt:
		sub $t0, $t0, 1 # decrementa o contador
		sw $t0, 12 ($sp) # salvamos na stack

		addi $t1, $t1, 1 # incrementa o n�mero da sequ�ncia atual
		sw $t1, 16 ($sp) # salva na stack

		# Gera os n�meros rand�micos
		generate_random_numbers($random_numbers, $quantity_of_numbers)

		# Carrega a informa��o do n�vel atual
		lw $t3, $level  
	# Restauramos da stack os par�metros necess�rios ao pr�ximo procedimento
		lw $number_of_sequences, 4 ($sp)
		lw $time, 8 ($sp)
		lw $t1, 16 ($sp)
		print_attempt_info($t3, $t1, $number_of_sequences, $time)

		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		print_numbers($random_numbers, $quantity_of_numbers)
		lw $time, 8 ($sp) # restaura da stack 
		clock($time)
		clear

		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		read_numbers($random_numbers, $user_numbers, $quantity_of_numbers)

		lw $quantity_of_numbers, 0 ($sp) # restaura o valor para a chamada a seguir
		compute_score($random_numbers, $user_numbers, $quantity_of_numbers, $score)
		lw $t2, 20 ($sp) # restaura da stack
		# Incrementa os acertos com o valor retornado pela fun��o compute_score
		add $t2, $t2, $v0 
		sw $t2, 20 ($sp) # salva novamente na stack

		# Restauramos os par�metros necess�rios a pr�xima itera��o 
		lw $quantity_of_numbers, 0 ($sp)
		lw $t0, 12 ($sp)
		lw $t1, 16 ($sp)
		bne $t0, $0, loop_make_attempt

		# Retorna o n�mero de acertos da tentativa atrav�s de $v0
		lw $v0, 20 ($sp)

	# Restaura a stack � posi��o original
	addi $sp, $sp, 24  
.end_macro  

