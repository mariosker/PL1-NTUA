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
			| print_aux (h::[]) = (print (Int.toString(h)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h)); print ","; print_aux t);
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

        val airport_coords = []
        val traveler_coords = 0
        val destination_coords = 0
        val outbreak_starting_point = 0

        fun readlines acc y=
            let
                val opt = TextIO.inputLine inStream

                fun clean_list [] x y = []
                    | clean_list [#"\n"] x y = []
                    | clean_list (#"S"::t) x y =
                    let
                        val traveler_coords = (y,x)
                    in
                        ~1::clean_list t (x+1) y
                    end
                    | clean_list (#"T"::t) x y =
                    let
                        val destination_coords = (y,x)
                    in
                        ~1::clean_list t (x+1) y
                    end
                    | clean_list (#"W"::t) x y =
                    let
                        val outbreak_starting_point = (y,x)
                    in
                        0::clean_list t (x+1) y
                    end
                    | clean_list (#"A"::t) x y =
                    let
                        val airport_coords = [(y,x)]::airport_coords
                    in
                        ~1::clean_list t (x+1) y
                    end
                    | clean_list (#"X"::t) x y =
                        ~3::clean_list t (x+1) y
                    | clean_list (_::t) x y =
                        ~1::clean_list t (x+1) y

            in
                if opt = NONE
                then
                    (rev acc, y)
                else
                    (readlines ((clean_list(explode (valOf opt)) 0 y)::acc) (y+1))
            end;

        val (outbreak_map, map_height) = readlines [] 0
        val map_width = length (hd outbreak_map)
    in
        print(Int.toString (#1 traveler_coords));
        print_double_list(outbreak_map)
    end;

parse "./tests-input/test1.txt"