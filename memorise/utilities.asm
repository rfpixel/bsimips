## Cont�m procedimentos utilit�rios diversos para uso no jogo.

# Procedimento para imprimir a string informada como argumento.
.macro print_string($arg)
	.data
		the_string: .asciiz $arg
	.text
	la $a0, the_string 
		li $v0, 4
		syscall
.end_macro

# Procedimento para imprimir o inteiro informado como argumento
.macro print_integer($arg)
	move $a0, $arg
	li $v0, 1
	syscall
.end_macro

# Procedimento que obt�m um inteiro do teclado e o armazena no registrador passado como argumento atrav�s do par�metro $result. 
.macro read_integer($result)
	li $v0, 5 # carrega o read integer service
	syscall
	move $result, $v0 # armazena o resultado no registrador informmado 
.end_macro
 
# Procedimento que simula uma fun��o de limpeza do output.
# Na verdade, apenas imprimimos o caracter \n por repetidas vezes para que o conte�do anterior desapare�a.   
.macro clear
	li $t0, 1000

	loop_clear:
		sub $t0, $t0, 1
		print_string("\n")
			bne $t0, $0, loop_clear
.end_macro

# Procedimento que interrompe a thread atual por um tempo aproximado ao valor passado atrav�s do par�metro $duration.
# $duration: inteiro indicando o tempo em milissegundos em que o processo deve ser interrompido.  
.macro sleep($duration)
	li $v0, 32 # carrega o sleep service
	addi $a0, $0, $duration # atribui a dura��o a $a0
	syscall
.end_macro

# Procedimento para encerrar o programa.
.macro exit_program
	li $v0, 10
	syscall
	.end_macro
