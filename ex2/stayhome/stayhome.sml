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

fun print_dim_array_int arr =
	let
		val (dimy,dimx) =Array2.dimensions arr
		fun  print_dim_array_int_aux arr height width h w =
			if h >= height then () else(
				if w >= width then (
					print("\n");
					print_dim_array_int_aux arr height width (h+1) 0)
				else(
					print_coords (Array2.sub(arr,h,w));
					print_dim_array_int_aux arr height width h (w+1))
			)
	in(
		print_dim_array_int_aux arr (dimy) (dimx) 0 0;
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

fun bfs arr (tr_x, tr_y) (des_x, des_y) height width =
    let
        val q = Queue.mkQueue();
        val times = Array2.array((height + 1), (width + 1), ~1);
        val parent = Array2.array((height + 1), (width + 1), (~1,~1));
        val found = ref false;


        val _ = Array2.update(times, tr_y, tr_x, 0);
        val _ = Queue.enqueue(q, (tr_x, tr_y))

        (* backtracks from the parent list and prints the moves of the traveler *)
        fun backtrack (in_x, in_y) =
            if in_x = tr_x andalso in_y = tr_y then [] else
                let
                    val (d_x, d_y) = Array2.sub(parent, in_y, in_x)
                in
                    if (d_x = in_x) then
                    (
                        if (d_y > in_y) then
                        (
                            "U"::(backtrack (d_x, d_y))
                        )
                        else
                        (
                            "D"::(backtrack (d_x, d_y))
                        )
                    )
                    else
                    (
                        if (d_x > in_x) then
                        (
                            "L"::(backtrack (d_x, d_y))
                        )
                        else
                        (
                            "R"::(backtrack (d_x, d_y))
                        )
                    )
                end


        fun bfs_aux queue time =
        let
            fun whilequeue queue next_queue time =
                if (Queue.isEmpty queue orelse !found = true) then (
                    if ((Queue.isEmpty next_queue) = false) then
                    whilequeue next_queue (Queue.mkQueue()) (time+1)
                    else ()
                    )
                else
                (
                    let
                        val (cur_x, cur_y) = Queue.dequeue queue
                        fun move_up z =
                        (
                            if (cur_y > 0) then
                            (
                                let
                                    val next_value = Array2.sub(arr, cur_y -1, cur_x)
                                in
                                (
                                    if (next_value <> ~3 andalso Array2.sub(times, cur_y -1, cur_x)  = ~1 andalso (time+1) < next_value) then
                                    (
                                        Queue.enqueue (next_queue, (cur_x, cur_y -1));
                                        Array2.update(times, cur_y -1, cur_x, time);
                                        Array2.update(parent, cur_y -1, cur_x, (cur_x, cur_y))
                                    )
                                    else ()
                                )
                                end
                            )
                            else ()
                        )
                        fun move_down z =
                        (
                            if (cur_y < height) then
                            (
                                let
                                    val next_value = Array2.sub(arr, cur_y +1, cur_x)
                                in
                                (
                                    if (next_value <> ~3 andalso Array2.sub(times, cur_y +1, cur_x)  = ~1 andalso (time+1) < next_value) then
                                    (
                                        Queue.enqueue (next_queue, (cur_x, cur_y +1));
                                        Array2.update(times, cur_y +1, cur_x, time);
                                        Array2.update(parent, cur_y +1, cur_x, (cur_x, cur_y))
                                    )
                                    else ()
                                )
                                end
                            )
                            else ()
                        )
                        fun move_left z =
                        (
                            if (cur_x > 0) then
                            (
                                let
                                    val next_value = Array2.sub(arr, cur_y, cur_x - 1)
                                in
                                (
                                    if (next_value <> ~3 andalso Array2.sub(times, cur_y, cur_x - 1)  = ~1 andalso (time+1) < next_value) then
                                    (
                                        Queue.enqueue (next_queue, (cur_x - 1, cur_y));
                                        Array2.update(times, cur_y, cur_x, time - 1);
                                        Array2.update(parent, cur_y, cur_x - 1, (cur_x, cur_y))
                                    )
                                    else ()
                                )
                                end
                            )
                            else ()
                        )
                        fun move_right z =
                        (
                            if (cur_x < width) then
                            (
                                let
                                    val next_value = Array2.sub(arr, cur_y, cur_x + 1)
                                in
                                (
                                    if (next_value <> ~3 andalso Array2.sub(times, cur_y, cur_x + 1)  = ~1 andalso (time + 1) < next_value) then
                                    (
                                        Queue.enqueue (next_queue, ( cur_x + 1, cur_y));
                                        Array2.update(times, cur_y, cur_x + 1, time);
                                        Array2.update(parent, cur_y, cur_x + 1, (cur_x, cur_y))
                                    )
                                    else ()
                                )
                                end
                            )
                            else ()
                        )
                    in
                        if (cur_x = des_x andalso cur_y = des_y) then (
                            found := true;
                            print((Int.toString (time)) ^ "\n");
                            print((String.concat (rev (backtrack (des_x, des_y)))) ^ "\n")
                        ) else
                        (
                            move_down 0;
                            move_left 0;
                            move_right 0;
                            move_up 0;
                            whilequeue queue next_queue time
                        )
                    end
                )
        in
            whilequeue queue (Queue.mkQueue()) 0
        end

    in
        bfs_aux q 0;
        if !found = false then
                print("IMPOSSIBLE\n")
        else ()
    end

(*
1 procedure BFS(G, start_v) is
2 let Q be a queue
3 label start_v as discovered
4 Q.enqueue(start_v)
5 while Q is not empty do
6 v := Q.dequeue()
7 if v is the goal then
8 return v
9 for all edges from v to w in G.adjacentEdges(v) do
10 if w is not labeled as discovered then
11 label w as discovered
12 w.parent := v
13 Q.enqueue( w)
*)


(* main program *)
fun stayhome filename =
    let
        val (outbreak_map, map_width, map_height) = parse filename
        val (outbreak_map, traveler, destination, outbreak, airport_coords) = map_data outbreak_map (map_width-1) (map_height-1)
        val outbreak_map =  flood outbreak_map (map_width-1) (map_height-1) airport_coords outbreak
    in
        bfs outbreak_map traveler destination (map_height-1) (map_width-1)
    end;

stayhome "./tests-input/test1.txt";
stayhome "./tests-input/test2.txt";
stayhome "./tests-input/test3.txt";
(* stayhome "./tests-input/bigtest.txt"; *)