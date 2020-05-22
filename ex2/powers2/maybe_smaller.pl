/*
Project     : Programming Languages 1 - Assignment 2 - Exercise 1
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 14, 2020.
Description : Powers2. (Prolog)
-----------
School of ECE, National Technical University of Athens.
*/


% read input is from stackoverflow and example file
% https://stackoverflow.com/questions/51206614/read-a-file-and-save-to-a-list
read_input(File, T, C) :-
	open(File, read, Stream),
	read_line(Stream, [T]),
	read_lines(Stream, T, C).

read_line(Stream, L) :-
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	atomic_list_concat(Atoms, ' ', Atom),
	maplist(atom_number, Atoms, L).

read_lines(Stream, N, Lines) :-
	(   N==0
	->  Lines=[]
	;   N>0,
		read_line(Stream, Line),
		NewN is N-1,
		read_lines(Stream, NewN, RestLines),
		Lines=[Line|RestLines]
	).

% main part of program
powers2(File, Answers) :-
	set_prolog_flag(stack_limit, 262144000),
	read_input(File, _, Tests),
	proccess_tests(Tests, Answers).

% runs all tuples- tests and appends their solution to a list for output
proccess_tests([], []).
proccess_tests([[N, K]|T], A) :-
	proccess_tests(T, RestAns),
	solu(N, K, Ans),
	A=[Ans|RestAns], !.


% % creates a list with sum = number and elements are the biggest powers of the number
% listwithmostpowers(N, W) :-
% 	(   N=:=0
% 	->  W=[]
% 	;   N=:=1
% 	->  W=[1]
% 	;   nearest_power(N, P),
% 		NewN is N-P,
% 		listwithmostpowers(NewN, NewW),
% 		append(NewW, [P], W)
% 	).



% creates a list with sum = number and elements are the biggest powers of the number
listwithmostpowers(0, []).
listwithmostpowers(1, [1]).
listwithmostpowers(N, W) :-
	nearest_power(N, P),
	NewN is N-P,
	listwithmostpowers(NewN, NewW),
	append(NewW, [P], W).


% gets a number and returns the biggest power of 2
nearest_power(0, 0).
nearest_power(1, 1).
nearest_power(N, W) :-
	Wnew is 2**floor(log10(N)/log10(2)),
	W=Wnew.

% called by proccess_tests, handles the tuple- test and return the solution
solu(N, K, W) :-
	trim_stacks,
	listwithmostpowers(N, Y),
	length(Y, LengthY),
	sol(K, LengthY, Y, W).

% checks if it is possible to get a solution and proccesses the list of biggest powers and returns the correct list
sol(K, L, Y, W) :-
	(   L<K
	->  changeList(K, Y, L, W)
	;   L==K
	->  garbage_collect,
		last(Y, LastY),
		NewK is log10(LastY)/log10(2),
		forup(0, NewK, Y, W)
	;   W=[]
	).

% changes the list to the acceptable output
changeList(K, Y, L, W) :-
	trim_stacks,
	garbage_collect,
	make_list(K, L, Y, _, LSD),
	last(LSD, LastElement),
	NewK is log10(LastElement)/log10(2),
	forup(0, NewK, LSD, W).

% the same with changeList
forup(N, K, List, ResList) :-
	(   N>K
	->  ResList=[]
	;   Target is 2**N,
		count(Target, List, Res, CountResList),
		NewN is N+1,
		forup(NewN, K, CountResList, NewResList),
		append([Res], NewResList, ResList)
	).

% counts the number of appearances of a number in the list
count(_, [], 0, []).
count(N, [H|T], Res, TList) :-
	(   H==N
	->  count(N, T, NRes, TList),
		Res is NRes+1
	;   H>N
	->  TList=[H|T],
		Res=0
	).

% makes the list longer if needed but keeps it lexigocraphically smallest.
make_list(_, ListLength, [], NewListLength, []) :-
	NewListLength=ListLength.
make_list(K, K, In, _, Out) :-
	Out=In.
make_list(K, ListLength, [H|T], NewListLength, Out) :-
	(   H=:=1
	->  make_list(K, ListLength, T, NewListLength, NOut),
		append([1], NOut, Out)
	;   NewH is H/2,
		NListLength is ListLength+1,
		make_list(K, NListLength, [NewH], NNListLength, NOut),
		make_list(K,
						  NNListLength,
						  [NewH],
						  NNNListLength,
						  NNOut),
		make_list(K,
						  NNNListLength,
						  T,
						  NNNNListLength,
						  NNNOut),
		NewListLength=NNNNListLength,
		append(NOut, NNOut, SomeOut),
		append(SomeOut, NNNOut, Out)
	).
