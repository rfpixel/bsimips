#------------------------------------------------------------------------------
# grupo0.asm
# Jogo de adivinhar um numero gerado aleatoriamente
# Autor: Ricardo Menotti
#------------------------------------------------------------------------------

.data

msgSemente:	.asciiz "Informe um numero qualquer para comecar"
msgAdivinhe:	.asciiz "Adivinhe qual numero foi gerado!"
msgPalpite:	.asciiz "Informe um palpite:"
msgMaior:	.asciiz "O numero eh maior..."
msgMenor:	.asciiz "O numero eh menor..."
msgAcertou:	.asciiz "Voce acerto!"
msgDesculpe:	.asciiz "Desculpe, nosso jogo ainda nao foi implementado :-("

.text

main:

la $a0, msgSemente
li $v0, 51
syscall

la $a0, msgDesculpe
li $v0, 55
syscall

li $v0, 10
syscall