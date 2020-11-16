
play:-
	main_menu.

initial(GameState):-
	initialBoard(GameState).

display_game(GameState, Player):-
	write('Current player: '),
	symbol(Player, Str),
	write(Str),nl,
	printBoard(GameState).

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
	endGame.

repeat.
repeat:-
	repeat.	

playMove(Player, NextPlayer, State, NewState):- %reads input and makes the respective move on the board
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
    checkAllRowsCols(7,7,Board,Piece).

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
	retract(winner(Player)),
    assert(winner(1)),
    checkthree(Board,'Black');
    assert(winner(2)),
    checkthree(Board,'Red').

endGame:-
    winner(Player),
    write('\n\n ________________________________________________________________________ \n'),
    nl,
    write('                                3 in a row!\n'),
    symbol(Player, S),
    nl,
    write('                            '),                                   
    write(S),
    write(' Wins the Game!\n'),
    write(' ________________________________________________________________________\n').
