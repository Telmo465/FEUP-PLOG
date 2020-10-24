:-consult('input.pl').


initialBoard([
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty]
]).


/*pieces symbols*/
symbol(empty,S) :- S=' '.
symbol(black,S) :- S='X'.
symbol(red,S) :- S='O'.


letter(1, L) :- L='A'.
letter(2, L) :- L='B'.
letter(3, L) :- L='C'.
letter(4, L) :- L='D'.
letter(5, L) :- L='E'.
letter(6, L) :- L='F'.


printBoard(X) :-
    nl,
    write('   | 1 | 2 | 3 | 4 | 5 | 6 |\n'),
    write('---|---+---+---+---+---+---|\n'),
    printMatrix(X, 1).
	

printMatrix([], 7).

printMatrix([Head|Tail], N) :-
    letter(N, L),
	write(' '),
    write(L),
	write(' | '),
    N1 is N +1,
    printLine(Head),
    write('\n---|---+---+---+---+---+---|\n'), 
    printMatrix(Tail, N1).

printLine([]).

printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).













