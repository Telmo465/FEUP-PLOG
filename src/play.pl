:-consult('utils.pl').
:-dynamic(state/2).

play:-
	game_loop(X,Y).

%implements the main loop of the game
game_loop(Player1, Player2):-
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

	

initial(GameState):-
	initialBoard(GameState).
	
	
display_game(GameState, Player):-
	write('Current player: '),
	symbol(Player, Str),
	write(Str),nl,
	printBoard(GameState).


repeat.
repeat:-
	repeat.	



%reads input and makes the respective move on the board
playMove(Player, NextPlayer, State, NewState):-
	readMove(Row, Col, ValidRow, ValidCol, State), 
	symbol(Player, S),
	makeMove(State, ValidRow, ValidCol, S, NewState),
	%repulsion(TempState, NewState, ValidRow, ValidCol),

	(
		(Player =:= 1,
		NextPlayer is 2
		);

		(Player =:= 2,
			NextPlayer is 1
		)
	).


endGame:-
    winner(Player),
    write('3 in a row!\n'),
    write(Player),
    write(' Wins the Game!').


checkAll(Board,Piece):-
	flatten(Board, BoardList),
	verifyPieces(BoardList, 1, Piece, 8);
    checkAllRowsCols(7,7,Board,Piece).

threeInRowLeftDiagonal(0,_,_,_,_).

threeInRowLeftDiagonal(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCol is Col-1,
	NewCounter is Counter-1,
    threeInRowLeftDiagonal(NewCounter,NewRow,NewCol,Board,Piece),
    !.

threeInRowRightDiagonal(0,_,_,_,_).

threeInRowRightDiagonal(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCol is Col+1,
    NewCounter is Counter-1,
    threeInRowRightDiagonal(NewCounter,NewRow,NewCol,Board,Piece),
    !.

threeInRowColumn(0,_,_,_,_).

threeInRowColumn(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
	NewCounter is Counter-1,
    threeInRowColumn(NewCounter,NewRow,Col,Board,Piece),
    !.

threeInRowRow(0,_,_,_,_).

threeInRowRow(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewCol is Col-1,
	NewCounter is Counter-1,
    threeInRowRow(NewCounter,Row,NewCol,Board,Piece),
    !.

checkAllRowsCols(Row,Col,Board,Piece):-
    Row > 0,
	Col > 0,
	threeInRowLeftDiagonal(3,Row,Col,Board,Piece);
	threeInRowRightDiagonal(3,Row,Col,Board,Piece);
	threeInRowColumn(3,Row,Col,Board,Piece);
    threeInRowRow(3,Row,Col,Board,Piece).

checkAllRowsCols(Row,Col,Board,Piece):-
    Row > 0,
    Col > 0,
	NextRow is Row-1,
    checkAllRowsCols(NextRow,Col,Board,Piece).

checkAllRowsCols(Row,Col,Board,Piece):-
    Row > 0,
    Col > 0,
	NextCol is Col-1,
    checkAllRowsCols(Row,NextCol,Board,Piece).


verifyPieces(_, _, _, 0).
verifyPieces(BoardList, Index, Piece, Counter):-
	Index < 37,
	(
		(nth1(Index, BoardList, Piece) -> NewCounter is Counter-1;
		NewCounter is Counter)	
	),
	NewIndex is Index+1,
	verifyPieces(BoardList, NewIndex, Piece, NewCounter).

checkTopLeftPiece(Board, NewBoard, Row, Column):-
	Column > 2,
	Row > 2,
	AuxCol is Column-1,
	AuxRow is Row-1,
	NextAuxRow is Row-2,
	%write(NextAuxRow),nl,
	NextAuxCol is Column-2,
	%write(NextAuxCol),nl,
	getSquarePiece(AuxCol, AuxRow, Piece, Board),
	getSquarePiece(NextAuxCol,NextAuxRow, NextPiece, Board),
	write(Piece),nl,
	write(NextPiece),nl.
	
	
	


repulsion(Board, NewBoard, Row, Column):-
	once(checkTopLeftPiece(Board, NewBoard, Row, Column)),
	!.



checkWinner(Board):-
	retract(winner(Player)),
    assert(winner(1)),
    checkAll(Board,black);
    assert(winner(2)),
    checkAll(Board,red).

