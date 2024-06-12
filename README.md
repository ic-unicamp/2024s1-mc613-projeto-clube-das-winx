# Projeto final de MC613 - 2024s1

Grupo:

- RA: 235634 - Nome: Giovanna Magario Adamo
- RA: 232450 - Nome: Bruno Gonçalves Rodrigues
- RA: 244185 - Nome: André Ribeiro Do Valle Pereira

## Descrição

Cronômetro digital com opção de timer e mostrador no display de 7 segmentos.
O SW1 define se estamos usando a opção de cronômetro ou timer (1 - timer, 0 - cronômetro)
Para o uso do cronômetro, o SW0 será usado para iniciar/pausar o cronômetro (1 - inicia, 0 - pausa), que inicia em 0 e vai até 99 horas, 59 minutos e 59 segundos. (lembrando que o SW1 deve estar na posição 0 para o funcionamento correto do cronômetro)
Para o uso do timer (com o SW1 na posição 1 e SW0 na posição 0), usamos o botão KEY1 para definir horas, minutos e segundos. SW7 define se iremos somar ou subtrair (1 - somar, 0 - subtrair). Com SW9 e SW8 desligados, estaremos definindo segundos, com apenas SW8 ligado, estaremos definindo minutos e, com SW9 ligado, estaremos definindo horas. Para iniciar o timer, basta ligar o SW2 e a contagem decrescerá até 0. Caso se desligue o SW2 antes do fim do timer, ele retornará para o valor inicial setado no timer. O botão KEY0 serve como reset e reseta tanto os registradores do timer quanto os do cronômetro para o valor 0.

