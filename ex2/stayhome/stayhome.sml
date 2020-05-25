(**************************************************************************
Project     : Programming Languages 1 - Assignment 2 - Exercise 3
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 25, 2020.
Description : Stayhome. (SML)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************)

(* returns first element of a pair*)
fun f_pair (a,_) = a

(* returns second element of a pair*)
fun s_pair (_,b) = b

(*
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
*)

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
    val reached_airport = ref false
    val spreaded_to_all_airports = ref false
    val queue = Queue.mkQueue()

    val (x,y) = outbreak
    val _ = Queue.enqueue(queue, (y, x, 0))
    val _ = Array2.update(arr, y, x , 0)
    fun move (y, x) time=
        let
            val next_value = Array2.sub(arr, y, x)
        in
            if next_value <> ~3 then
            (
                if (next_value < 0) orelse (time < next_value) then
                (
                    if next_value = ~2 then
                    (
                        reached_airport := true;
                        Queue.enqueue(queue, (y, x, time));
                        Array2.update(arr, y, x, time)
                    )
                    else
                    (
                        Queue.enqueue(queue, (y, x, time));
                        Array2.update(arr, y, x , time)
                    )
                )
                else ()
            )
            else ()
        end

    fun aeroplana time =
        if !spreaded_to_all_airports = false then
        (
            if !reached_airport = true then
            (
                let
                fun iterate_airport_coords [] = ()
                |   iterate_airport_coords ((x, y)::t) =
                    let
                        val next_airport = Array2.sub(arr, y, x)
                    in
                        if next_airport > (time + 5) orelse next_airport < 0 then
                        (
                            Array2.update(arr, y, x, (time + 5));
                            Queue.enqueue(queue,(y, x, (time+5)));
                            iterate_airport_coords t
                        )
                        else
                        (
                            Queue.enqueue(queue,(y, x, (time+5)));
                            iterate_airport_coords t
                        )
                    end
                in
                    (* print("AIRPORT\n"); *)
                    iterate_airport_coords airport_coords;
                    spreaded_to_all_airports := true
                end
            )
            else ()
        )
        else()

        fun move_up (y, x) timey =
        (
            if (y > 0) then(
                (* print("up\n"); *)
                move (y-1, x) timey)
            else ()
        )
        fun move_right (y, x) timey =
        (
            if (x < width) then(
                (* print("right\n"); *)
                move (y, x+1) timey)
            else ()
        )
        fun move_down (y, x) timey =
        (
            if (y < height) then(
                (* print("down\n"); *)
                move (y+1, x) timey)
            else ()
        )
        fun move_left (y, x) timey =
        (
            if (x > 0) then
            (    (* (print("left\n"); *)
                move (y, x-1) timey)
            else ()
        )

    fun whilequeue time=
        if (Queue.isEmpty queue) then ()
        else
        (
            aeroplana time;
            let
                val (y, x, time) = Queue.dequeue queue
            in
                move_up (y, x) (time+2);
                move_right (y, x) (time+2);
                move_down (y, x) (time+2);
                move_left (y, x) (time+2);
                whilequeue (time+2)
            end
        )
in
    whilequeue 0;
    arr
end

(* Uses a bfs algorithm to find the shortest path to reach the
traveller's destination. We used the algorithm written in the
MITopencourses site and modified it.
link:[https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/] *)
fun bfs arr (tr_x, tr_y) (des_x, des_y) height width =
let
    val q = Queue.mkQueue();
    val times = Array2.array((height + 1), (width + 1), ~1);
    val parent = Array2.array((height + 1), (width + 1), (~1,~1));

    (* backtracks from the parent list and prints the moves of the traveler *)
    fun backtrack (in_y, in_x) =
        if in_x = tr_x andalso in_y = tr_y then [] else
            let
                (* val _ = print_coordsln(in_x,in_y) *)
                val (d_y, d_x) = Array2.sub(parent, in_y, in_x)
            in
                if (d_x = in_x) then
                (
                    if (d_y > in_y) then
                    (
                        "U"::(backtrack (d_y, d_x))
                    )
                    else
                    (
                        "D"::(backtrack (d_y, d_x))
                    )
                )
                else
                (
                    if (d_x > in_x) then
                    (
                        "L"::(backtrack (d_y, d_x))
                    )
                    else
                    (
                        "R"::(backtrack (d_y, d_x))
                    )
                )
            end

    fun whilequeue queue tt =
    let
        val next_queue = Queue.mkQueue()

        fun iteratequeue que time =
            if (Queue.isEmpty que) = true then ()
            else (
                let
                    val (cur_y, cur_x) = Queue.dequeue que

                    fun move y x t =
                    let
                        val next_value = Array2.sub(arr, y, x)
                    in
                    (
                        if next_value <> ~3 then
                        (
                            if ((Array2.sub(times, y, x) = ~1) andalso (t < next_value)) then
                            (
                                Array2.update(times, y, x, t);
                                Array2.update(parent, y, x, (cur_y, cur_x));
                                Queue.enqueue (next_queue, (y,x))
                            ) else ()
                        ) else ()
                    )
                    end

                    val _ = if (cur_y < height) then
                    (
                        (* print("d\n"); *)
                        (move (cur_y+1) cur_x time);
                        ()
                    )
                    else ()

                    val _ = if (cur_x > 0) then
                    (
                        (* print("l\n"); *)
                    (move cur_y (cur_x-1) time);
                    ()
                    )
                    else ()

                    val _ = if (cur_x < width) then
                    (
                        (* print("r\n"); *)
                    (move cur_y (cur_x+1) time);
                    ()
                    )
                    else ()

                    val _ = if (cur_y > 0) then
                    (
                        (* print("u\n"); *)
                    (move (cur_y-1) cur_x time);
                    ()
                    )
                    else ()
                in

                    iteratequeue que time
                end
            )

    in
        if (Queue.isEmpty queue) = true then ()
        else(
            iteratequeue queue tt;
            whilequeue next_queue (tt + 1)
        )
    end
in
    Array2.update(times, tr_y, tr_x, 0);
    Queue.enqueue(q, (tr_y, tr_x));
    whilequeue q 1;

    if (Array2.sub(parent, des_y, des_x)) = (~1, ~1) then
    (
        print("IMPOSSIBLE\n")
    )
    else
    (
        print(Int.toString(Array2.sub(times, des_y, des_x)) ^ "\n");
        print((String.concat (rev (backtrack (des_y, des_x)))) ^ "\n")
    )
end


(* main program *)
fun stayhome filename =
    let
        val (outbreak_map, map_width, map_height) = parse filename
        val (outbreak_map, traveler, destination, outbreak, airport_coords) = map_data outbreak_map (map_width-1) (map_height-1)
        val outbreak_map =  flood outbreak_map (map_width-1) (map_height-1) airport_coords outbreak
    in
        bfs outbreak_map traveler destination (map_height-1) (map_width-1)
    end;
