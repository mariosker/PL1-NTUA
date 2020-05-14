/*
Project     : Programming Languages 1 - Assignment 2 - Exercise 1
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 13, 2020.
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

powers2(File, Answers) :-
	read_input(File, _, Tests),
	proccess_tests(Tests, Answers).

proccess_tests([], []).
proccess_tests([[N, K]|T], A) :-
	proccess_tests(T, RestAns),
	solu(N, K, Ans),
	A=[Ans|RestAns], !.

listwithmostpowers(N, W) :-
	(   N=:=0
	->  W=[]
	;   N=:=1
	->  W=[1]
	;   nearest_power(N, P),
		NewN is N-P,
		listwithmostpowers(NewN, NewW),
		append(NewW, [P], W)
	).

nearest_power(0, 0).
nearest_power(1, 1).
nearest_power(N, W) :-
	Wnew is 2**floor(log10(N)/log10(2)),
	W=Wnew.

solu(N, K, W) :-
	listwithmostpowers(N, Y),
	length(Y, LengthY),
	sol(K, LengthY, Y, W).

sol(K, L, Y, W) :-
	(   L<K
	->  changeList(K, Y, L, W)
	;   L==K
	->  last(Y, LastY),
		NewK is log10(LastY)/log10(2),
		forup(0, NewK, Y, W)
	;   W=[]
	).

changeList(K, Y, L, W) :-
	make_list(K, Y, L, LSD),
	last(LSD, LastElement),
	NewK is log10(LastElement)/log10(2),
	forup(0, NewK, LSD, W).

make_list(K, List, K, NewList) :-
	NewList=List.
make_list(K, List, ListLength, NewList) :-
	produce_list(List, BetterList),
	NewLength is ListLength+1,
	make_list(K, BetterList, NewLength, NewList).

produce_list([1|T], NewList) :-
	produce_list(T, NList),
	append([1], NList, NewList).
produce_list([H|T], NewList) :-
	NewH is H/2,
	append([NewH, NewH], T, NewList).

% forup(_, _, [], []).
forup(N, K, List, ResList) :-
	(   N>K
	->  ResList=[]
	;   Target is 2**N,
		count(Target, List, Res, CountResList),
		NewN is N+1,
		forup(NewN, K, CountResList, NewResList),
		append([Res], NewResList, ResList)
	).

count(_, [], 0, []).
count(N, [H|T], Res, TList) :-
	(   H==N
	->  count(N, T, NRes, TList),
		Res is NRes+1
	;   H>N
	->  TList=[H|T],
		Res=0
	).
