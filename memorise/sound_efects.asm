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
