(**************************************************************************
Project     : Programming Languages 1 - Assignment 2 - Exercise 3
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 9, 2020.
Description : Stayhome. (SML)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************)

fun print_list lst =
	let
		fun print_aux nil = print "]\n"
			| print_aux (h::[]) = (print (Char.toString(h)); print_aux [])
			| print_aux (h::t) = (print (Char.toString(h)); print ","; print_aux t);
	in
		print "[";
		print_aux lst
	end;

fun print_double_list [] = ()
 | print_double_list (h::t) =
    (print_list h;
    print_double_list t);


fun parse file =
    let
        val inStream = TextIO.openIn file;
        fun readlines acc =
            let
                val opt = TextIO.inputLine inStream
                fun clean_list [] = []
                    | clean_list [#"\n"] = []
                    | clean_list (h::t) =
                        h::clean_list t
            in
                if opt = NONE
                then
                    (rev acc)
                else
                    (readlines ((clean_list(explode (valOf opt)))::acc))
            end;

        val outbreak_map = readlines []
        val width = length (hd outbreak_map)
        val height = length outbreak_map
    in
        (outbreak_map)
    end;1

print_double_list (parse "./tests-input/test1.txt");