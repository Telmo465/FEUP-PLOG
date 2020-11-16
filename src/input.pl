readRow(Row, NewRow):-
	repeat,
	write('Row: '),
	once(read(Row)),
	check(Row),
	rowValid(Row, NewRow).
	
readColumn(Column, NewColumn):-
	write('Column:'),
	read(Column),
	columnValid(Column, NewColumn).

check(Row):-
	Row >= 1,
	Row =< 6.

check(_Other):-
	write('\nERROR: that option does not exist.\n\n'),
	fail.
	

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
	