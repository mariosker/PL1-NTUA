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
    ;   writeln(N),
        writeln(K),
        writeln(A)
    ).
