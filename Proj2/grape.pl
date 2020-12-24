:-use_module(library(clpfd)).
:-use_module(library(lists)).

/*
   [   [red,yellow,yellow,green],
         [white,red,white],
          [green,white],
           [white]
    ]


list([[red,yellow,yellow,green],
    [white,red,white],
     [green,white],
      [white]
]).
*/

exactly(_, [], 0). /*slides aulas teoricas*/
exactly(X, [Y|L], N) :-
    X #= Y #<=> B,
    N #= M + B,
    exactly(X, L, M).



list([[A,B,C,D,E,F],[G,H,I,J,B],[K,L,G,M],[N,O,L],[P,Q],[R]]).

placeColorsConstraints(NumRows, _, NumRows, _, [R,G,Y]).
placeColorsConstraints(Index, ColouredList, NumRows, List, [R,G,Y]):-
    %write(ColouredList),nl,
    nth0(Index, List, SubList),
    length(SubList, Len), 
    nth0(Index, ColouredList, ColouredSubL),
    length(ColouredSubL, Len),
    fillColouredRows(0, SubList, ColouredSubL, Len, [R,G,Y], ColouredList),
    NIndex is Index+1,
    placeColorsConstraints(NIndex, ColouredList, NumRows, List, [R,G,Y]).


fillColouredRows(Len, _, _, Len,[R,G,Y],_).
fillColouredRows(Index ,SubL, ColouredSubL, Len, [R,G,Y], ColouredList):-
    nth0(Index, SubL, red),
    nth0(Index, ColouredSubL, Elem),
    Elem = R,
    NIndex is Index + 1,
    fillColouredRows(NIndex, SubL, ColouredSubL, Len, [R,G,Y], ColouredList).

fillColouredRows(Index ,SubL, ColouredSubL, Len, [R,G,Y], ColouredList):-
    nth0(Index, SubL, yellow),
    nth0(Index, ColouredSubL, Elem),
    Elem = Y,
    NIndex is Index + 1,
    fillColouredRows(NIndex, SubL, ColouredSubL, Len, [R,G,Y], ColouredList).

fillColouredRows(Index ,SubL, ColouredSubL, Len, [R,G,Y], ColouredList):-
    nth0(Index, SubL, green),
    nth0(Index, ColouredSubL, Elem),
    Elem = G,
    NIndex is Index + 1,
    fillColouredRows(NIndex, SubL, ColouredSubL, Len, [R,G,Y], ColouredList).

fillColouredRows(Index ,SubL, ColouredSubL, Len, [R,G,Y], ColouredList):-
    nth0(Index, SubL, white),
    term_variables(ColouredList, FlatList),
    nth0(Index, ColouredSubL, Elem),
    NIndex is Index + 1,
    fillColouredRows(NIndex, SubL, ColouredSubL, Len, [R,G,Y], ColouredList).


applyConstraints(List):-
    length(List, NumRows),
    %domain([R,G,B],2,20000),
    %placeColorsConstraints(0, ColouredList, NumRows, List, [R,G,B]),!,
    %term_variables(ColouredList, FlatList),
    %domain(FlatList, 1,20000),
    nth0(0, List, FirstRow),
   /* write(NumRows), nl,
    write(ColouredList), nl,*/
    %all_distinct(ColouredList),
    domain(FirstRow, 1, 9),
    buildGrapeList(1, List, NumRows).


buildGrapeList(NumRows, _, NumRows).
buildGrapeList(Index, List, NumRows):-
    /* go to correct sublist */
    PreviousIndex is Index - 1,
    nth0(PreviousIndex, List, PreviousSubList),
    nth0(Index, List, SubList),
    length(SubList, SubListLen),
    %write(SubList),nl,
    getCell(0, SubList, PreviousSubList, SubListLen),
    NIndex is Index + 1,
    buildGrapeList(NIndex, List, NumRows).

getCell(Len, _, _, Len).    
getCell(Index ,SubList, PreviousSubList, SubListLen):-
    nth0(Index, SubList, Elem),
    nth0(Index, PreviousSubList, First),
    NIndex is Index + 1,
    nth0(NIndex, PreviousSubList, Second),
    Elem #= First + Second,
    getCell(NIndex, SubList, PreviousSubList, SubListLen).


solver(List):-
    list(List),
    length(List, Len),
    %length(NewList, Len),
    %term_variables(NewFlatList, NewList),
    %domain(NewFlatList, 1, 20000),
    term_variables(List, FlatList),
    all_distinct(FlatList),
    
    applyConstraints(List),
    %write(List),nl,
    term_variables(List, Output),
    labeling([], Output).

