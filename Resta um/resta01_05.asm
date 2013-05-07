.kdata

      L1:      .space 28                                      #Armazena a 1� Linha
      L2:      .space 28                                      #Armazena a 1� Linha
      L3:      .space 28                                      #Armazena a 1� Linha 
      L4:      .space 28                                      #Armazena a 1� Linha
      L5:      .space 28                                      #Armazena a 1� Linha
      L6:      .space 28                                      #Armazena a 1� Linha
      L7:      .space 28                                      #Armazena a 1� Linha
      teclin:  .word                                          #Cria a Vari�vel para guardar o que o usu�rio digita para linha 
      teccol:  .word                                          #Cria a Vari�vel para guardar o que o usu�rio digita para coluna 
      ponto:   .space 128                                     #Cria um espa�o na mem�ria para guardar a pontua��o que no m�ximo ser� 32 pontos                                    
      tecNome: .space 40                                      #Cria um array para guardar o nome do jogador
      glinha:  .word                                          # Variavel para guardar a linha
      gcol:    .word                                          # Variavel para guardar a coluna digitada
      PassaL:  .word 0
      PassaC:  .word 0
     
                    #abaixo segue as frases utilizadas durante o jogo
      fim:    .ascii "Fim do Jogo"                          
      err:    .ascii "Jogada Invalida"
      inicio: .ascii "Inicio da Jogo"
      linha:  .ascii "Digite a linha\n "
      col:    .ascii "Digite a Coluna "
      escnome:.ascii "Digite seu nome"
      plinha: .ascii "\n"
      
 #Macro para imprimir a linha que o usu�rio deseja movimentar 
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
# Vari�vel passada como paramentro %linha indica a linha
        
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
# Vari�vel passada como paramentro %pl
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
.macro erro(%err)
     
    la $t0, err
    li $v0, 4
    syscall
    
.end_macro
       
 #Macro que realiza o teste se a posi��o escolida n�o esta ocupada
 #N�o estando ocupada realiza a jogada
   
.macro muda(%colula, %coluna1, %Linha1, %Linha2)

       sub  $t4, $t4, $t4                # Zera o registrador
       addi $t4, $t4, 4                  # Adiciona 4 para mudar de posi��es do vetor
       li   $s0, ' '                     
       la   $t0, %colula
       mul  $t0, $t0, $t4
       la   $t1, %coluna1
       mul  $t1, $t1, $t4
       la   $t2, %Linha1
       lw   $t2, ($t0)
       la   $t3, %Linha2
       lw   $t2, ($t1)
          
       bne  $t1, $s0, sair
       move $t2, $t1                      # Move a pe�a da para outra posi��o
       move $t1, $s0                      # Muda o valor para vazio
       
        
sair: nop 
 
.end_macro

        
main:
    inicio0(L1)                      # Chama a macro para inserir a vari�vel   
    inicio0(L2)                      # Chama a macro para inserir a vari�vel 
    inicio(L3)                       # Chama a macro para inserir a vari�vel 
    inicio(L4)                       # Chama a macro para inserir a vari�vel 
    inicio(L5)                       # Chama a macro para inserir a vari�vel 
    inicio0(L6)                      # Chama a macro para inserir a vari�vel 
    inicio0(L7)                      # Chama a macro para inserir a vari�vel 
    
    la $t0, L4                       # Deixa a linha X coluna 4X4 vazia 
    li $t1, ' '		             # Condi��o da regra do jogo para iniciar
    sw $t1, 12($t0)
    
    # Imprime a tela do jogo
    # Chamada do macro para imprimir o jogo (Print(L)) passando a linha como parametro
    # Chamada da macro pulalinha que pula uma linha \n 
  
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
    
    li  $v0, 5                                               # Solicitar ao usu�rio a linha que deseja consultar      
    syscall
    sw  $v0, teclin                 
    
    imprimeColuna                                            
    
    li $v0, 5                      
    syscall                                                 # Macro para solicitar ao usu�rio a coluna que deseja consultar
    sw $v0, teccol
    
    # verifica se o que o jogador digitou esta na regra do jogo
    
    lw    $t5, teclin
    sub   $t3, $t3, $t3
    addi  $t3, $t3, 3
    sub   $t6, $t6, $t6
    addi  $t6, $t6, 5
    slt   $t2, $t3, $t5
    slt   $t2, $t5, $t6
    beqz  $t2, VerificaC
    j jogos
    
VerificaC:    
    lw    $t5, teccol
    sub   $t3, $t3, $t3
    addi  $t3, $t3, 3
    sub   $t6, $t6, $t6
    addi  $t6, $t6, 5
    slt   $t2, $t3, $t5
    slt   $t2, $t5, $t6
    beqz  $t2, erro
    j jogos
    
    
    
           # Solicitar ao usu�rio para onde a pe�a ir�
             

jogos:
    imprimeLinha         
    
    li $v0, 5       
    syscall
    sw $v0, glinha             # Grava a linha digitada pelo o jogador           
    
    imprimeColuna                                            
    
    li $v0, 5                      
    syscall                                                 
    sw $v0, gcol              # Grava a coluna digitada pelo o jogador 
    
     lw   $t5, glinha
    sub   $t3, $t3, $t3
    addi  $t3, $t3, 3
    sub   $t6, $t6, $t6
    addi  $t6, $t6, 5
    slt   $t2, $t3, $t5
    slt   $t2, $t5, $t6
    beqz  $t2, VerificaColuna         
    j verificaLinha                  # Caso seja digitado uma linha que n�o seja necess�rio verificar a coluna 
    
    #Verifica se a coluna onde o usu�rio ir� jogar � valida a primeira escolha    
    
VerificaColuna:    
    lw    $t5, gcol
    sub   $t3, $t3, $t3
    addi  $t3,$t3, 3
    sub   $t6, $t6, $t6
    addi  $t6,$t6, 5
    slt   $t2, $t3, $t5
    slt   $t2, $t5, $t6
    beqz  $t2, erro
    j verificaLinha       # Se a linha etiver correta ir� verificar a linha
    
    # Erro caso as regras do jogo tenha sido violada
    
erro: la $t0, err
      li $v0, 4
      syscall
      j Jinicio
      
      #Verifica se a coluna onde o usu�rio ir� jogar � valida a segunda escolha 
    
verificaLinha:  #Verifica se a linha escolida esta dentro das regras do jogo.
    
    lw   $t5, teclin
    lw   $t6, glinha
    sub  $t2, $t6, $t5
    subi $t4, $t2, 2
    beqz $t4, verificaColuna
    addi $t4, $t2, 2
    sub  $t1, $t1, $t1
    addi $t1, $t1, 1
    sw   $t1, PassaL
    beqz $t4, verificaColuna
    
    # Erro caso as regras do jogo tenha sido violada
    
    la $t0, err  
    li $v0, 4
    syscall
    j Jinicio
    
verificaColuna:       #Verifica se a coluna escolida esta dentro das regras do jogo.
      
     lw   $t5, teccol
     lw   $t6, gcol
     sub  $t2, $t6, $t5
     subi $t3, $t2, 2
     beqz $t3, verificaPosicao
     addi $t3, $t2, 2
     sw   $t1, PassaC
     beqz $t3, verificaPosicao    # Todas as posi��es validas vrificar a posi��o
     
     # Erro caso as regras do jogo tenha sido violada
     
     la $t0, err
     li $v0, 4
     syscall
     j Jinicio
     
#Verifica a posi��o se estiver vazia realiza a jogada
verificaPosicao:
     
    muda(teccol, gcol, teclin, glinha)  # Chamada do macro muda para a realizar a jogada
    
    #Reimprime a tela
     
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
    
    j jogos  

	  

       
                                          
    
