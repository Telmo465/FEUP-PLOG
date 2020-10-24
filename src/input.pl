
readRow(Row, NewRow):-
	write('Row: '),
	read(Row),
	rowValid(Row, NewRow).
	
readColumn(Column, NewColumn):-
	write('Column: '),
	read(Column),
	columnValid(Column, NewColumn).
	

rowValid('A', NewRow):-
	NewRow = 1.

rowValid('B', NewRow):-
	NewRow = 2.

rowValid('C', NewRow):-
	NewRow = 3.

rowValid('D', NewRow):-
	NewRow = 4.

rowValid('E', NewRow):-
	NewRow = 5.

rowValid('F', NewRow):-
	NewRow = 6.

rowValid('G', NewRow):-
	NewRow = 7.

rowValid('H', NewRow):-
	NewRow = 8.


columnValid(1, NewColumn):-
	NewColumn = 1.
	
columnValid(2, NewColumn):-
	NewColumn = 2.
	
columnValid(3, NewColumn):-
	NewColumn = 3.
	
columnValid(4, NewColumn):-
	NewColumn = 4.
	
columnValid(5, NewColumn):-
	NewColumn = 5.
	
columnValid(6, NewColumn):-
	NewColumn = 6.
	
columnValid(7, NewColumn):-
	NewColumn = 7.
	
columnValid(8, NewColumn):-
	NewColumn = 8.
	
	






