/*
Project     : Programming Languages 1 - Assignment 2 - Exercise 1
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 13, 2020.
Description : Powers2. (Prolog)
-----------
School of ECE, National Technical University of Athens.
*/

/*
 * A predicate that reads the input from File and returns it in
 * the last three arguments: N, K and C.
 * Example:
 *
 * ?- read_input('c1.txt', N, K, C).
 * N = 10,
 * K = 3,
 * C = [1, 3, 1, 3, 1, 3, 3, 2, 2|...].

 * file:
 * 10 3
 * 1 3 1 3 1 3 3 2 2 1
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
proccess_tests(([N, K]| T), A) :-
    solution(N, K, Ans),
    proccess_tests(T,  (A| Ans)).

solution(N, K, A) :-
    writeln(N),
    writeln(K),
    writeln(A).
