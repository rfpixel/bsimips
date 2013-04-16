## Cont�m procedimentos necess�rios para a execu��o da l�gica central do jogo.
 
.include "random.asm"
.include "sound_efects.asm"
.include "utilities.asm"

# Constantes que representam poss�veis resultados para cada tentativa. 
.eqv LOST_LEVEL 0
.eqv WON_GAME 1
.eqv WON_LEVEL 2

# Exibe o menu principal do jogo e retorna a op��o selecionada atrav�s do registrador $v0.  
.macro show_menu
	sub $sp, $sp, 4
 	print_string("Por favor, selecione a opcao desejada:\n")
	print_string("1 = jogar, 2 = exibir pontuacao atual, 3 = exibir ajuda e 0 = sair: ")
	read_integer($a0)
	sw $a0, 0 ($sp)
	clear
	lw $v0, 0 ($sp)
	addi $sp, $sp, 4
.end_macro

# Permite ao usu�rio selecionar o n�vel de dificuldade do jogo se desejado.
.macro prompt_select_level($level)
	.data
		yes: .byte 's'
		no: .byte 'n'
	.text
		sub $sp, $sp, 4 # stack frame
		prompt: print_string("Deseja selecionar o nivel de dificuldade do jogo?\n")
		print_string("s = sim, n = nao (comeca pelo nivel 1):")
		read_character($t0)
		sw $t0, 0 ($sp) # salva a resposta na stack
		clear

		lw $t0, 0 ($sp) # restaura a resposta da stack
		# Carrega da mem�ria os caract�res de compara��o.
		lb $t1, yes
		lb $t2, no

		beq $t0, $t1, get_level
		beq $t0, $t2, use_first_level
		# Se nenhum dos dois desvios foi executado, a op��o � inv�lida.
		print_string("Opcao invalida. Por favor, tente novamente\n\n")
		j prompt 
 
		get_level:
			print_string("Informe o nivel desejado (somente valores que estejam no intervalo [1-5]): ")
			read_integer($t0)
			# A seguir, validamos se a entrada est� no intervalo informado.
			slt $t1, $0, $t0
			slti $t2, $t0, 6
			and $t3, $t1, $t2  
			li $t4, 1 # valor para compara��o
			beq $t3, $t4, end_prompt_select_level
			# Se esse trecho foi executado, ent�o o valor digitado � inv�lido.
			clear
			print_string("Valor invalido, por favor, tente novamente\n\n")
			j get_level 

		use_first_level:
			li $t0, 1 # primeiro n�vel

			end_prompt_select_level:
				sw $t0, $level # armazena na mem�ria o n�vel a ser utilizado 
				addi $sp, $sp, 4 # restaura a stack frame  
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

# Realiza o c�mputo do resultado da tentativa.
# Ap�s a execu��o, um valor num�rico representando o resultado da tentativa atual � retornado atrav�s do registrador $v0. Adicionalmente, o total de n�meros utilizados no n�ivel � retornado atrav�s do registrador $v1.  
.macro compute_attempt_results($level, $last_level, $quantity_of_numbers, $number_of_sequences, $hits)
	# Carrega da mem�ria o n�vel atual.
	lw $t0, $level
	# Multiplica a quantidade de n�meros pelo n�mero de sequ�ncias.
	mult $quantity_of_numbers, $number_of_sequences
	# Obt�m o resultado a partir do registrador $lo
	mflo $t1

	# Se o n�mero de acertos n�o for igual ao total de acertos poss�veis no n�vel, desviamos para lost. 
	bne $hits, $t1, lost
		# Se esse trecho foi executado, o jogador venceu o n�vel. 
		# Ent�o vamos carregar o valor que representa o �ltimo n�vel.
		# O objetivo � verificarmos se o jogador venceu o jogo.  
		li $t2, $last_level

		# Se o n�vel atual n�o for o �ltimo, ent�o desviamos para o label indicado. 
		bne $t0, $t2, just_won_level
			# O jogador venceu o jogo.
			# Retornamos a constante que indica isso.
			li $v0, WON_GAME
			# Desvia para o fim da subrotina, saltando as instru��es a seguir.
			j end_compute_attempt_results 

		just_won_level:
			# Se esse trecho foi executado, ent�o o jogador s� venceu o n�vel atual.
			# Retornamos a constante que indica isso.
			li $v0, WON_LEVEL
			# Desvia para o fim da subrotina.
			j end_compute_attempt_results

	lost:
		# Retornamos a constante que indica que o jogador perdeu.
		li $v0, LOST_LEVEL
	end_compute_attempt_results:
		# Adicionalmente, retornamos o total de n�meros utilizados no n�vel.
		move $v1, $t1
.end_macro

# Exibe os resultados da tentativa.
# Par�metros:
# $level: endere�o para o n�vel atual armazenado na mem�ria.
# $hits: n�mero de acertos para a tentativa atual.
# $total_of_numbers: total de n�meros utilizados no n�vel
# $result_of_attempt: constante que indica o resultado da tentativa atual (0 = perdeu o n�vel, 1 = ganhou o jogo e 2 = ganhou o n�vel).
.macro print_attempt_results($level, $hits, $total_of_numbers, $result_of_attempt)
	sub $sp, $sp, 12 # stack frame 

		# Salva na stack os par�metros a serem utilizados posteriormente.
	sw $hits, 0 ($sp)
	sw $total_of_numbers, 4 ($sp)
	sw $result_of_attempt, 8 ($sp)

	print_string("Voce acertou ")
	lw $hits, 0 ($sp)
	print_integer($hits)
	print_string(" de ")
	lw $total_of_numbers, 4 ($sp)
	print_integer($total_of_numbers)
	print_string(" numeros")

	lw $result_of_attempt, 8 ($sp)

	beq $result_of_attempt, WON_GAME, congratulations # venceu o jogo
	beq $result_of_attempt, WON_LEVEL, can_advance # venceu o n�vel atual
	j try_again # perdeu o n�vel e deve tentar novamente

		congratulations:
			print_string(" e venceu o Memorize! Parabens!!!")
			# Dispara o efeito sonoro de vit�ria.
			victory
			# Desvia para o fim da subrotina, saltando as instru��es a seguir.
			j end_print_attempt_results

		can_advance:
			print_string(" e podera passar para o nivel ")
			# Incrementamos o valor do n�vel para mostrar ao usu�rio. 
			lw $t0, $level
			addi $t0, $t0, 1
			print_integer($t0)
			print_string("!")
			# Dispara o efeito sonoro associado ao acerto do jogador.
			hit
			# Desvia para o fim da subrotina.
			j end_print_attempt_results

		try_again:
			# Notificamos que o jogador perdeu e precisar� tentar de novo.
			print_string(", o que nao e suficiente para passar de nivel. ")
			print_string("Voce tera que tentar vencer o nivel ")
			lw $t0, $level
			print_integer($t0)
			print_string(" novamente!")
			# Tocamos o som que indica o erro.
			error

	end_print_attempt_results:
		print_string("\n\n")
		addi $sp, $sp, 12 # restaura a stack 
.end_macro

# Modifica o n�vel atual se necess�rio, isto �, se o jogador venceu o n�vel atual ou o pr�prio jogo.
# Se o jogador venceu o n�vel atual, o procedimento atualiza o n�vel para o pr�ximo.
# Se o jogador venceu o jogo, o n�vel de dificuldade retorna para 1. Caso contr�rio, o mesmo n�vel � mantido.
.macro modify_level($level, $result_of_attempt)
	# Carrega o n�vel atual da mem�ria.
	lw $t0, $level
	# Carrega as constantes que representam os poss�veis resultados da tentativa para posterior compara��o.
	li $t1, WON_LEVEL
	li $t2, WON_GAME

	# Se o jogador venceu o n�vel, passamos para o pr�ximo. 
	beq $result_of_attempt, $t1, pass_to_next
	# Se o jogador venceu o jogo, reiniciamos.
	beq $result_of_attempt, $t2, restart
	# Caso contr�rio, o jogador perdeu o n�vel e n�o faremos nada. 
	j keep_same_level

		# Incrementamos o n�vel atual. 
		pass_to_next: addi $t3, $t0, 1
		j update_level 

		# Retornamos ao n�vel 1.
		restart: li $t3, 1

		# Salvamos o novo valor na mem�ria.
		update_level: sw $t3, $level

		keep_same_level:
	.end_macro

# Exibe uma mensagem ao usu�rio perguntando se ele deseja continuar jogando e obt�m a resposta selecionada (s ou n).
# Ap�s a execu��o o registrador $v0 conter� uma flag indicando se o jogo deve ou n�o continuar.
# Retorno (em $v0): 1 (verdadeiro), o usu�rio deseja continuar ou 0 (falso) a execu��o deve retornar ao menu principal.  
.macro prompt_continue
	.data
		yes: .byte 's'
		no: .byte 'n'
	.text
		sub $sp, $sp, 4
		print_string("Deseja continuar jogando?\n")
		print_string("s = sim, n = retorna ao menu: ")
		read_character($t0)
		sw $t0, 0 ($sp)
		clear
		lw $t0, 0 ($sp)
		# Carrega os caracteres de compara��o da mem�ria.
		lb $t1, yes 
		lb $t2, no

		beq $t0, $t1, return_true
		beq $t0, $t2, return_false
			return_true: li $v0, 1
			j end_prompt_continue
			return_false: li $v0, 0
			end_prompt_continue:
			addi $sp, $sp, 4 
.end_macro

# Procedimento para a exibi��o da pontua��o geral do jogador.
.macro show_score($score)
	print_string("Sua pontuacao atual e ") 
	lw $t0, $score
	print_integer($t0)
	print_string("\n\n")
	print_string("Pressione qualquer letra para continuar")
	read_character($t0)
	clear
.end_macro  
