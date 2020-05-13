/*
 * A predicate that reads the input from File and returns it in
 * the last three arguments: N, K and C.
 * Example:
 *
 * ?- read_input('c1.txt', N, K, C).
 * N = 10,
 * K = 3,
 * C = [1, 3, 1, 3, 1, 3, 3, 2, 2|...].
 */
read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).
