
  
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
 - 
	**Material**  
		- Board 6 * 6;  
		- 16 Markers (8 of each color);
			
 - [source](https://boardgamegeek.com/boardgame/295449/gekitai)
 - [board](https://s3.amazonaws.com/geekdo-files.com/bgg260973?response-content-disposition=inline%3B%20filename%3D%22Gekitai_Generic_Board.pdf%22&response-content-type=application%2Fpdf&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJYFNCT7FKCE4O6TA%2F20201101%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201101T162309Z&X-Amz-SignedHeaders=host&X-Amz-Expires=120&X-Amz-Signature=5658ba23308bf6e840e5040dc421f7ac9c108a34c7f8392e0a40ae4e60769bb1)
 - [rules](https://s3.amazonaws.com/geekdo-files.com/bgg260437?response-content-disposition=inline%3B%20filename%3D%22Gekitai_Rules.pdf%22&response-content-type=application%2Fpdf&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJYFNCT7FKCE4O6TA%2F20201101%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201101T160235Z&X-Amz-SignedHeaders=host&X-Amz-Expires=120&X-Amz-Signature=9e06a7d642935f212181bfdeb63632a8fa21ebc2070973ab2fb2ae625009a0da)

----
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
	- Call the "playMove" predicate, responsible for replacing empty cells for "X" or "0" cells, depending on the player;
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


## Notes

* In order to execute the program, please follow the next steps:
	- load src/gekitai.pl in SICStus;
	- type "play." to start the game;
		-  The row inputs are given as numbers (1 - 6),
		- The column inputs are given as letters ('A' - 'F');
	- We implemented the following predicates to display possible boards that might occur during a game.
		- type "initial." to display the initial state of the board;
		- type "intermediate." to display the intermediate state of the board;
		- type "final." to display the final state of the board;
 