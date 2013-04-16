## Cont�m procedimentos relacionados a gera��o de sons para o jogo.
 
# Procedimento que emite um som de contagem a cada segundo, indicando a passagem do tempo e interrompendo a thread atual.
# O procedimento ser� utilizado para marcar o tempo em que os n�meros ficar�o vis�veis na tela.
# Ap�s o fim do tempo determinado, um som � emitido indicando que o tempo para o jogador memorizar os n�meros acabou.    
.macro clock($time)
	move $t0, $time
	# Carrega o MIDI out synchronous service
	li $v0, 33
	li $a0, 61 # pitch
	li $a1, 900 # dura��o em milisegundos
	li $a2, 12 # percuss�o crom�tica 
	li $a3, 127 # volume m�ximo

	loop_clock:
		sub $t0, $t0, 1
		syscall
		bne $t0, $0, loop_clock

	# A seguir, notificamos que o tempo acabou atrav�s de um aviso sonoro
	li $a0, 55 # pitch
	li $a1, 1000 # dura��o em milisegundos
	li $a2, 120 # efeito sonoro 

	syscall
	.end_macro

# Cria um efeito sonoro (ou uma tentativa de) para ser utilizado no in�cio do jogo.  
	.macro welcome
	# Carrega o MIDI out synchronous service
	li $v0, 33
	li $a0, 60 # pitch
	li $a1, 900 # dura��o em milisegundos
	li $a2, 24 # guitarra
	li $a3, 127 # volume m�ximo
	li $t0, 4 # contador para o loop

	loop_welcome:
		sub $t0, $t0, 1
		syscall
		addi $a0, $a0, 2
		sub $a1, $a1, 100
		bne $t0, $0, loop_welcome
	.end_macro

	# Dispara um efeito sonoro indicando que o jogador errou sua tentativa.
	.macro error
	# Carrega o MIDI out synchronous service
	li $v0, 33
	li $a0, 65 # pitch
	li $a1, 1000 # dura��o em milisegundos
	li $a2, 56 
	li $a3, 127 # volume m�ximo
	li $t0, 3 # contador para o loop

	loop_error:
		sub $t0, $t0, 1
		syscall
		sub $a0, $a0, 2
		bne $t0, $0, loop_error 
	.end_macro

	# Cria um efeito sonoro a ser utilizado para indicar o acerto do jogador. 
	.macro hit
		# Carrega o MIDI out synchronous service
	li $v0, 33
	li $a0, 60 # pitch
	li $a1, 1000 # dura��o em milisegundos
	li $a2, 96 # efeitos sintetizados 
	li $a3, 127 # volume m�ximo
	li $t0, 3 # contador para o loop

	loop_hit:
		sub $t0, $t0, 1
		syscall
		addi $a0, $a0, 2
		sub $a1, $a1, 100
		bne $t0, $0, loop_hit
.end_macro

.macro victory
	# Carrega o MIDI out synchronous service
	li $v0, 33
	li $a0, 30 # pitch
	li $a1, 200 # dura��o em milisegundos
	li $a2, 0 # piano
	li $a3, 127 # volume m�ximo
	li $t0, 7 # contador para o loop

	loop_victory:
		sub $t0, $t0, 1
		syscall
		addi $a0, $a0, 2
		addi $a1, $a1, 100
		bne $t0, $0, loop_victory
.end_macro
