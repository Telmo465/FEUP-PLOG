readMove(Row, _, ValidRow, ValidCol, State):- %reads input from the user
	readRow(_, Row),
	readColumn(_, Col),
	(
		getSquarePiece(Col, Row, empty, State) ->
		(ValidRow is Row,
		ValidCol is Col
		);
		(
		write('Invalid position.\n'),
		readMove(_,_,ValidRow,ValidCol, State)	
		)
	).

makeMove(InitialMatrix,R,C,Val,FinalMatrix):- %responsible for replacing a cell in InitialMatrix
	playRow(R,InitialMatrix,C,Val,FinalMatrix).

	
playRow(1,[Row|RestRow],C,Val,[NewRow|RestRow]):- %base case
	playColumn(C,Row,Val,NewRow).
	
playRow(NRow,[Row|RestRow],C,Val,[Row|NewRow]):- %calls playRow recursively until it finds the row
	NRow > 1,
	N is NRow-1,
	playRow(N,RestRow,C,Val,NewRow).
	
playColumn(1,[_|RestColumn],Val,[Val|RestColumn]).

playColumn(NColumn,[P|RestColumn],Val,[P|NewColumn]):- %calls playColumn recursively until it finds the column
	NColumn > 1,
	N is NColumn-1,
	playColumn(N,RestColumn,Val,NewColumn).

getSquarePiece(Column, Row, Content, GameState):- %get the content of a cell of the board
	Row > 0,
	Column > 0,
    nth1(Row, GameState, SelRow),
	nth1(Column, SelRow, Content).


%copied from SWI prolog
flatten([], []) :- !. %transforms matrix into list
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).



verifyPieces(_, _, _, 0).  % verify if a player have the 8 pieces in the board
verifyPieces(BoardList, Index, Piece, Counter):-
	Index < 37,
	(
		(nth1(Index, BoardList, Piece) -> NewCounter is Counter-1;
		NewCounter is Counter)	
	),
	NewIndex is Index+1,
	verifyPieces(BoardList, NewIndex, Piece, NewCounter).

%---------------------- Three in the row----------------------------%

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

%--------------------------Repulsions-------------------------------%

checkTopLeftPiece(Board,NewBoard,1,_):-
	NewBoard = Board.


checkTopLeftPiece(Board,NewBoard,_,1):-
	NewBoard = Board.


checkTopLeftPiece(Board, NewBoard, Row, Column):-
	Column > 2,
	Row > 2,
	AuxCol is Column-1,
	AuxRow is Row-1,
	NextAuxRow is Row-2,
	NextAuxCol is Column-2,
	getSquarePiece(AuxCol, AuxRow, Piece, Board),
	getSquarePiece(NextAuxCol,NextAuxRow, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, NextAuxRow, NextAuxCol, Piece, TempBoard), makeMove(TempBoard, AuxRow, AuxCol, 'empty', NewBoard))) ; NewBoard = Board
	).
	
checkTopLeftPiece(Board, NewBoard, Row, Column):-
	Column > 1,
	Row > 1,
	AuxCol is Column-1,
	AuxRow is Row-1,
	makeMove(Board, AuxRow, AuxCol, 'empty', NewBoard).


checkTopPiece(Board, NewBoard, 1, _):-
	NewBoard = Board.

checkTopPiece(Board, NewBoard, Row, Column):-
	Row > 2,
	AuxRow is Row - 1,
	getSquarePiece(Column, AuxRow, Piece, Board),
	NextAuxRow is Row - 2,
	getSquarePiece(Column,NextAuxRow, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, NextAuxRow, Column, Piece, TempBoard), makeMove(TempBoard, AuxRow, Column, 'empty', NewBoard))) ; NewBoard = Board
	).

checkTopPiece(Board, NewBoard, Row, Column):-
	Row > 1,
	AuxRow is Row-1,
	makeMove(Board, AuxRow, Column, 'empty', NewBoard).


checkTopRightPiece(Board, NewBoard, 1, _):-
	NewBoard = Board.


checkTopRightPiece(Board, NewBoard, _, 6):-
	NewBoard = Board.

checkTopRightPiece(Board, NewBoard, Row, Column):-
	Column < 5,
	Row > 2,
	AuxCol is Column+1,
	AuxRow is Row-1,
	NextAuxRow is Row-2,
	NextAuxCol is Column+2,
	getSquarePiece(AuxCol, AuxRow, Piece, Board),
	getSquarePiece(NextAuxCol,NextAuxRow, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, NextAuxRow, NextAuxCol, Piece, TempBoard), makeMove(TempBoard, AuxRow, AuxCol, 'empty', NewBoard))) ; NewBoard = Board
	).

checkTopRightPiece(Board, NewBoard, Row, Column):-
	Column < 6,
	Row > 1,
	AuxCol is Column + 1,
	AuxRow is Row - 1,
	makeMove(Board, AuxRow, AuxCol, 'empty', NewBoard).

checkRightPiece(Board, NewBoard, _, 6):-
	NewBoard = Board.

checkRightPiece(Board, NewBoard, Row, Column):-
	Column < 5,
	AuxCol is Column + 1,
	getSquarePiece(AuxCol, Row, Piece, Board),
	NextAuxCol is Column + 2,
	getSquarePiece(NextAuxCol,Row, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, Row, NextAuxCol, Piece, TempBoard), makeMove(TempBoard, Row, AuxCol, 'empty', NewBoard))) ; NewBoard = Board
	).

checkRightPiece(Board, NewBoard, Row, Column):-
	Column < 6,
	AuxCol is Column + 1,
	makeMove(Board, Row, AuxCol, 'empty', NewBoard).

checkBottomRightPiece(Board, NewBoard, 6, _):-
	NewBoard = Board.

checkBottomRightPiece(Board, NewBoard, _, 6):-
	NewBoard = Board.

checkBottomRightPiece(Board, NewBoard, Row, Column):-
	Column < 5,
	Row < 5,
	AuxCol is Column+1,
	AuxRow is Row+1,
	NextAuxRow is Row+2,
	NextAuxCol is Column+2,
	getSquarePiece(AuxCol, AuxRow, Piece, Board),
	getSquarePiece(NextAuxCol,NextAuxRow, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, NextAuxRow, NextAuxCol, Piece, TempBoard), makeMove(TempBoard, AuxRow, AuxCol, 'empty', NewBoard))) ; NewBoard = Board
	).

checkBottomRightPiece(Board, NewBoard, Row, Column):-
	Column < 6,
	Row < 6,
	AuxCol is Column + 1,
	AuxRow is Row + 1,
	makeMove(Board, AuxRow, AuxCol, 'empty', NewBoard).

checkBottomPiece(Board, NewBoard, 6, _):-
	NewBoard = Board.

checkBottomPiece(Board, NewBoard, Row, Column):-
	Row < 5,
	AuxRow is Row + 1,
	getSquarePiece(Column, AuxRow, Piece, Board),
	NextAuxRow is Row + 2,
	getSquarePiece(Column,NextAuxRow, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, NextAuxRow, Column, Piece, TempBoard), makeMove(TempBoard, AuxRow, Column, 'empty', NewBoard))) ; NewBoard = Board
	).

checkBottomPiece(Board, NewBoard, Row, Column):-
	Row < 6,
	AuxRow is Row + 1,
	makeMove(Board, AuxRow, Column, 'empty', NewBoard).

checkBottomLeftPiece(Board, NewBoard, 6, _):-
	NewBoard = Board.

checkBottomLeftPiece(Board, NewBoard, _, 1):-
	NewBoard = Board.

checkBottomLeftPiece(Board, NewBoard, Row, Column):-
	Column > 2,
	Row < 5,
	AuxCol is Column-1,
	AuxRow is Row+1,
	NextAuxRow is Row+2,
	NextAuxCol is Column-2,
	getSquarePiece(AuxCol, AuxRow, Piece, Board),
	getSquarePiece(NextAuxCol,NextAuxRow, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, NextAuxRow, NextAuxCol, Piece, TempBoard), makeMove(TempBoard, AuxRow, AuxCol, 'empty', NewBoard))) ; NewBoard = Board
	).

checkBottomLeftPiece(Board, NewBoard, Row, Column):-
	Column > 1,
	Row < 6,
	AuxCol is Column - 1,
	AuxRow is Row + 1,
	makeMove(Board, AuxRow, AuxCol, 'empty', NewBoard).

checkLeftPiece(Board, NewBoard, _, 1):-
	NewBoard = Board.

checkLeftPiece(Board, NewBoard, Row, Column):-
	Column > 2,
	AuxCol is Column - 1,
	getSquarePiece(AuxCol, Row, Piece, Board),
	NextAuxCol is Column - 2,
	getSquarePiece(NextAuxCol,Row, NextPiece, Board),
	(
		((Piece \= 'empty', NextPiece == 'empty') -> (makeMove(Board, Row, NextAuxCol, Piece, TempBoard), makeMove(TempBoard, Row, AuxCol, 'empty', NewBoard))) ; NewBoard = Board
	).

checkLeftPiece(Board, NewBoard, Row, Column):-
	Column > 1,
	AuxCol is Column - 1,
	makeMove(Board, Row, AuxCol, 'empty', NewBoard).

%---------------------------------inteligencia artificial--------------------

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

gen_move(Player, Board, NewBoard):-
	getPosition(1,1, OutRow, OutCol),
	validPosition(Player, OutRow, OutCol, Board, NewBoard).


is_empty(List):- List = []. %checks if list is empty

isWinningMove(Board, _, NewPoints, Player):-
	symbol(Player, S),
	checkWin(Board, S),
	retract(winner(_)),
	NewPoints is 1000.

isWinningMove(_, Points, NewPoints, _):-
	NewPoints = Points.

%--------------------------------check 2 in a row-----------------------

find2inrowRow(_, _,6, 5, Points, OutPoints):-
	OutPoints = Points.


find2inrowRow(Board, Player, Row, Col, Points, OutPoints):-
	Row < 7,
	Col < 6,
	symbol(Player, S),
	NewCol is Col+1,
	getSquarePiece(Col, Row, S1, Board),
	getSquarePiece(NewCol, Row, S2, Board),
	((S1 == S, S2 == S) -> (NewPoints is Points+40, find2inrowRow(Board, Player, Row, NewCol, NewPoints, OutPoints)) ; find2inrowRow(Board, Player, Row, NewCol, Points, OutPoints)).


find2inrowRow(Board, Player, Row, Col, Points, OutPoints):- %	End of row
	Row < 7,
	Col >= 6,
	NewRow is Row+1,
	find2inrowRow(Board, Player, NewRow, 1, Points, OutPoints).



find2inrowCol(_, _,5, 6, Points, OutPoints):-
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


find2inrowRightDiagonal(_, _, 5, 6, Points, OutPoints):-
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


find2inrowLeftDiagonal(_, _, 2, 6, Points, OutPoints):-
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


%------------point system----------------------------------
findNumPieces([], Points, _, OutPoints):-
	OutPoints = Points.

findNumPieces([H|FlattenBoard], Points, Symbol, OutPoints):-
	(
		(H = Symbol -> (NewPoints is Points+2, findNumPieces(FlattenBoard, NewPoints, Symbol, OutPoints))) ;  findNumPieces(FlattenBoard, Points, Symbol, OutPoints)
	).


value(GameState, Player, Value):-
	AuxBoard = GameState,
	symbol(Player, SymbolPlayer),
	find2inrowCol(GameState, Player, 1,1,0, PointsPlayer),
	find2inrowRow(GameState, Player, 1,1, PointsPlayer, TempPointsPlayer),
	find2inrowRightDiagonal(GameState, Player, 1,1, TempPointsPlayer ,TempPointsPlayer2),
	find2inrowLeftDiagonal(GameState, Player, 6, 1, TempPointsPlayer2, NewPointsPlayer),
	flatten(GameState, FlattenBoard1),
	findNumPieces(FlattenBoard1, NewPointsPlayer, SymbolPlayer, PointsPlayer1),
	isWinningMove(AuxBoard, PointsPlayer1, Value, Player).


evaluateBoards([], _, _, _, BoardSel, OutBoards):-
	OutBoards = BoardSel.


evaluateBoards([H|ListBoards], Player, NextPlayer, Max, BoardsSel, OutBoards):-
	%check for winning moves
	value(H, Player, PointsPlayer),
	value(H, NextPlayer, PointsOpponent),

	Balance is PointsPlayer - 3*PointsOpponent,
	
	listBestMoves(Max, Balance, H, BoardsSel, NewListMoves, NewMax),
	evaluateBoards(ListBoards, Player, NextPlayer, NewMax, NewListMoves, OutBoards).


listBestMoves(CurrentMax, Balance, Board ,_, NewListMoves, NewMax):-
	Balance > CurrentMax,
	NewMax is Balance,
	NewListMoves = [Board]. %resets previous board

listBestMoves(CurrentMax, Balance, Board , ListMoves, NewListMoves, NewMax):-
	Balance =:= CurrentMax,
	NewMax = Balance,	
	append([Board], ListMoves, NewListMoves).


listBestMoves(CurrentMax, _, _ ,ListMoves, NewListMoves, NewMax):- %	predicate never fails
	NewMax = CurrentMax,
	NewListMoves = ListMoves.
	
	
findBestMove(NewBoard, ListBoards, Player, NextPlayer):- 		%evaluates all moves in ListBoards matrix
	evaluateBoards(ListBoards, Player, NextPlayer, -2000, _, OutBoardSel),
	choose(OutBoardSel, NewBoard),
	!.
