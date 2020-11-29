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
	

rowValid(1, 1).

rowValid(2, 2).

rowValid(3, 3).

rowValid(4, 4).

rowValid(5, 5).

rowValid(6, 6).

columnValid('A', 1).

columnValid(a, 1).
	
columnValid('B', 2).

columnValid(b , 2).
	
columnValid('C', 3).

columnValid(c, 3).
	
columnValid('D', 4).

columnValid(d, 4).
	
columnValid('E', 5).

columnValid(e, 5).
	
columnValid('F', 6).

columnValid(f, 6).
	