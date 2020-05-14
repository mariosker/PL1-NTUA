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

sol(K, K, Y, W) :-
	W=Y.
sol(K, L, Y, W) :-
	(   L<K
	->  changeList(K, Y, L, W)
	;   W=[]
	).

changeList(K, Y, L, W) :-
	make_list(K, Y, L, LSD),
	NewK is K-1,
	forup(0, NewK, LSD, LSP),
	W=LSP.

produce_list([1|T], NewList) :-
	produce_list(T, NList),
	append([1], NList, NewList).
produce_list([H|T], NewList) :-
	NewH is H/2,
	append([NewH, NewH], T, NewList).

make_list(K, List, K, NewList) :-
	NewList=List.
make_list(K, List, ListLength, NewList) :-
	produce_list(List, BetterList),
	NewLength is ListLength+1,
	make_list(K, BetterList, NewLength, NewList).

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
