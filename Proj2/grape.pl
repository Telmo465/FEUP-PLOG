:-use_module(library(clpfd)).
:-use_module(library(lists)).

/*
   [   [red,yellow,yellow,green],
         [white,red,white],
          [green,white],
           [white]
    ]
*/

%copied from SWI prolog
flatten([], []) :- !. %transforms matrix into list
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).

list([[red,yellow,yellow,green],
    [white,red,white],
     [green,white],
      [white]
]).


exactly(_, [], 0). /*slides aulas teoricas*/
exactly(X, [Y|L], N) :-
    X #= Y #<=> B,
    N #= M + B,
    exactly(X, L, M).



%list([[A,B,C,D,E,F],[G,H,I,J,B],[K,L,G,M],[N,O,L],[P,Q],[R]]).

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
    nth0(0, List, FirstRow),
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


solver(Output):-
    list(List),
    flatten(List, FlatList1),
    FlatList2 = FlatList1,
    %write(FlatList), nl,
    
    length(List, NumRows),

    domain([R,G,Y], 1,2000),
    placeColorsConstraints(0, ColouredList, NumRows, List, [R,G,Y]),
    
    applyConstraints(ColouredList),
    term_variables(ColouredList, Output),
    all_distinct(Output),
    
    labeling([], Output), 
    removeAllExceptWhite(FlatList1, [], List1),
    
    getColors(List1, Output, [], List1, ColorList),

    %write(ColorList),
    getWhiteCells(Output, [], FinalList, ColorList),
    %write(FinalList),nl,
    %write(List),
    displayOutput(List, ColorList, FinalList,[], FinalSolution),
    write(FinalSolution).
    


/*  Display the output in a human-friendly way */

removeAllExceptWhite([], Solution, Solution).

removeAllExceptWhite([H|List], FinalList, Solution):-
    \+member(H, FinalList),
    H \= white,
    append(FinalList, [H], NewFinalList),
    removeAllExceptWhite(List, NewFinalList, Solution).

removeAllExceptWhite([white|List], FinalList, Solution):-
    append(FinalList, [white], NewFinalList),
    removeAllExceptWhite(List, NewFinalList, Solution).

removeAllExceptWhite([H|List], FinalList, Solution):-
    removeAllExceptWhite(List, FinalList, Solution).


getColors([], FinalList, NewSolution,_, NewSolution).

getColors([H|ColorList], FinalList, Solution, InitialList, FinalSolution):-
    nth0(Index, InitialList, H),
    H \= white,
    \+member(H-_, Solution),
    nth0(Index, FinalList, Elem),
    append(Solution, [H-Elem], NewSolution),
    getColors(ColorList, FinalList, NewSolution, InitialList, FinalSolution).


getColors([white|ColorList], FinalList, Solution, InitialList, FinalSolution):-
    getColors(ColorList, FinalList, Solution, InitialList, FinalSolution).

getColors([_|ColorList], FinalList, Solution, InitialList, FinalSolution):-
    getColors(ColorList, FinalList, Solution, InitialList, FinalSolution).



getWhiteCells([], Solution, Solution, _).

getWhiteCells([H|FlatList], WhiteList, FinalList, ColorList):-
    \+member(_-H, ColorList),
    append(WhiteList, [H], NewWhiteList),
    getWhiteCells(FlatList, NewWhiteList, FinalList, ColorList).


getWhiteCells([H|FlatList], WhiteList, FinalList, ColorList):-
    getWhiteCells(FlatList, WhiteList, FinalList, ColorList).
    

displayOutput([], ColorList, WhiteList, FinalSolution, FinalSolution).

displayOutput([Row|List], ColorList, WhiteList, Solution, FinalSolution):-
    displayRows(Row, ColorList, WhiteList, [], FinalRow, NewWhiteList),
    append(Solution, [FinalRow], NewFinalSolution),
    write(FinalRow),nl,
    displayOutput(List, ColorList, NewWhiteList, NewFinalSolution, FinalSolution).


displayRows([], ColorList, NewWhiteList, Row, Row, NewWhiteList).

displayRows([H|Row], ColorList, WhiteList, RowList, FinalRow, NewWhiteList):-
    member(H-Num, ColorList),
    %write(ColorList),nl,
    
    %write('estou aqui bro: Num= '), write(Num),nl,
    append(RowList, [Num], NewRowList),
    displayRows(Row, ColorList, WhiteList, NewRowList, FinalRow, NewWhiteList).


displayRows([white|Row], ColorList, [H|WhiteList], RowList, FinalRow, NewWhiteList):-
    append(RowList, [H], NewRowList),
    displayRows(Row, ColorList, WhiteList, NewRowList, FinalRow, NewWhiteList).
    

    
