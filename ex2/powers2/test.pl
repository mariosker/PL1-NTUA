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

sol(N, K, W) :-
    (   listwithmostpowers(N, Y),
        writeln(Y),
        length(Y, LengthY),
        LengthY>K
    ->  W=[]
    ;   LengthY=K
    ->  W=Y
    ;   knew(N, K, LengthY, Y, W)
    ).

knew(N, K, Length, [H|T], R) :-
    K=:=Length->R=[H|T];H=:=1->knew(N, K, Length, T, Y), R;listwithmostpowers(H, P), NewP=P/2, knew(N, K, Length+1,  ([NewP]| [NewP]| T), Y), R=[NewP]| [NewP]| R.


/*
[2,8,32]

[1,1]::[8,32]
[1,1]::[4,4]::[32]
[1,1]::[2,2]::[4]::[32]

[1,1,2,2,4,32]
*/
