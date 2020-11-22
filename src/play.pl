
play:-
	main_menu.

initial(GameState):-
	initialBoard(GameState).

display_game(GameState, Player):-
	write('Current player: '),
	symbol(Player, Str),
	write(Str),nl,
	printBoard(GameState).


%game loop --> PC x PC
game_loop('BOT1', 'BOT1'):- %implements the main loop of the game
	initial(GameState),
	assert(state(1, GameState)),
	repeat,
		retract(state(Player, Board)),
		generatePCmove(Player, NextPlayer ,Board, NewBoard), %replaces an empty cell with the respective player piece
		assert(state(NextPlayer, NewBoard)),
		once(display_game(NewBoard, NextPlayer)), % displays the current state of the board
		checkWinner(NewBoard), % checks if the game has ended
	retract(state(_,_)),
	endGame.

%game loop --> Human x PC Hard
game_loop('Player', 'BOT1'):- %implements the main loop of the game
	initial(GameState),
	assert(state(1, GameState)),
	display_game(GameState, 1), 
	repeat,
		retract(state(Player, Board)),
		(
			((Player =:= 1) -> once(playMove(Player, NextPlayer ,Board, NewBoard))) ; generatePCmove(Player, NextPlayer ,Board, NewBoard)
		),
		%generatePCmove(Player, NextPlayer ,Board, NewBoard), %replaces an empty cell with the respective player piece
		assert(state(NextPlayer, NewBoard)),
		once(display_game(NewBoard, NextPlayer)), % displays the current state of the board
		checkWinner(NewBoard), % checks if the game has ended
	retract(state(_,_)),
	endGame.

%game loop --> Human x PC Easy
game_loop('Player', 'BOT2'):- %implements the main loop of the game
	initial(GameState),
	assert(state(1, GameState)),
	display_game(GameState, 1), 
	repeat,
		retract(state(Player, Board)),
		(
			((Player =:= 1) -> once(playMove(Player, NextPlayer ,Board, NewBoard))) ; generatePCmoveeasy(Player, NextPlayer ,Board, NewBoard)
		),
		assert(state(NextPlayer, NewBoard)),
		once(display_game(NewBoard, NextPlayer)), % displays the current state of the board
		checkWinner(NewBoard), % checks if the game has ended
	retract(state(_,_)),
	endGame.

%game loop --> Human x Human
game_loop(Player1, Player2):- %implements the main loop of the game
	initial(GameState),
	assert(move(1,Player1)),
    assert(move(2,Player2)),
    assert(state(1,GameState)), %asserts that the player 1 plays first
	display_game(GameState, 1), 
	repeat,
		retract(state(Player, Board)),
		once(playMove(Player, NextPlayer ,Board, NewBoard)), %replaces an empty cell with the respective player piece
		assert(state(NextPlayer, NewBoard)),
		once(display_game(NewBoard, NextPlayer)), % displays the current state of the board
		checkWinner(NewBoard), % checks if the game has ended
	retract(state(_,_)),
	endGame.

repeat.
repeat:-
	repeat.	


generatePCmove(Player ,NextPlayer, Board, NewBoard):- 
	findall(UpdatedBoard, move(Player ,Board, UpdatedBoard), ListBoards),
	(
		(Player =:= 1,
		NextPlayer is 2
		);

		(Player =:= 2,
			NextPlayer is 1
		)
	),	

	findBestMove(NewBoard, ListBoards, Player, NextPlayer),
	!.

generatePCmoveeasy(Player ,NextPlayer, Board, NewBoard):- 
	findall(UpdatedBoard, move(Player ,Board, UpdatedBoard), ListBoards),
	(
		(Player =:= 1,
		NextPlayer is 2
		);

		(Player =:= 2,
			NextPlayer is 1
		)
	),	

	choose(ListBoards, NewBoard).
	

playMove(Player, NextPlayer, State, NewState):- 	%reads input and makes the respective move on the board
	readMove(Row, Col, ValidRow, ValidCol, State), 
	symbol(Player, S),
	makeMove(State, ValidRow, ValidCol, S, TempState),
	once(repulsion(TempState, NewState, ValidRow, ValidCol)),

	(
		(Player =:= 1,
		NextPlayer is 2
		);

		(Player =:= 2,
			NextPlayer is 1
		)
	).

checkthree(Board,Piece):- % Three in a row
	flatten(Board, BoardList),
	verifyPieces(BoardList, 1, Piece, 8);
    (checkAllRowsCols(7,7,Board,Piece),assert(winner(Piece))).

repulsion(Board, NewBoard, Row, Column):- % Repulsions
	checkTopLeftPiece(Board, TempBoard1, Row, Column),
	checkTopPiece(TempBoard1, TempBoard2, Row, Column),
	checkTopRightPiece(TempBoard2, TempBoard3, Row, Column),
	checkRightPiece(TempBoard3, TempBoard4, Row, Column),
	checkBottomRightPiece(TempBoard4, TempBoard5, Row, Column),
	checkBottomPiece(TempBoard5, TempBoard6, Row, Column),
	checkBottomLeftPiece(TempBoard6, TempBoard7, Row, Column),
	checkLeftPiece(TempBoard7, NewBoard, Row, Column),
	!.

checkWinner(Board):-
	checkthree(Board,'Black');
    checkthree(Board,'Red').

endGame:-
	retract(winner(Player)),
    write('\n\n ________________________________________________________________________ \n'),
    nl,
	write('                                3 in a row!\n'),
	symbol(Player,S),
    nl,
    write('                            '),                                   
    write(S),
    write(' Wins the Game!\n'),
    write(' ________________________________________________________________________\n').
