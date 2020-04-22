(**************************************************************************
Project     : Programming Languages 1 - Assignment 1 - Exercise 2
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
			  Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : April 29, 2020.
Description : Coronograph. (SML)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************)

(* adds edges to graph *)
fun add_edges u w graph =
	let
		val first = Array.sub(graph, (u-1));
		val second = Array.sub(graph, (w-1))
	in
		Array.update(graph, (u-1), first @ [(w-1)]);
		Array.update(graph, (w-1), second @ [(u-1)]);
		graph
	end;

(*Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
(* Function to read an integer from an input stream *)
fun next_int input =
	Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

(* read graph eges and add them to graph *)
fun read_edges 0 inStream graph = graph
	| read_edges k inStream graph =
		let
			val u = next_int inStream
			val w = next_int inStream
			val _ = TextIO.inputLine inStream
		in
			read_edges (k-1) inStream (add_edges u w graph)
		end

(* read graph properties and return graph *)
fun read_graph inStream =
	let
		val N = next_int inStream
		val M = next_int inStream
		val _ = TextIO.inputLine inStream
		val graph = read_edges M inStream (Array.array(N, []))
	in
		(N, graph)
	end;


fun print_list lst =
	let
		fun print_aux nil = print "]\n"
			| print_aux (h::[]) = (print (Int.toString(h+1)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h+1)); print ","; print_aux t);
	in
		print "[";
		print_aux lst
	end;

fun print_graph graph len =
		if len = 0
		then ()
		else
		(
			print_list (Array.sub(graph, len-1));
			print_graph graph (len-1)
		);


fun parse file =
	let
		(* Open input file. *)
		val inStream = TextIO.openIn file

		(* Read an integer and consume newline. *)
		val T = next_int inStream (* reads the number of test cases *)
		val _ = TextIO.inputLine inStream

		fun scan_test 0 = ()
		 | scan_test i =
			(
				let
					val (N, graph) = read_graph inStream
				in
					print ("TEST #" ^ Int.toString (T-i) ^ "\n");
					print_graph graph N;
					print ("TEST END#" ^ Int.toString (T-i) ^ "\n")
				end;
				scan_test (i-1)
			)
	in
		(scan_test T)
	end;


parse "corona.txt";

fun coronograph filename =
	parse filename;
