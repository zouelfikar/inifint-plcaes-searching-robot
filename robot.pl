
% initMyData(+NBoxesToPick, -ProgramDataInitial).
% The internal state of the robot : (NBoxesToPick) is the number of boxes he has to carry ,the coordinates of the present moment, 
%									a flag that informs him if the robot carries a box,
%				 					the maximum number of moves made to the East 
%									the maximum number of moves made to the South is equal to number of moves made to the East,
%									the maximum number of moves made to the West
%									the maximum number of moves made to the North is equal to number of moves made to the West



initMyData(NBoxesToPick, [(0,0), NBoxesToPick, false, 1, 2, 0, e ]).

% perform(+ProgramData, +ContainsBox, -Action, -ProgramDataUpdated)

% (X, Y) - the coordinates of the present moment
% (XNext, YNext) - the coordinates of the next moment

% The robot will find the origin and delivered all the boxes to origin, and he is done.
perform([(0,0), 0, false, _, _, _, _], _, done, [(0, 0), 0, false, _, _, _, _]).


% The moves to find the box
% Start by going to the east for searching.

%                      ************** 		Going to the East		**************

% If the robot does not reach the maximum number of moves to the East, then he will go to the East.
perform([(X, Y), NBoxesToPick, false, EastMoves, NorthMoves, NumberOfMoves, e ], false, move(east),
		[(XNext, YNext), NBoxesToPick, false, EastMoves, NorthMoves, NoMoves, e ]) :- 
		NumberOfMoves =\= EastMoves, XNext is X + 1, YNext is Y, NoMoves is NumberOfMoves + 1, !.

%                      ************** 		Going to the South		**************

% If the robot reach the maximum number of moves to the East, then he will go to the South.
perform([(X, Y), NBoxesToPick, false, EastMoves, WestMoves, EastMoves, e ], false, move(south),
		[(XNext, YNext), NBoxesToPick, false, EM, WM, 0, s ]) :- 
		XNext is X, YNext is Y - 1, EM is EastMoves , WM is WestMoves , ! .	

% If the robot does not reach the maximum number of moves to the South, then he will go to the South.
perform([(X, Y), NBoxesToPick, false, SouthMoves, WestMoves, NumberOfMoves, s ], false, move(south),
		[(XNext, YNext), NBoxesToPick, false, SouthMoves, WestMoves, NoMoves, s ]) :- 
		NumberOfMoves =\= SouthMoves, XNext is X , YNext is Y - 1, NoMoves is NumberOfMoves + 1, !.

%                      ************** 		Going to the West		**************

% If the robot reach the maximum number of moves to the South, then he will go to the West.
perform([(X, Y), NBoxesToPick, false, SouthMoves, WestMoves, SouthMoves, s ], false, move(west),
		[(XNext, YNext), NBoxesToPick, false, EM, WM, 0, w ]) :- 
		XNext is X - 1 , YNext is Y , EM is SouthMoves  , WM is WestMoves, ! .

% If the robot does not reach the maximum number of moves to the West, then he will go to the West.
perform([(X, Y), NBoxesToPick, false, EastMoves, WestMoves, NumberOfMoves, w ], false, move(west), 
		[(XNext, YNext), NBoxesToPick, false,EastMoves, WestMoves, NoMoves, w]) :- 
		NumberOfMoves =\= WestMoves, XNext is X - 1 , YNext is Y , NoMoves is NumberOfMoves + 1, !.

%                      ************** 		Going to the North		**************


% If the robot reach the maximum number of moves to the West, then he will go to the North.
perform([(X, Y), NBoxesToPick, false, EastMoves, WestMoves, WestMoves, w], false, move(north),
		[(XNext, YNext), NBoxesToPick, false, EM, WM, 0, n]) :- 
		XNext is X , YNext is Y + 1, EM is EastMoves , WM is WestMoves , !.
		

% If the robot does not reach the maximum number of moves to the North, then he will go to the North.
perform([(X, Y), NBoxesToPick, false, EastMoves, WestMoves, NumberOfMoves, n], false, move(north),
		[(XNext, YNext), NBoxesToPick, false, EastMoves, WestMoves, NoMoves, n]) :- 
		NumberOfMoves =\= WestMoves, XNext is X , YNext is Y + 1, NoMoves is NumberOfMoves + 1, !.

%                      ************** 		Going to the East		**************

% If the robot reach the maximum number of moves to the North, then he will go to the East.

perform([(X, Y), NBoxesToPick, false, EastMoves, NorthMoves, NorthMoves, n], false, move(east),
		[(XNext, YNext), NBoxesToPick, false, EM, WM, 0, e]) :- 
		XNext is X + 1 , YNext is Y, EM is EastMoves + 2 , WM is NorthMoves + 2 , !.
		

% If the robot find a box, hold it
perform([(X, Y), NBoxesToPick, false, _, _, _, _], true, pickBox, [(X, Y), NBoxesToPick, true, _, _, _, _]) :- !. 

	
% Get back to the origin with the box 
% Go the to point where X = 0, then go the the point where Y = 0, the origin

perform([(X, Y), NBoxesToPick, true, _, _, _, _], _, moveWithBox(west), [(XNext, Y), NBoxesToPick, true, _, _, _, v]) :- 
	 X > 0, XNext is X - 1, !.

perform([(X, Y), NBoxesToPick, true, _, _, _, _], _, moveWithBox(east), [(XNext, Y), NBoxesToPick, true, _, _, _, e]) :- 
	 X < 0, XNext is X + 1, !.

perform([(X, Y), NBoxesToPick, true, _, _, _, _], _, moveWithBox(north), [(X, YNext), NBoxesToPick, true, _, _, _, _]) :- 
	 Y < 0, YNext is Y + 1, !.

perform([(X, Y), NBoxesToPick, true, _, _, _, _], _, moveWithBox(south), [(X, YNext), NBoxesToPick, true, _, _, _, _]) :- 
	 Y > 0, YNext is Y - 1, !.

% Deliver the box and decrease the number of boxes I have to deliver
perform([(0, 0), NBoxesToPick, true, _, _, _, _], _, deliverBox, [(0, 0), BoxesLeftToPick, false, 1, 2, 0, e]):- BoxesLeftToPick is NBoxesToPick - 1, !.	 
 

