

  
# PLOG 2020/2021 - TP1

## Group: T4_Gekitai4


| Name                 | Number    | E-Mail               |
| -------------------- | --------- | -------------------- |
| Caio Macedo Nogueira | 201806218 | up201806218@fe.up.pt |
| Telmo Costa Botelho  | 201806821 | up201806821@fe.up.pt |

----

## Gekitai

 - Gekitai is a 2-person strategy game created in 2020. It consists of two players, each with 8 pieces of a color that represents them, played on a 6 by 6 board where each player can place their pieces, one at a time in an empty space.
 - In order to win, one of the players must align 3 of their pieces in a row horizontally, vertically or in diagonal, or to have their 8 pieces on the board after making a move.
 -   However, it is not that easy to reach the goal because whenever a piece is placed, it “pushes” any adjacent piece that is free (not aligned by two or more pieces), pieces that fall from the board return to the players.
 
 ## Instalation and execution

* In order to execute the program, please follow the next steps:
	- Install and and run SICStus Prolog
	-    Go to File > Working Directory and navigate to the  _src_  folder where you downloaded the code.
	-    Go to File > Consult and select the file ``gekitai.pl``;
	- type "play." to start the game;
		-  The row inputs are given as numbers (1 - 6),
		- The column inputs are given as letters ('A' - 'F');

	**Material**  
		- Board 6 * 6;  
		- 16 Markers (8 of each color);
			
 - [source](https://boardgamegeek.com/boardgame/295449/gekitai)
 - [board](https://s3.amazonaws.com/geekdo-files.com/bgg260973?response-content-disposition=inline%3B%20filename%3D%22Gekitai_Generic_Board.pdf%22&response-content-type=application%2Fpdf&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJYFNCT7FKCE4O6TA%2F20201101%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201101T162309Z&X-Amz-SignedHeaders=host&X-Amz-Expires=120&X-Amz-Signature=5658ba23308bf6e840e5040dc421f7ac9c108a34c7f8392e0a40ae4e60769bb1)
 - [rules](https://s3.amazonaws.com/geekdo-files.com/bgg260437?response-content-disposition=inline%3B%20filename%3D%22Gekitai_Rules.pdf%22&response-content-type=application%2Fpdf&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJYFNCT7FKCE4O6TA%2F20201101%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201101T160235Z&X-Amz-SignedHeaders=host&X-Amz-Expires=120&X-Amz-Signature=9e06a7d642935f212181bfdeb63632a8fa21ebc2070973ab2fb2ae625009a0da)

----
# Game Logic
## Internal representation of the GameState

**Board**
 * The board is represented by a list of lists, where each internal list represents a row of the board. Each cell can be an empty space, a red piece or a black piece.
  
	```[  
    [empty,red,black,empty,red,empty],  
    [empty,empty,empty,black,empty,black],  
    [black,empty,red,empty,empty,red],  
    [empty,black,empty,empty,empty,black],  
    [empty,empty,empty,red,empty,empty],  
    [black,red,empty,empty,black,empty]  
    ]
    ```  
 **Player**
 * Each player and empty cells are represented by an atom. Each player gets assigned with a color, black or red. An empty cell is just a space, " " . 
 * To improve interface usability, we write the current player in the display_game predicate.
 * 
 **Game Loop**
 * In Gekitai, the player with the black pieces starts first, followed by the player with the red pieces, beginning a game loop that lasts until the end of the game.
 * The processing of the game loop is done in the following way:
	- Initially, we call the predicate initial(GameState), to initialize an empty board, and assert that the player with the black pieces goes first;
	- Inside the loop section, we retrieve information containing the current player and board;
	- Call the "playMove" predicate, responsible for reading user input and calling upon ``move(GameState, Move, NewGameState)`` to replace the empty cells for "X" or "0" cells, depending on the player;
	- Receive information about the next player from "playMove";
	- Finally, every iteration of the loop displays the current state of the board.
* The loop repeats itself until one of the players win (this verification is not yet implemented in the source code).

**GameStates**
 * **Initial Situation** 

 *   	[  
	    [empty,empty,empty,empty,empty,empty],  
	    [empty,empty,empty,empty,empty,empty],  
	    [empty,empty,empty,empty,empty,empty],  
	    [empty,empty,empty,empty,empty,empty],  
	    [empty,empty,empty,empty,empty,empty],  
	    [empty,empty,empty,empty,empty,empty]  
	    ]).  
	    
 *          | A | B | C | D | E | F |  
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


 * **Intermediate Situation** 

*		[  
	    [red,empty,black,empty,black,empty],  
	    [empty,empty,empty,empty,empty,empty],  
	    [black,empty,empty,red,empty,empty],  
	    [empty,empty,empty,empty,empty,black],  
	    [empty,red,empty,empty,empty,empty],  
	    [empty,empty,empty,empty,red,empty]  
	    ].

*   	    | A | B | C | D | E | F |  
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


 * **Final Situation** 
   
*	    [  
	    [empty,empty,empty,red,empty,empty],  
	    [empty,empty,empty,empty,empty,empty],  
	    [empty,black,empty,empty,red,empty],  
	    [empty,empty,black,empty,empty,empty],  
	    [red,empty,empty,black,empty,empty],  
	    [empty,empty,empty,empty,empty,red]  
	    ].

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

## GameState Visualization

 * The board is printed with a call to the predicate `printBoard(X)`, that calls the predicate `printMatrix`. 
 * `printMatrix([Head|Tail], N)` is a recursive predicate, that calls `printLine([])`, also recursively, that prints each cell.
 * For a better display, we convert the values of the list for symbols "X", "O", and " ", respectively there are 'Black Player', 'Red Player' and empty cell.
	``` 
	symbol(1,S) :- S='Black'.
	symbol(2,S) :- S='Red'.
	symbol(empty,S) :- S=' '.
	symbol('Black',S) :- S='X'.
	symbol('Red',S) :- S='O'.
	```
 * Initial State:
		 ![Initial State](img/initial_state.png)
* Intermediate State:
		 ![Intermediate State](img/mid_state.png)
* Final State:
		 ![Final State](img/final_state.png)

## Valid moves list - [play.pl](./src/play.pl) & [utils.pl](./src/utils.pl)
In order to obtain all the possible moves that the player can make, we implemented the predicate valid_moves(+GameState, +Player, -ListOfMoves):
``
valid_moves(GameState, Player, ListOfMoves):-
findall(UpdatedBoard, gen_move(Player ,GameState, UpdatedBoard), ListOfMoves).
``
 In the valid_moves predicate, we call the findall predicate, tha lists all the possible moves, using the helper predicate ``gen_move``. This predicate iterates the board, placing the player's piece in any empty square.
 This way, by calling the ``gen_move`` predicate inside the findall, ListOfMoves returns all the valid moves that can be made in the current game state.

## Move execution - [input.pl](./src/input.pl) & [play.pl](./src/play.pl)
The validation and execution of the moves made by a human player is done using the predicate ``move(GameState, Move, NewGameState)``.
This predicate receives in Move, a list containing the row, column and the player to move, received in the predicate ``playMove(Player, NextPlayer, State, NewState)``, that reads the user input containing the information about the row and column where the player wants to place his piece.
After placing the piece on the board, all there is left to do is to process consequent repulsions (by calling ``repulsions`` predicate).

## Game Over - [play.pl](./src/play.pl) & [utils.pl](./src/utils.pl)
The game_loop predicate needs an end condition. In this case, when a player wins the game, the game loop ends and a message is printed to the console containing the information about the winner. 
To process the game over verification, we implemented the ``game_over(GameState, Winner)``, that calls upon 
the ``checkWin(Board,Piece)`` that looks for 3 in a row appearances or 8 pieces on the board for each player.
In case one of these conditions is met, Winner assumes the value of the respective player, 'Red' or 'Black' and the game_loop stops. If no winner is found, Winner is unified with the atom 'none' ant the game_loop continues. 
* The 3 in a row verification is done by calling the ``checkAllRowsCols(7,7,Board,Piece)``, that iterates the whole board, looking for three pieces in a row;
* To verify the number of pieces from each player, we call ``verifyPieces(BoardList, 1, Piece, 8)``, that recieves a flatten board and returns success in case the player has 8 pieces on the board. 
 


## Board Evaluation - [utils.pl](./src/utils.pl)
Since Gekitai does not have a points system, we implemented one of our own, that is used for finding the best PC move, given a list of possible moves. The calculation of the poinst associated with each board is done by the predicate ``value(GameState, Player, Value)`` . The points system implemented has in consideration the following situations:
* The player has 2 pieces in a row in any direction: in this case, for each occurrence, we increment 40 points to the respective player. This verification is done by calling the helper predicates ``find2inrowCol``, ``find2inrowRow``, ``find2inrowRightDiagonal`` and ``find2inrowLeftDiagonal``;
* The number of pieces from a player is changed after a move is made. Each piece is worth 2 points and the number of pieces is counted by the predicate ``findNumPieces(FlattenBoard1, NewPointsPlayer, SymbolPlayer, PointsPlayer1)``;
* Last and most importantly, if a move wins the game, it is given 1000 points, since it's obviously the best move in any situation.

The evaluation of the board also considers the amount of points related to the opponent: calling the predicate ``value(GameState, Player, Value)`` described above to evaluate the opponent's side of the board.
This algorithm allows that the best boards are the ones with the most amount of points for the player, and the less amount of points for the opponent.

## Computer Move - [input.pl](./src/input.pl) & [play.pl](./src/play.pl)
As specified, we implemented 2 levels of difficulty in the game: 'easy' and 'hard'.
The predicate ``choose_move(GameState, Player, Level, Move)`` handles all computer moves.
The third argument received by this predicate dictates its behaviour. This way, ``choose_move`` returns in Move the game state containing the move made by the computer in easy mode, for example.
* The easy mode is pretty straight forward: the computer generates all possible moves, using the ``valid_moves`` predicate and chooses a random element from that list (ListOfMoves), using ``choose(List, Elt)``;
* The hard mode is a bit more sofisticated: the computer evaluates all the possible boards (ListOfMoves), using the points system previously described. The evaluation of the boards is done by the predicate ``evaluateBoards(ListBoards, Player, NextPlayer, Max, BoardsSel, OutBoards)``, responsible for returning in OutBoards, a list containing the game states with the most amount of points. This predicate is called by ``findBestMove(NewBoard, ListBoards, Player, NextPlayer)``. After reveiving the list with the best moves, all we need to do is choose (randomly) a game state from that list.

## Conclusions

The development of this project was hard at first, since we did not have much knowledge about the Prolog programming language . However, during the weeks, we began to understand the language and its syntax better. It is safe to say that the development of this project was a big step in order to improve our understanding of Prolog.
As for bugs or other known issues in the final version of the game, we didn't find any.
There are some improvements that could have been made in the game, most specificly in the artificial intelligence of the game: in the final version, we could improve the evaluation predicate, so that it considers more moves ahead instead of just evaluating the current move, improving the quality of the moves made by the computer.

## Bibliography
* [SWI-Prolog](https://www.swi-prolog.org/);
* [SICStus Prolog Documentation](https://sicstus.sics.se/sicstus/docs/latest4/pdf/sicstus.pdf)
*  Moodle slides.
