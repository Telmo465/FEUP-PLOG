:-consult('display.pl').
:-consult('input.pl').

readMove(Row, Column):-
	readRow(Row, NewRow),
	readColumn(Column, NewColumn),
	makeMove(InitialMatrix, NewRow, NewColumn, black, FinalMatrix).


makeMove(InitialMatrix,R,C,Val,FinalMatrix):-
	initialBoard(InitialMatrix),
	printBoard(InitialMatrix),
	playRow(R,InitialMatrix,C,Val,FinalMatrix),
	printBoard(FinalMatrix).
	
playRow(1,[Row|RestRow],C,Val,[NewRow|RestRow]):-
	playColumn(C,Row,Val,NewRow).
	
playRow(NRow,[Row|RestRow],C,Val,[Row|NewRow]):-
	NRow > 1,
	N is NRow-1,
	playRow(N,RestRow,C,Val,NewRow).
	
playColumn(1,[_|RestColumn],Val,[Val|RestColumn]).
playColumn(NColumn,[P|RestColumn],Val,[P|NewColumn]):-
	NColumn > 1,
	N is NColumn-1,
	playColumn(N,RestColumn,Val,NewColumn).

