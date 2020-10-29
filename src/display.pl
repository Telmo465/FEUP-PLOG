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













