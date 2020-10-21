
play :-
	initial(GameState),
	display_game(GameState, Player).
	
initial(GameState):-
	initialBoard(GameState).
	
	
display_game(GameState, Player):-
	printBoard(GameState).