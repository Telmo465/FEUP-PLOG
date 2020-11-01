:-consult('utils.pl').
:-dynamic(state/2).

play:-
	game_loop(X,Y).

%implements the main loop of the game
game_loop(Player1, Player2):-
	initial(GameState),
	assert(move(1,Player1)),
    assert(move(2,Player2)),
    assert(state(1,GameState)), %asserts that the player 1 plays first
	display_game(GameState, 1), 
	repeat,
		retract(state(Player, Board)),
		once(playMove(Player, NextPlayer ,Board, NewBoard)), %replaces an empty cell with the respective player piece
		assert(state(NextPlayer, NewBoard)),
		display_game(NewBoard, NextPlayer), % displays the current state of the board
		checkWinner, % checks if the game has ended --> //TO IMPLEMENT
	endGame.

	

initial(GameState):-
	initialBoard(GameState).
	
	
display_game(GameState, Player):-
	write('Current player: '),
	symbol(Player, Str),
	write(Str),nl,
	printBoard(GameState).


repeat.
repeat:-
	repeat.	



%reads input and makes the respective move on the board
playMove(Player, NextPlayer, State, NewState):-
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


checkWinner:- %TO IMPLEMENT
	fail.


endGame. %TO IMPLEMENT