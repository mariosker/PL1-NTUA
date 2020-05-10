(**************************************************************************
Project     : Programming Languages 1 - Assignment 2 - Exercise 3
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 9, 2020.
Description : Stayhome. (SML)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************)

(* returns first element of a pair*)
fun f_pair (a,_) = a


(* returns second element of a pair*)
fun s_pair (_,b) = b


(* prints a pair in the form (a, b) and adds a new line*)
fun print_coordsln (a,b) = print("(" ^ (Int.toString(b)) ^ ", " ^ (Int.toString(a))^ ")\n")


(* prints a pair in the form (a, b)*)
fun print_coords (a,b) = print("(" ^ (Int.toString(b)) ^ ", " ^ (Int.toString(a))^ ")  ")


(* prints a list of pairs and adds a new line*)
fun print_coord_list [] = print("\n")
    | print_coord_list (h::t) =
        (print_coords h;
        print_coord_list t);


(* returns a char array array *)
fun parse file =
    let
        val inStream = TextIO.openIn file;

        fun readlines acc y =
            let
                val opt = TextIO.inputLine inStream
            in
                if opt = NONE
                then
                    (rev acc, y)
                else
                    readlines (Array.fromList(explode (valOf opt))::acc) (y+1)
            end;

        val read_lines_out = readlines [] 0;
        val outbreak_map = Array.fromList(f_pair read_lines_out)
        val map_height = s_pair read_lines_out
        val map_width = Array.length (Array.sub (outbreak_map,0)) - 1
    in
        (outbreak_map, map_width, map_height)
    end;


(* returns positions of the traveler, the destination,
the oubreak starting point and the locations of the airports *)
fun map_data arr width height=
    let
        val S_x = ref 0;
        val S_y = ref 0;
        val T_x = ref 0;
        val T_y = ref 0;
        val W_x = ref 0;
        val W_y = ref 0;

        (* checks every element in the row *)
        fun check_row row (~1) y_indx airport_coords = airport_coords
        | check_row row x_indx y_indx airport_coords =
            let
                val data = Array.sub(row, x_indx)
            in
                if data = #"S" then(
                    S_x := x_indx;
                    S_y := y_indx;
                    check_row row (x_indx-1) y_indx airport_coords
                )
                else if data = #"T" then(
                    T_x := x_indx;
                    T_y := y_indx;
                    check_row row (x_indx-1) y_indx airport_coords
                )
                else if data = #"W" then(
                    W_x := x_indx;
                    W_y := y_indx;
                    check_row row (x_indx-1) y_indx airport_coords
                )
                else if data = #"A" then(
                    check_row row (x_indx-1) y_indx ((x_indx,y_indx)::airport_coords)
                )
                else
                    check_row row (x_indx-1) y_indx airport_coords
            end;

        (* check every array/ row in the array *)
        fun check_array arr width (~1) airport_coords = airport_coords
        |   check_array arr width height airport_coords =
            let
              val to_add = check_row (Array.sub(arr, height)) width height []
            in
              check_array arr width (height-1) (to_add@airport_coords)
            end

        val airport_coords = check_array arr width height []
    in
        ((!S_x, !S_y),(!T_x, !T_y),(!W_x, !W_y),airport_coords)
    end;

(*  *)
fun flood arr width height time =



(* main program *)
fun stayhome filename =
    let
        val (outbreak_map, map_width, map_height) = parse filename
        val (traveler, destination, outbreak, airport_coords) = map_data outbreak_map (map_width-1) (map_height-1)
    in
        print("SOTOS: ");
        print_coordsln traveler;
        print("HOME: ");
        print_coordsln destination;
        print("OUTBREAK: ");
        print_coordsln outbreak;
        print("AIRPORTS: ");
        print_coord_list airport_coords
    end;


stayhome "./tests-input/test1.txt";
(* stayhome "./tests-input/test2.txt"; *)
(* stayhome "./tests-input/test3.txt"; *)