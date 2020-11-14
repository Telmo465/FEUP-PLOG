:-consult('display.pl').

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

%responsible for replacing a cell in InitialMatrix
makeMove(InitialMatrix,R,C,Val,FinalMatrix):-
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

getSquarePiece(Column, Row, Content, GameState):-
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


