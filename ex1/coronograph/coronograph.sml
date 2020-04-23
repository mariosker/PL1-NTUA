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


(* print a list as [x,x,x,x] *)
fun print_list lst =
	let
		fun print_aux nil = print "]\n"
			| print_aux (h::[]) = (print (Int.toString(h+1)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h+1)); print ","; print_aux t);
	in
		print "[";
		print_aux lst
	end;


(* print a list as [x,x,x,x] *)
fun print_tree_list lst =
	let
		fun print_aux nil = print "\n"
			| print_aux (h::[]) = (print (Int.toString(h)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h)); print " "; print_aux t);
	in
		print_aux lst
	end;


(* print graph having given length *)
fun print_graph graph len n =
		if n = len
		then ()
		else
		(
			print ("vertice " ^ Int.toString (n+1) ^ " -> ");
			print_list (Array.sub(graph, n));
			print_graph graph len (n+1)
		);

(* void is_corona(Graph *g) {
  int trees_count = 0;
  set<int> tree_sizes;
  if (g->findTreesIfCorona(trees_count, tree_sizes) == 1) {
    printf("CORONA %d\n", trees_count);
    set<int>::iterator it = tree_sizes.begin();
    while (it != tree_sizes.end()) {
      printf("%d", *it);
      ++it;
      if (it != tree_sizes.end()) printf(" ");
    }
    printf("\n");
  } else {
    printf("NO CORONA\n");
  }
} *)


(* counts nodes in tree *)
fun count_nodes node parent nil vertices_in_cycle graph = 1
| count_nodes node parent (neighbor::neighbors) vertices_in_cycle graph =
	if (neighbor = parent orelse (List.exists (fn x => x = neighbor) vertices_in_cycle)) then
		count_nodes node parent neighbors vertices_in_cycle graph
	else
		count_nodes neighbor node (Array.sub (graph, neighbor)) vertices_in_cycle graph + count_nodes node parent neighbors vertices_in_cycle graph



fun get_tree_sizes nil vertices_in_cycle graph = []
	| get_tree_sizes (h::[]) vertices_in_cycle graph =
		let
			val node = h;
			val parent = ~1;
			val neighbors = Array.sub (graph, node);
			val nodes_count = count_nodes node parent neighbors vertices_in_cycle graph
		in
			[nodes_count]@ get_tree_sizes [] vertices_in_cycle graph
		end
	| get_tree_sizes (h::nodes_in_cycle) vertices_in_cycle graph =
	let
		val node = h;
		val parent = ~1;
		val neighbors = Array.sub (graph, node);
		val nodes_count = count_nodes node parent neighbors vertices_in_cycle graph
	in
		[nodes_count] @ get_tree_sizes nodes_in_cycle vertices_in_cycle graph
	end;


fun print_sorted_tree_sizes vertices_in_cycle graph =
	let
		val trees = ListMergeSort.sort (fn (s, t) => s > t) (get_tree_sizes vertices_in_cycle vertices_in_cycle graph)
	in
		print_tree_list trees
	end;


(* read file and get graph *)
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
					val (N, graph) = read_graph inStream;
					val vertices_in_cycle = [0, 3, 4];
				in
					print ("\nGRAPH #" ^ Int.toString (T-i) ^ "\n");
					print_graph graph N 0;
					print_sorted_tree_sizes vertices_in_cycle graph
				end;
				scan_test (i-1)
			)
	in
		(scan_test T)
	end;


(* caller function *)
fun coronograph filename =
	parse filename;

(* run test *)
parse "test.txt";
