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


(* print char array array *)
fun  print_d_array arr height width h =
    let
        val row = Array.sub(arr, h);

        fun print_row row width w =
            if (width = w) then (print((Char.toString(Array.sub(row, w))) ^ "  \n")) else (
            (print((Char.toString(Array.sub(row, w))) ^ "  ");
            print_row row width (w+1)))
    in
        if (height = h) then (print_row row (width-1) 0) else(
        print_row row (width-1) 0;
        print_d_array arr height width (h+1))
    end

(* prints int Array2 *)
fun print_d_array_int arr =
	let
		val (dimy,dimx) =Array2.dimensions arr
		fun  print_d_array_int_aux arr height width h w =
			if h >= height then () else(
				if w >= width then (
					print("\n");
					print_d_array_int_aux arr height width (h+1) 0)
				else(
					print (Int.toString(Array2.sub(arr,h,w)) ^ "  ");
					print_d_array_int_aux arr height width h (w+1))
			)
	in(
		print_d_array_int_aux arr (dimy) (dimx) 0 0;
		())
	end


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

		val new_arr = Array2.array((height+1), (width+1), ~1)
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
					(* Array2.update(new_arr, y_indx, x_indx, 0); *)
                    check_row row (x_indx-1) y_indx airport_coords
                )
                else if data = #"A" then(
					Array2.update(new_arr, y_indx, x_indx, ~2);
                    check_row row (x_indx-1) y_indx ((x_indx,y_indx)::airport_coords)
                )
				else if data = #"X" then(
					Array2.update(new_arr, y_indx, x_indx, ~3);
                    check_row row (x_indx-1) y_indx airport_coords
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
        (new_arr,(!S_x, !S_y),(!T_x, !T_y),(!W_x, !W_y),airport_coords)
    end;

(* Uses the recursive flood fill algorithm from wikipedi apage *)
fun flood arr width height airport_coords outbreak =
    let
		val flag = ref 0

        fun flood_aux (x, y) time =
            let
				val current = Array2.sub(arr, y, x)
                fun move_up (x, y) time =
				(
					if (y > 0) then
                        flood_aux (x,y-1) time
                    else ()
				)
                fun move_right (x, y) time =
				(
					if (x < width) then
                        flood_aux (x + 1, y) time
                    else ()
				)
                fun move_down (x, y) time =
				(
					if (y < height) then
                        flood_aux (x, y + 1) time
                    else ()
				)
                fun move_left (x, y) time =
				(
					if (x > 0) then
                        flood_aux (x - 1, y) time
                    else ()
				)
				fun move_bundle (x, y) time =
				(
                    move_up (x, y) (time + 2);
                    move_right (x, y) (time + 2);
                    move_down (x, y) (time + 2);
                    move_left (x, y) (time + 2)
				)
            in
              if (current = ~3) then ()
                else if (current = ~2 andalso (!flag) = 0)then
                    let
                        fun iterate_airport_coords [] = ()
                        | iterate_airport_coords ((a, b)::t) =
							if (Array2.sub(arr, b, a) > (current + 5) orelse Array2.sub(arr, b, a) = ~2) then
							(
								flood_aux (a, b) (time + 5);
								iterate_airport_coords t
							)
							else
                            (
								iterate_airport_coords t
							);
                    in
					(
						flag := 1;
						Array2.update(arr, y, x, time);
                        iterate_airport_coords airport_coords;
						move_bundle (x, y) time
					)
                    end
                else if (current = ~1) then
                (
					Array2.update(arr, y, x, time);
					move_bundle (x, y) time
				)
                else if (time < current orelse current = ~2) then
                (
					Array2.update(arr, y, x, time);
					move_bundle (x, y) time
				)
                else ()
            end
    in
        flood_aux outbreak 0;
        arr
    end


(* Uses recursive bfs to find shortest rout *)
fun bfs arr (tr_x, tr_y) (des_x, des_y) height width=
    let
        val times = Array2.array((height + 1), (width + 1), ~1);
        val _ = Array2.update(visited, tr_y, tr_x, true);

        val parent = Array2.array((height + 1), (width + 1), (~1,~1));

        val q = Queue.mkQueue();

        fun whilequeue queue time =
        let
        (
            if (Queue.isEmpty queue) then ()
            else
            (
                val (curr_x, curr_y) = Queue.dequeue queue;
                val curr_value = Array2.sub(arr, curr_y, curr_x)
                val next_queue = Queue.mkQueue();

                fun move_up =
                (
                    if (curr_y > 0) then
                    (
                        let
                            val next_value = Array2.sub(arr, curr_y -1, curr_x)
                        in
                        (
                            if next_value <> ~3 andalso Array2.sub(times, curr_y -1, curr_x)  = 0 andalso time < next_value then
                            (
                                Queue.enqueue next_queue (curr_y -1, curr_x);
                                Array2.update(times, curr_y -1, curr_x, time);
                                Array2.update(parent, curr_y -1, curr_x, (curr_x, curr_y))
                            )
                            else ()
                        )
                        end
                    )
                    else ()
                )
            )
        )
        in
            move_up;
            whilequeue queue time;
            whilequeue next_queue (time + 1)
        end
    in
        bfs_aux whilequeue q
    end

(* main program *)
fun stayhome filename =
    let
        val (outbreak_map, map_width, map_height) = parse filename
        val (outbreak_map, traveler, destination, outbreak, airport_coords) = map_data outbreak_map (map_width-1) (map_height-1)
        val outbreak_map =  flood outbreak_map (map_width-1) (map_height-1) airport_coords outbreak
        (* DEBUG: *)
        (* val _ = print("\nMAP AFTER FLOODING\n");
        val _ = print_d_array_int (outbreak_map) *)
    in
        print("\nSOTOS: ");
        print_coordsln traveler;
        print("HOME: ");
        print_coordsln destination;
		print("OUTBREAK: ");
        print_coordsln outbreak;
		print("AIRPORTS: ");
        print_coord_list airport_coords

    end;

(* stayhome "./tests-input/test1.txt"; *)
stayhome "./tests-input/test2.txt";
(* stayhome "./tests-input/test3.txt"; *)