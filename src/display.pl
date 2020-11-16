initialBoard([
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty]
]).


intermediateBoard([  
[red,empty,black,empty,black,empty],  
[empty,empty,empty,empty,empty,empty],  
[black,empty,empty,red,empty,empty],  
[empty,empty,empty,empty,empty,black],  
[empty,red,empty,empty,empty,empty],  
[empty,empty,empty,empty,red,empty]  
]).


finalBoard([  
[empty,empty,empty,red,empty,empty],  
[empty,empty,empty,empty,empty,empty],  
[empty,black,empty,empty,red,empty],  
[empty,empty,black,empty,empty,empty],  
[red,empty,empty,black,empty,empty],  
[empty,empty,empty,empty,empty,red]  
]).

initial:-
    initialBoard(X),
    printBoard(X).

intermediate:-
    intermediateBoard(X),
    printBoard(X).

final:-
    finalBoard(X),
    printBoard(X).

/*pieces symbols*/
symbol(1,S) :- S='Black'.
symbol(2,S) :- S='Red'.
symbol(empty,S) :- S=' '.
symbol('Black',S) :- S='X'.
symbol('Red',S) :- S='O'.



letter(1, L) :- L='1'.
letter(2, L) :- L='2'.
letter(3, L) :- L='3'.
letter(4, L) :- L='4'.
letter(5, L) :- L='5'.
letter(6, L) :- L='6'.


%displays a matrix passed as argument
printBoard(X) :-
    nl,
    write('   | A | B | C | D | E | F |\n'),
    write('---|---+---+---+---+---+---|\n'),
    printMatrix(X, 1).
	

printMatrix([], 7).

printMatrix([Head|Tail], N) :-
    letter(N, L),
	write(' '),
    write(L),
	write(' | '),
    N1 is N +1, % increments N to get next row
    printLine(Head),
    write('\n---|---+---+---+---+---+---|\n'), 
    printMatrix(Tail, N1). % calls printMatrix recursively

printLine([]).

printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).
