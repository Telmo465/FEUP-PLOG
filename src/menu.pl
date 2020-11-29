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

print_Menu2:-
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
    write('|                         1. Level Easy                                  |\n'),
    write('|                                                                        |\n'),
    write('|                         2. Level Hard                                  |\n'),
    write('|                                                                        |\n'),
    write('|                         0. Exit                                        |\n'),
    write('|                                                                        |\n'),
    write('|________________________________________________________________________|\n').

print_Menu3:-
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
    write('|                         1. Bots Easy                                   |\n'),
    write('|                                                                        |\n'),
    write('|                         2. Bots Hard                                   |\n'),
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

manageInput(3):-
    print_Menu3,
    selectoption3.

manageInput(2):-
    print_Menu2,
    selectoption2.

selectoption2:-
    repeat,
    write('Select mode:\n'),
    once(read(Option)),
    checkMenuOption2(Option),
    manageInput2(Option).

checkMenuOption2(Option):-
    Option >= 0,
    Option =< 2.

checkMenuOption2(_):-
    write('\nERROR: that option does not exist.\n\n'),
    fail.

manageInput2(0):-
    write('\nExiting...\n\n').

manageInput2(1):-
    game_loop('Player', 'BOT2'),
    main_menu.

manageInput2(2):-
    game_loop('Player', 'BOT1'),
    main_menu.

selectoption3:-
    repeat,
    write('Select mode:\n'),
    once(read(Option)),
    checkMenuOption3(Option),
    manageInput3(Option).

checkMenuOption3(Option):-
    Option >= 0,
    Option =< 2.

checkMenuOption3(_):-
    write('\nERROR: that option does not exist.\n\n'),
    fail.

manageInput3(0):-
    write('\nExiting...\n\n').

manageInput3(1):-
    game_loop('BOT2', 'BOT2'),
    main_menu.

manageInput3(2):-
    game_loop('BOT1', 'BOT1'),
    main_menu.