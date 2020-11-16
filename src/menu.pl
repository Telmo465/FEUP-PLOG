main_menu:-
    print_Menu,
    selectoption.

print_Menu:-
    write('\n\n ________________________________________________________________________ \n'),
    write('|                                                                        |\n'),
    write('|                                                                        |\n'),
    write('|          >===>              >=>            >=>                         |\n'),
    write('|        >>    >=>            >=>       >>   >=>                >>       |\n'),
    write('|       >=>           >==>    >=>  >=>     >=>>==>    >=> >=>            |\n'),
    write('|       >=>         >>   >=>  >=> >=>  >=>   >=>    >=>   >=>  >=>       |\n'),
    write('|       >=>   >===> >>===>>=> >=>=>    >=>   >=>   >=>    >=>  >=>       |\n'),
    write('|        >=>    >>  >>        >=> >=>  >=>   >=>    >=>   >=>  >=>       |\n'),
    write('|         >====>     >====>   >=>  >=> >=>    >=>    >==>>>==> >=>       |\n'),
    write('|                                                                        |\n'),
    write('|                                                                        |\n'),
    write('|             ---------------------------------------------              |\n'),
    write('|                                                                        |\n'),
    write('|                         1. Player vs Player                            |\n'),
    write('|                                                                        |\n'),
    write('|                         2. Player vs Computer                          |\n'),
    write('|                                                                        |\n'),
    write('|                         3. Computer vs Computer                        |\n'),
    write('|                                                                        |\n'),
    write('|                         0. Exit                                        |\n'),
    write('|                                                                        |\n'),
    write('|________________________________________________________________________|\n').

selectoption:-
    repeat,
    write('Select mode:\n'),
    once(read(Option)),
    checkMenuOption(Option),
    manageInput(Option).

checkMenuOption(Option):-
    Option >= 0,
    Option =< 3.

checkMenuOption(_):-
    write('\nERROR: that option does not exist.\n\n'),
    fail.

manageInput(0):-
    write('\nExiting...\n\n').

manageInput(1):-
    game_loop('Player', 'Player'),
    main_menu.
