:-use_module(library(clpfd)).
:-use_module(library(lists)).
:- use_module(library(random)).

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

list([[red,red,yellow,white, green],
    [yellow,white,white, white],
     [white,green, white],
      [white, white],
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


solver(List):-
    %list(List),
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

    getWhiteCells(Output, [], FinalList, ColorList),
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
    %write(FinalRow),nl,
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
    

    
/*  Generate problems */

randomLabelingValues(Var, _Rest, BB, BB1) :-
    fd_set(Var, Set),
    select_best_value(Set, Value),
    (   
        first_bound(BB, BB1), Var #= Value
        ;   
        later_bound(BB, BB1), Var #\= Value
    ).

select_best_value(Set, BestValue):-
    fdset_to_list(Set, Lista),
    length(Lista, Len),
    random(0, Len, RandomIndex),
    nth0(RandomIndex, Lista, BestValue).



getSubList(_,0,_).
getSubList(Input,N,It):-
    nth0(It, Input, SubL),
    length(SubL,N),
    NewN is N-1, NewIt is It+1,
    getSubList(Input,NewN,NewIt).




generator(N, List):-
    getSubList(List, N, 0),
    append(List, FlatList),
    length(FlatList, FlatLen),    
    applyColors(FlatList, 0, FlatLen),
    (
    ((N =< 4) ->(R2 is 1)) ; ((N < 7) -> R2 is 2 ; fail)
    ),
    global_cardinality(FlatList, [1-R2,2-R2,3-R2,4-_]),
    placeColorsInList(List, 0, [], Output1, N),


    flatten(Output1, FlatList1),
    length(Output1, NumRows),
    domain([R,G,Y], 1,2000),
    placeColorsConstraints(0, ColouredList, NumRows, Output1, [R,G,Y]),
    applyConstraints(ColouredList),
    term_variables(ColouredList, Output),
    all_distinct(Output),
    
    labeling([value(randomLabelingValues)], Output),

    once(removeAllExceptWhite(FlatList1, [], List1)),
    once(getColors(List1, Output, [], List1, ColorList)),
    once(getWhiteCells(Output, [], FinalList, ColorList)),
    once(displayOutput(Output1, ColorList, FinalList,[], FinalSolution)),
    write(FinalSolution).


applyColors(_, Len, Len).
applyColors(FlatList, Index, Len):-
    nth0(Index, FlatList, Elem),
    Elem in 1..4,
    NIndex is Index + 1,
    applyColors(FlatList, NIndex, Len).


placeColorsInList(_, ListLen, Output, Output, ListLen).
placeColorsInList(List, RowNum, FinalList, Output, ListLen):-
    nth0(RowNum, List, SubL),
    length(SubL, Len),
    iterateSubL(SubL, 0, Len, [], NewSubL),
    %write(NewSubL),
    append(FinalList, [NewSubL], NewFinalList),

    NewRowNum is RowNum + 1,
    placeColorsInList(List, NewRowNum, NewFinalList, Output, ListLen).
    
    

iterateSubL(_, Len, Len, Output, Output).
iterateSubL(SubL, Index, Len, ColorList, Output):-
    nth0(Index, SubL, Elem),
    getColor(Elem, Color),
    append(ColorList, [Color], NewColorList),
    NIndex is Index + 1,
    iterateSubL(SubL, NIndex, Len, NewColorList, Output).
    


getColor(1,red).
getColor(2,green).
getColor(3,yellow).
getColor(4,white).