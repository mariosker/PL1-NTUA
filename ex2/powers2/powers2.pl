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

proccess_tests([], _).
proccess_tests([[N, K]|T], A) :-
    solution(N, K, Ans),
    proccess_tests(T, RestAns),
    A=[Ans|RestAns].

%solution(_, 0, []).
solution(N, K, A) :-
    (   K=:=0
    ->  A=[]
    ;   dec_bin(N, Nbin),
        count(Nbin, Kcomp),
        Kcomp>K
    ->  A=[]
    ;   Kcomp=:=K
    ->  A is Nbin
    ).

% from stackoverflow [https://stackoverflow.com/questions/13864414/how-to-convert-decimal-to-binary-number-in-prolog]
dec_bin(0, [0]).
dec_bin(1, [1]).
dec_bin(N, B) :-
    N>1,
    X is N mod 2,
    Y is N//2,
    dec_bin(Y, B1),
    append([X], B1, B).

% from stackoverflow [https://stackoverflow.com/questions/46902653/prolog-how-to-count-the-number-of-elements-in-a-list-that-satisfy-a-specific-c?rq=1]
count([], 0).
count([H|T], N) :-
    count(T, X),
    (   H=:=1
    ->  N is X+1
    ;   N is X
    ).


find_powers([],B).
find_powers(Binary_List, K, Result) :-
    count(Binary_List, Kcomp),
    Ones_Needed is K - Kcomp,
    reverse(Binary_List, Reversed_List),




% next_two([], _, []).
% next_two([0|T], false, A) :-
%     next_two(T, false, A).
% next_two([0|T], true, A) :-
%     next_two(T, true, Anew),
%     A=[0|Anew].
% next_two([1|T], false, A) :-
%     next_two(T, true, Anew),
%     A=[1|Anew].
% next_two([1|T], true, A) :-
%     next_two(T, true, Anew),
%     A=[0|Anew].]



% sum([], 0).
% sum([H|T], N) :-
%     sum(T, X),
%     N is X+H.

% is_power2([], true).
% is_power2([H|T], B) :-
%     ModH is log10(H)/log10(2),
%     (   integer(ModH)==true
%     ->  is_power2(T, Y),
%         B=Y
%     ;   B=false
%     ).

% sol(N, K, W) :-
%     length(W, K),
%     sum(W, N).


listwithmostpowers(N, W) :-
    N == 0 -> W = [];
    N == 1 -> W = [1];
    nearest_power(N, P),
    NewN is N - P,
    listwithmostpowers(NewN, NewW),
    W = P | NewW.

nearest_power(0, 0).
nearest_power(N, W) :-
    Wnew is 2**floor(log10(N)/log10(2)),
    W=Wnew.
