## Cont�m procedimentos utilit�rios diversos para uso no jogo.

# Procedimento que abre o arquivo informado como par�metro, l� seu conte�do e o imprime no output padr�o.
# Ap�s ter impresso o conte�do do arquivo, este � fechado. 
# Par�metros:
# $file_name: nome do arquivo a ser lido e impresso.
# $maximum_numbers_of_characters: n�mero m�ximo de caracteres a serem lidos no arquivo.
.macro print_from_file($file_name, $maximum_numbers_of_characters)
	.data
		# Buffer para armazenar o conte�do do arquivo lido.
		buffer: .space $maximum_numbers_of_characters
	.text
		# Carrega o open file service.
		li $v0, 13
		# Carrega o endere�o que cont�m o nome do arquivo.
		la $a0, $file_name
		# Flag indicando que o arquivo ser� aberto em modo de leitura.
		li $a1, 0
		li $a2, 0 
		# Abre o arquivo indicado e retorna o "file descriptor" atrav�s de $v0.
		syscall
		# Salva o file descriptor em $t0.
		move $t0, $v0

		# Carrega o read file service.
		li $v0, 14
		move $a0, $t0 # file descriptor
		la $a1, buffer # buffer para o qual ser� copiado o conte�do do arquivo.
		li $a2, $maximum_numbers_of_characters # n�mero m�ximo de caracteres a serem lidos
		syscall # l� o conte�do do arquivo

		# Carrega o print string service
		li $v0, 4
		la $a0, buffer # carrega o buffer com o conte�do do arquivo
		syscall # imprime o conte�do do arquivo carregado

				# Carrega o close file service
		li $v0, 16
		move $a0, $t0 # file descriptor a ser fechado
		syscall # fecha o arquivo
.end_macro

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

# Procedimento que l� um caracter do teclado e o armazena no registrador passado como argumento atrav�s do par�metro $result.  
.macro read_character($result)
	# Carrega e executa a syscall para a leitura de caract�res.
	li $v0, 12
	syscall
	move $result, $v0
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
