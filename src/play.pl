:-consult('utils.pl').
:-dynamic(state/2).

play(Player1, Player2):-
	initial(GameState),
	assert(move(1,Player1)),
    assert(move(2,Player2)),
    assert(state(1,GameState)),
	printBoard(GameState),
	repeat,
		retract(state(Player, Board)),
		write('After retract'),nl,
		once(playMove(Player, NextPlayer ,Board, NewBoard)),
		assert(state(NextPlayer, NewBoard)),
		display_game(NewBoard, NextPlayer),
		1>2,
	endGame.

	

initial(GameState):-
	initialBoard(GameState).
	%printBoard(GameState).
	
	
display_game(GameState, Player):-
	printBoard(GameState).
	
repeat.
repeat:-
	repeat.	



	
playMove(Player, NextPlayer, State, NewState):-
	write('Current player: '),
	symbol(Player, Str),
	write(Str),nl,
	readMove(Row, Col, ValidRow, ValidCol),
	symbol(Player, S),
	makeMove(State, ValidRow, ValidCol, S, NewState),

	(
		(Player =:= 1,
		NextPlayer is 2
		);

		(Player =:= 2,
			NextPlayer is 1
		)
	).


endGame.