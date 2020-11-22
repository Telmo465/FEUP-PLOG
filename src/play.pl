
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

%game loop --> Human x PC
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

choose([], []).
choose(List, Elt) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elt).

getPosition(InRow, InCol, OutRow, OutCol):-
	OutCol is InCol,
	OutRow is InRow.

getPosition(InRow, InCol, OutRow, OutCol):-
	InCol < 7,
	InRow < 7,
	NewCol is InCol + 1,
	getPosition(InRow, NewCol, OutRow, OutCol).

getPosition(InRow, InCol, OutRow, OutCol):-
	InCol >= 7,
	InRow < 7,
	NewCol is 1,
	NewRow is InRow + 1,
	getPosition(NewRow, NewCol, OutRow, OutCol).

validPosition(Player, Row, Col, Board, NewBoard):-
	getSquarePiece(Col, Row, empty, Board),
	symbol(Player, S),
	makeMove(Board, Row, Col, S, NewBoard1),
	repulsion(NewBoard1, NewBoard, Row, Col),
	!.



move(Player, Board, NewBoard):-
	getPosition(1,1,  OutRow, OutCol),
	validPosition(Player, OutRow, OutCol, Board, NewBoard).


	
evaluateWinningBoards([], NewListBoards, Player, OutBoards):-
	OutBoards = NewListBoards,
	write(OutBoards).
	

evaluateWinningBoards([H|ListBoards], NewListBoards, Player, OutBoards):-
	symbol(Player, S),
	(
		(checkthree(H, S)) -> (append([H], NewListBoards, NextListBoards), evaluateWinningBoards(ListBoards, NextListBoards, Player, OutBoards)); evaluateWinningBoards(ListBoards, NewListBoards, Player, OutBoards)
	).
	



evaluateNotLosingBoards([], NewListBoards, _, OutBoards):-
	append([], NewListBoards, OutBoards).
	

evaluateNotLosingBoards([H|ListBoards], NewListBoards, Player, OutBoards):-
	symbol(Player, S),
	(
		(checkthree(H, S)) -> (evaluateNotLosingBoards(ListBoards, NewListBoards, Player)) ; (append([H], NewListBoards, NextListBoards) ,evaluateNotLosingBoards(ListBoards, NextListBoards, Player))
	).




is_empty(List):- List = []. %checks if list is empty

isWinningMove(Board, Points, NewPoints, Player):-
	symbol(Player, S),
	checkthree(Board, S),
	write('WINNING MOVE FOUND!\n'),
	NewPoints is 1000.

isWinningMove(Board, Points, NewPoints, Player):-
	NewPoints = Points.


find2inrowRow(Board, Player,6, 5, Points, OutPoints):-
	OutPoints = Points.


find2inrowRow(Board, Player, Row, Col, Points, OutPoints):-
	Row < 7,
	Col < 6,
	symbol(Player, S),
	NewRow is Row+1,
	NewCol is Col+1,
	getSquarePiece(Col, Row, S1, Board),
	getSquarePiece(NewCol, Row, S2, Board),
	((S1 == S, S2 == S) -> (NewPoints is Points+40, find2inrowRow(Board, Player, Row, NewCol, NewPoints, OutPoints)) ; find2inrowRow(Board, Player, Row, NewCol, Points, OutPoints)).


find2inrowRow(Board, Player, Row, Col, Points, OutPoints):- %	End of row
	Row < 7,
	Col >= 6,
	NewRow is Row+1,
	find2inrowRow(Board, Player, NewRow, 1, Points, OutPoints).



find2inrowCol(Board, Player,5, 6, Points, OutPoints):-
	OutPoints = Points.


find2inrowCol(Board, Player, Row, Col, Points, OutPoints):-
	Row < 6,
	Col < 7,
	symbol(Player, S),
	NewRow is Row+1,
	NewCol is Col+1,
	getSquarePiece(Col, Row, S1, Board),
	getSquarePiece(Col, NewRow, S2, Board),
	((S1 == S, S2 == S) -> (NewPoints is Points+40, find2inrowCol(Board, Player, Row, NewCol, NewPoints, OutPoints)) ; find2inrowCol(Board, Player, Row, NewCol, Points, OutPoints)).


find2inrowCol(Board, Player, Row, Col, Points, OutPoints):-
	Row < 6,
	Col >= 7,
	NewRow is Row+1,
	find2inrowCol(Board, Player, NewRow, 1, Points, OutPoints).


find2inrowRightDiagonal(Board, Player, 5, 6, Points, OutPoints):-
	OutPoints = Points.


find2inrowRightDiagonal(Board, Player, Row, Col, Points, OutPoints):-
	Row < 6,
	Col < 6,
	NewRow is Row + 1,
	NewCol is Col + 1,
	symbol(Player, S),
	getSquarePiece(Col, Row, S1 ,Board),
	getSquarePiece(NewCol, NewRow, S2, Board),
	((S1 == S, S2 == S) -> (NewPoints is Points+40, find2inrowRightDiagonal(Board, Player, Row, NewCol, NewPoints, OutPoints)) ; find2inrowRightDiagonal(Board, Player, Row, NewCol, Points, OutPoints)).



find2inrowRightDiagonal(Board, Player, Row, Col, Points, OutPoints):-
	Col >= 6,
	Row < 6,
	NewRow is Row + 1,
	find2inrowRightDiagonal(Board, Player, NewRow, 1, Points, OutPoints).


find2inrowLeftDiagonal(Board, Player, 2, 6, Points, OutPoints):-
	OutPoints = Points.


find2inrowLeftDiagonal(Board, Player, Row, Col, Points, OutPoints):-
	Col < 6,
	Row > 1,
	NewRow is Row - 1,
	NewCol is Col + 1,
	symbol(Player, S),
	getSquarePiece(Col, Row, S1 ,Board),
	getSquarePiece(NewCol, NewRow, S2, Board),
	((S1 == S, S2 == S) -> (NewPoints is Points+40, find2inrowLeftDiagonal(Board, Player, Row, NewCol, NewPoints, OutPoints)) ; find2inrowLeftDiagonal(Board, Player, Row, NewCol, Points, OutPoints)).


find2inrowLeftDiagonal(Board, Player, Row, Col, Points, OutPoints):-
	Col >= 6,
	Row > 1,
	NewRow is Row-1,
	find2inrowLeftDiagonal(Board, Player, NewRow, 1, Points, OutPoints).



findNumPieces([], Points, _, OutPoints):-
	OutPoints = Points.

findNumPieces([H|FlattenBoard], Points, Symbol, OutPoints):-
	(
		(H = Symbol -> (NewPoints is Points+2, findNumPieces(FlattenBoard, NewPoints, Symbol, OutPoints))) ;  findNumPieces(FlattenBoard, Points, Symbol, OutPoints)
	).


evaluateBoards([], _, _, _, BoardSel, OutBoards):-
	OutBoards = BoardSel.


evaluateBoards([H|ListBoards], Player, NextPlayer, Max, BoardsSel, OutBoards):-
	%check for winning moves
	AuxBoard = H,
	symbol(Player, SymbolPlayer),
	symbol(NextPlayer, SymbolOpponent),

	find2inrowCol(H, Player, 1,1,0, PointsPlayer),
	find2inrowCol(H, NextPlayer, 1,1,0, PointsOpponent),
	find2inrowRow(H, Player, 1,1, PointsPlayer, TempPointsPlayer),
	find2inrowRow(H, NextPlayer, 1,1, PointsOpponent, TempPointsOpponent),

	find2inrowRightDiagonal(H, Player, 1,1, TempPointsPlayer ,TempPointsPlayer2),
	find2inrowRightDiagonal(H, NextPlayer, 1,1, TempPointsOpponent, TempPointsOpponent2),

	find2inrowLeftDiagonal(H, Player, 6, 1, TempPointsPlayer2, NewPointsPlayer),
	find2inrowLeftDiagonal(H, NextPlayer, 6, 1, TempPointsOpponent2, NewPointsOpponent),

	flatten(H, FlattenBoard1),
	FlattenBoard2 = FlattenBoard1,
	findNumPieces(FlattenBoard1, NewPointsPlayer, SymbolPlayer, PointsPlayer1),
	findNumPieces(FlattenBoard2, NewPointsOpponent, SymbolOpponent, PointsOpponent1),

	isWinningMove(AuxBoard, PointsPlayer1, PointsPlayer2, Player),
	isWinningMove(AuxBoard, PointsOpponent1, PointsOpponent2, NextPlayer),


	Balance is PointsPlayer2 - 3*PointsOpponent2,
	
	/*
	(
		(Balance > Max) -> (evaluateBoards(ListBoards, Player, NextPlayer, Balance, H, OutBoard)) ; evaluateBoards(ListBoards, Player, NextPlayer, Max ,BoardSel, OutBoard)
	).*/
	listBestMoves(Max, Balance, H, BoardsSel, NewListMoves, NewMax),
	%write(NewListMoves),
	evaluateBoards(ListBoards, Player, NextPlayer, NewMax, NewListMoves, OutBoards).



listBestMoves(CurrentMax, Balance, Board ,ListMoves, NewListMoves, NewMax):-
	Balance > CurrentMax,
	NewMax is Balance,
	NewListMoves = [Board]. %resets previous board

listBestMoves(CurrentMax, Balance, Board , ListMoves, NewListMoves, NewMax):-
	%write([Balance, CurrentMax]),
	%write('cheguei aqui.\n'),
	Balance =:= CurrentMax,
	NewMax = Balance,	
	append([Board], ListMoves, NewListMoves).


listBestMoves(CurrentMax, Balance, Board ,ListMoves, NewListMoves, NewMax):- %	predicate never fails
	%write([Balance, CurrentMax]),
	NewMax = CurrentMax,
	NewListMoves = ListMoves.
	
	

findBestMove(NewBoard, ListBoards, Player, NextPlayer):- 		%evaluates all moves in ListBoards matrix
	AllBoards = ListBoards,
	evaluateBoards(ListBoards, Player, NextPlayer, -2000, CurrentBoard, OutBoardSel),
	%iteratePointsMatrix(NewPointsMatrix, -20000, AllBoards, BoardSelected, OutBoardSel),
	%write(OutBoardSel),
	choose(OutBoardSel, NewBoard),
	!.
	%NewBoard = OutBoardSel.


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
	/*AllBoards = ListBoards,
	evaluateWinningBoards(ListBoards, [], Player, NewListBoards),
	(is_empty(NewListBoards) -> (choose(AllBoards, NewBoard)) ; (choose(NewListBoards, NewBoard))).*/
	findBestMove(NewBoard, ListBoards, Player, NextPlayer),
	!.
	%write(NewBoard).
	




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
	checkthree(Board,'Black');
    checkthree(Board,'Red').

endGame:-
	retract(winner(Player)),
    write('\n\n ________________________________________________________________________ \n'),
    nl,
    write('                                3 in a row!\n'),
    symbol(Player, S),
    nl,
    write('                            '),                                   
    write(S),
    write(' Wins the Game!\n'),
    write(' ________________________________________________________________________\n').
