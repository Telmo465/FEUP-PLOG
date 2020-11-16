readMove(Row, Column, ValidRow, ValidCol, State):- %reads input from the user
	readRow(InputRow, Row),
	readColumn(InputCol, Col),
	(
		getSquarePiece(Col, Row, empty, State) ->
		(ValidRow is Row,
		ValidCol is Col
		);
		(
		write('Invalid position.\n'),
		readMove(MoveRow,MoveCol,ValidRow,ValidCol, State)	
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