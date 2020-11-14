:-consult('display.pl').

readMove(Row, Column, ValidRow, ValidCol):- %reads input from the user
	readRow(Row, ValidRow),
	readColumn(Column, ValidCol).

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

getSquarePiece(Column, Row, Content, GameState) :-
    CalcRow is Row-1,
    CalcColumn is Column-1,
    nth0(CalcRow, GameState, SelRow),
    nth0(CalcColumn, SelRow, Content).