
readRow(Row, NewRow):-
	write('Row: '),
	read(Row),
	rowValid(Row, NewRow).
	
readColumn(Column, NewColumn):-
	write('Column:'),
	read(Column),
	columnValid(Column, NewColumn).
	

rowValid(1, NewRow):-
	NewRow = 1.

rowValid(2, NewRow):-
	NewRow = 2.

rowValid(3, NewRow):-
	NewRow = 3.

rowValid(4, NewRow):-
	NewRow = 4.

rowValid(5, NewRow):-
	NewRow = 5.

rowValid(6, NewRow):-
	NewRow = 6.

rowValid(7, NewRow):-
	NewRow = 7.

rowValid(8, NewRow):-
	NewRow = 8.


columnValid('A', NewColumn):-
	NewColumn = 1.
columnValid(a, NewColumn):-
	NewColumn = 1.
	
columnValid('B', NewColumn):-
	NewColumn = 2.
columnValid(b , NewColumn):-
	NewColumn = 2.
	
columnValid('C', NewColumn):-
	NewColumn = 3.
columnValid(c, NewColumn):-
	NewColumn = 3.
	
columnValid('D', NewColumn):-
	NewColumn = 4.
columnValid(d, NewColumn):-
	NewColumn = 4.
	
columnValid('E', NewColumn):-
	NewColumn = 5.
columnValid(e, NewColumn):-
	NewColumn = 5.
	
columnValid('F', NewColumn):-
	NewColumn = 6.
columnValid(f, NewColumn):-
	NewColumn = 6.
	
columnValid('G', NewColumn):-
	NewColumn = 7.
columnValid(g, NewColumn):-
	NewColumn = 7.
	
columnValid('H', NewColumn):-
	NewColumn = 8.
columnValid(h, NewColumn):-
	NewColumn = 8.
	






