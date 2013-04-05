## Cont�m procedimentos para a gera��o dos n�meros rand�micos utilizados no jogo.

# Define uma constante que representa o maior valor poss�vel para os n�meros gerados pelo jogo. 
.eqv max_value 100	

# Procedimento que cria uma seed para o algor�tmo de gera��o de n�meros rand�micos a partir da data atual do sistema.
# Estabelece-se que o id do gerador de n�meros pseudo rand�micos ser� 1.
# Esse id dever� ser utilizado pela syscall que gerar� os n�meros rand�micos propriamente ditos.
.macro set_seed
	# carrega o time service.
	li $v0, 30
	# A syscall gerar� um valor de 64 bits que corresponde a data atual do sistema em milisegundos.  
	syscall

	# Move os 32 bits menos significativos do tempo para o registrador $a1 (o segundo argumento para a syscall posterior). 
	move $a1, $a0
	# Carrega a syscall set seed.
	li $v0, 40
	# Define o id para o gerador de n�meros rand�micos.
	li $a0, 1
			syscall
	.end_macro

# Procedimento que gera n�meros aleat�rios e os armazena na mem�ria (no endere�o indicado pelo par�metro $target).
.macro generate_random_numbers($target, $length)
	la $t0, $target # ponteiro para o array na mem�ria.
	move $t1, $length # contador para o loop.

	loop_random:
		# id do gerador de n�meros rand�micos definido na subrotina set_seed.
		li $a0, 1 
		li $a1, max_value # o valor limite para o intervalo.  
		li $v0, 42 # carrega o random int range service.
		syscall
		sw $a0, 0 ($t0) # armazena o n�mero aleat�rio na mem�ria.
				sub $t1, $t1, 1 # decrementa o contador.
		addi $t0, $t0, 4 # incrementa o "ponteiro".
		bne $t1, $0, loop_random
.end_macro
