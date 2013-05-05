.kdata

      L1:      .space 28                                      #Armazena a 1� Linha
      L2:      .space 28                                      #Armazena a 2� Linha
      L3:      .space 28                                      #Armazena a 3� Linha 
      L4:      .space 28                                      #Armazena a 4� Linha
      L5:      .space 28                                      #Armazena a 5� Linha
      L6:      .space 28                                      #Armazena a 6� Linha
      L7:      .space 28                                      #Armazena a 7� Linha
      teclin:  .space 28                                      #Cria a Vari�vel para guardar o que o usu�rio digita para linha atual
      teccol:  .space 28                                      #Cria a Vari�vel para guardar o que o usu�rio digita para coluna atual
      tlin:    .space 28				      #Cria a Vari�vel para guardar o que o usu�rio digita para linha destino
      tcol:    .space 28				      #Cria a Vari�vel para guardar o que o usu�rio digita para coluna destino
      ponto:   .space 128                                     #Cria um espa�o na mem�ria para guardar a pontua��o que no m�ximo ser� 32 pontos                                    
      tecNome: .space 40                                      #Cria um array para guardar o nome do jogador
      glinha:  .space 28                                      # Variavel para guardar a linha
      gcol:    .space 28                                      # Variavel para guardar a coluna digitada
      
                                                            #abaixo segue as frases utilizadas durante o jogo
      fim:    .ascii "Fim do Jogo"                          
      err:    .ascii "Jogada Invalida"
      inicio: .ascii "Inicio da Jogo"
      linha:  .ascii "Digite a linha\n "
      col:    .ascii "Digite a Coluna "
      escnome:.ascii "Digite seu nome"
      plinha: .ascii "\n"
      
 #Macro para imprimir a linha que o usu�rio deseja movimentar 
.macro errou
.data
      msg:   .asciiz "Jogada Inv�lida \n"                                   #Mensagem que ser� impressa na chamada do SO
   .text    
   li $v0, 4
   la $a0, msg                                                              #Mensagem que ser� impressa na chamada do SO
   syscall
.end_macro

.macro imprimeLinha
.data
      msg:   .asciiz "Digite a linha que deseja movimentar"                 #Mensagem que ser� impressa na chamada do SO
   .text    
   li $v0, 4
   la $a0, msg                                                              #Mensagem que ser� impressa na chamada do SO
   syscall
.end_macro

.macro imprimeColuna
    .data
      msgc:   .asciiz "Digite a coluna que deseja movimentar"               #Mensagem que ser� impressa na chamada do SO
   .text    
    la $a0, msgc                                                            #Mensagem que ser� impressa na chamada do SO
    li $v0, 4
    syscall
.end_macro

.macro impLinha
.data
      msg:   .asciiz "Digite a linha para onde deseja movimentar"           #Mensagem que ser� impressa na chamada do SO
   .text    
   li $v0, 4
   la $a0, msg                                                              #Mensagem que ser� impressa na chamada do SO
   syscall
.end_macro

.macro impColuna
    .data
      msgc:   .asciiz "Digite a coluna para onde deseja movimentar"         #Mensagem que ser� impressa na chamada do SO
   .text    
    la $a0, msgc                                                            #Mensagem que ser� impressa na chamada do SO
    li $v0, 4
    syscall
.end_macro

#Macro que inicia o vetor com espa�o e 'o' pque s�o a pe�as do jogo nas linha com apenas 3 pe�as
.macro inicio0(%linha)

    .text
                la $t0, %linha 
        	li $t1, ' '		
		sw $t1, ($t0)
		li $t1, ' '		
		sw $t1, 4($t0)
		li $t1, 'o'				
		sw $t1, 8($t0)
        	li $t1, 'o'		
		sw $t1, 8($t0)		
                li $t1, 'o'		
		sw $t1, 12($t0)
		li $t1, 'o'		
		sw $t1, 16($t0)
.end_macro            

#Macro que inicia o vetor com espa�o e 'o' pque s�o a pe�as do jogo nas linha com 7 pe�as         
.macro inicio (%linha)

    .text
                la $t0, %linha 
        	li $t1, 'o'		
		sw $t1, ($t0)		
		li $t1, 'o'		
		sw $t1, 4($t0)		
		li $t1, 'o'		
		sw $t1, 8($t0)		
                li $t1, 'o'		
		sw $t1, 12($t0)
		li $t1, 'o'		
		sw $t1, 16($t0)
		li $t1, 'o'		
		sw $t1, 20($t0)
		li $t1, 'o'		
		sw $t1, 24($t0)

 .end_macro

# macro para imprimir o jogo na tela
.macro print(%pl)
             
          	la $t0, %pl
		la $a0, ($t0)
		li $v0, 4
		syscall

		la $a0, 4($t0)
		li $v0, 4
		syscall
		
		la $a0, 8($t0)
		li $v0, 4
		syscall
		
		la $a0, 12($t0)
		li $v0, 4
		syscall
		
		la $a0, 16($t0)
		li $v0, 4
		syscall
	
		la $a0, 20($t0)
		li $v0, 4
		syscall
		
	        la $a0, 24($t0)
		li $v0, 4
		syscall

.end_macro

#macro para pular linha
.macro pulalinha
      la $a0, plinha
      li $v0, 4
      syscall      
.end_macro


# programa principal
.text

    
main:
    inicio0(L1)                                                     # Chama a macro para inserir a vari�vel   
    inicio0(L2)
    inicio(L3)
    inicio(L4)
    inicio(L5)
    inicio0(L6)
    inicio0(L7)
    
    la $t0, L4
    li $t1, ' '		
    sw $t1, 12($t0)
  
    print(L1)
    pulalinha
    print(L2)
    pulalinha
    print(L3)
    pulalinha
    print(L4)
    pulalinha
    print(L5)
    pulalinha
    print(L6)
    pulalinha
    print(L7)
    pulalinha
    pulalinha
   
        
Jinicio:
 
    imprimeLinha         
    
    li $v0, 5                                             # Macro para solicitar ao usu�rio a linha que deseja consultar      
    syscall
    sw $v0, teclin                 
    
    imprimeColuna                                            
    
    li $v0, 5                      
    syscall                                               # Macro para solicitar ao usu�rio a coluna que deseja consultar
    sw $v0, teccol
    
 
    impLinha         
    
    li $v0, 5                                             # Macro para solicitar ao usu�rio a linha que deseja consultar      
    syscall
    sw $v0, tlin                 
    
    impColuna                                            
    
    li $v0, 5                      
    syscall                                               # Macro para solicitar ao usu�rio a coluna que deseja consultar
    sw $v0, tcol
    
 verifica:
 
    	lw $t2, teclin
    	lw $t3, teccol
    	beq $t2, 1, ver
    	ver: beq, $t3, 1, erro

verifica1:
 
    	lw $t2, teclin
    	lw $t3, teccol
    	beq $t2, 1, ver1
    	ver1: beq, $t3, 2, erro   	    	
	
 verificaLinha:
 
    sub  $t5, $t5, $t5
    addi $t5, $t5, 2
    sub  $t6, $t6, $t6
    addi $t6, $t6, -2
    lw   $t2, teclin                                         # Verificar erros
    lw   $t3, tlin 
    sub  $t4, $t3, $t2                                       # Soma 0 com o valor digitado, se for igual a 2 o usu�rio que movimentar duas casas para frente 
    beq  $t4, $t5, verificaColuna                            # Se for igual ir� verificar se a coluna ir� movimentar
    beq  $t4, $t6, verificaColuna                            # Se for -2 o usu�rio ir� caminhar para esquerda do jogo.
    blt $t4, $t5, erro					     #Se a subtra��o entre os valores digitados forem maiores que 2, mensagem de erro	
    bgt $t4, $t6, erro					     #Se a subtra��o entre os valores digitados forem menores que -2, mensagem de erro	
    blt $t4, $t6, erro					     #Se a subtra��o entre os valores digitados forem maiores que -2, mensagem de erro	
    bgt $t4, $t5, erro					     #Se a subtra��o entre os valores digitados forem menores que 2, mensagem de erro
    
    j Jinicio
    syscall

erro:
	addi $t2, $t0, 1
	        
verificaColuna:
  
     sw   $t2, glinha     
     sub  $t5, $t5, $t5
     addi $t5, $t5, 2
     sub  $t6, $t6, $t6
     addi $t6, $t6, -2
     lw   $t2, teccol                                         # Verificar erros
     lw   $t3, tcol
     sub  $t4, $t3, $t2                                       # Soma 0 com o valor digitado, se for igual a 2 o usu�rio que movimentar duas casas para frente 
     beq  $t4, $t5, verificaEspaco                            # Se for igual ir� verificar se n�o h� erros de de digito fora do teclado
     beq  $t4, $t6, verificaEspaco                            # Se for -2 o usu�rio ir� cverificar se n�o h� erros de de digito fora do teclado
     blt $t4, $t5, erro1			              #Se a subtra��o entre os valores digitados forem maiores que 2, mensagem de erro	
     bgt $t4, $t6, erro1				      #Se a subtra��o entre os valores digitados forem menores que -2, mensagem de erro
     blt $t4, $t6, erro1			              #Se a subtra��o entre os valores digitados forem maiores que -2, mensagem de erro	
     bgt $t4, $t5, erro1			              #Se a subtra��o entre os valores digitados forem menores que 2, mensagem de erro                                 	                                               
     j Jinicio
     
erro1:
     addi $t9, $t2, 1
     beq $t9, 2, erro2
     
erro2: 
	errou 
	         
	           
 verificaEspaco:
 
     sw $t2, gcol
     sub $t2, $t2, $t2
     sub $t3, $t3, $t3
     addi $t2, $t2, 2
     addi $t3, $t3, 2   
     j Jinicio    
 
                                          
    
