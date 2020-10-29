
# PLOG 2020/2021 - TP1

## Groupo: T04Gekitai4


| Name             | Number    | E-Mail                |
| ---------------- | --------- | --------------------- |
| Caio Nogueira    | 201806218 | up201806218@fe.up.pt  |
| Telmo Botelho    | 201806821 | up201806821@fe.up.pt  |

----

## O jogo: Gekitai

- Gekitai é um jogo de estratégia de tabuleiro criado em 2020. Consiste em dois jogadores, cada um com 8 peças de uma cor que os representa, jogado num tabuleiro 6 por 6 onde cada jogador pode colocar as suas peças, uma de cada vez. A condição vencedora é um dos jogadores obter 3 das suas peças em linha, seja esta horizontal, vertical ou diagonal, ou ter no tabuleiro as suas 8 peças depois de realizar uma jogada. Contudo não e assim tão fácil de chegar ao objetivo pois sempre que é colocada uma peça, esta “empurra” qualquer peça adjacente que esteja livre (não alinhada por duas ou mais peças), peças que caiem do tabuleiro regressam aos jogadores.

  - [link para a fonte](https://boardgamegeek.com/boardgame/295449/gekitai)

----
## Representação interna do estado do jogo

- Situação Inicial:

```
-   initialBoard([  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,empty,empty,empty,empty,empty]  
    ]).  
```

        | A | B | C | D | E | F |  
     ---|---+---+---+---+---+---|  
      1 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      2 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      3 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      4 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      5 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      6 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  


- Situação Intermédia:

```  
-   midBoard([  
    [red,empty,black,empty,black,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [black,empty,empty,red,empty,empty],  
    [empty,empty,empty,empty,empty,black],  
    [empty,red,empty,empty,empty,empty],  
    [empty,empty,empty,empty,red,empty]  
    ]).
```    

        | A | B | C | D | E | F |  
     ---|---+---+---+---+---+---|  
      1 | O |   | X |   | X |   |  
     ---|---+---+---+---+---+---|  
      2 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      3 | X |   |   | O |   |   |  
     ---|---+---+---+---+---+---|  
      4 |   |   |   |   |   | X |  
     ---|---+---+---+---+---+---|  
      5 |   | O |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      6 |   |   |   |   | O |   |  
     ---|---+---+---+---+---+---|  


- Situação Final:

```  
-   finalBoard([  
    [empty,empty,empty,red,empty,empty],  
    [empty,empty,empty,empty,empty,empty],  
    [empty,black,empty,empty,red,empty],  
    [empty,empty,black,empty,empty,empty],  
    [red,empty,empty,black,empty,empty],  
    [empty,empty,empty,empty,empty,red]  
    ]).
``` 

        | A | B | C | D | E | F |  
     ---|---+---+---+---+---+---|  
      1 |   |   |   | O |   |   |  
     ---|---+---+---+---+---+---|  
      2 |   |   |   |   |   |   |  
     ---|---+---+---+---+---+---|  
      3 |   | X |   |   | O |   |  
     ---|---+---+---+---+---+---|  
      4 |   |   | X |   |   |   |  
     ---|---+---+---+---+---+---|  
      5 | O |   |   | X |   |   |  
     ---|---+---+---+---+---+---|  
      6 |   |   |   |   |   | O |  
     ---|---+---+---+---+---+---|
