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

(* void Graph::dfsCycle(int u, int p, unsigned &cycle_number) {
  if (cycle_number >= 2) return;  (*<---useless *)

  // already (completely) visited vertex.
  if (color[u] == 2) {
	return;
  }

  // seen vertex, but was not completely visited -> cycle detected.
  // backtrack based on parents to find the complete cycle.
  if (color[u] == 1) {
	cycle_number++;
	int cur = p;
	mark[cur] = cycle_number;
	// backtrack the vertex which are
	// in the current cycle thats found
	whileloop (cur != u) {
	  cur = par[cur];
	  mark[cur] = cycle_number;
	}
	return;
  }
  par[u] = p;

  // partially visited.
  color[u] = 1;

  // simple dfs on graph
  for (int v : adj_lists[u]) {
	// if it has not been visited previously
	if (v == par[u]) {
	  continue;
	}
	dfsCycle(v, u, cycle_number);
  }

  // completely visited.
  color[u] = 2;
} *)

(* 
(* FIXME: From Test *)
fun dfs_cycle vertices_count graph=
	let
		val color = (Array.array(vertices_count, 0));
		val mark = (Array.array(vertices_count, 0));
		val par = (Array.array(vertices_count, 0));
		val cycle_number = ref 0;
		val cur = ref 0;

		fun dfs_aux u p graph =
			if (Array.sub(color,u) >= 2) then (!cycle_number, color, mark, par) else (
				if(Array.sub(color,u) = 1) then(
					cycle_number := !cycle_number + 1;
					cur = ref p;
					Array.update(mark, !cur, !cycle_number);
					let
						fun whileloop cur u =
							if (!cur = u) then (!cycle_number, color, mark, par) else
								(cur := Array.sub(par, !cur);
								Array.update(mark, !cur, !cycle_number);
								whileloop cur u)
					in
						whileloop cur u
					end;
					
					(!cycle_number, color, mark, par)

				) else (
					Array.update(par, u, p);
					Array.update(color, u, 1);
					
					let
					val adj_list = Array.sub(graph, u);
					fun iterate_neighbors nil = (!cycle_number, color, mark, par)
						| iterate_neighbors (neighbor::neighbors) = 
							if (u = Array.sub(par, u)) then (!cycle_number, color, mark, par)
							else
								(let 
									val cycle_number = ref 0;
									val (!cycle_number, color, mark, par) = dfs_aux neighbor u graph
								in
									(cycle_number, color, mark, par)
								end )
					in
						iterate_neighbors adj_list
					end;			
					
					Array.update(color, u, 2);
					(!cycle_number, color, mark, par)
					)
			);
	in
		dfs_aux 1 0 graph (* => (cycle_number, color, mark) *)
 	end;
 *)

 use "corona-sml-test.sml";

(*
fun dfs_cycle vertices graph =
let
	val color = Array.array(vertices, 0);
	val mark = Array.array(vertices, 0);
	val par = Array.array(vertices, 0);
  
	val cycle_number = ref 0;	
  
	fun dfs_aux u p graph = 
		if (Array.sub(color,u) >= 2) then () else
		(
			if(Array.sub(color,u) = 1) then
			(
				cycle_number := !cycle_number + 1;
				let 
					val cur = ref p;
				in
				(
					Array.update(mark, !cur, !cycle_number);
					let
						fun whileloop cur u =
							if (!cur = u) then () else
								(
									cur := Array.sub(par, !cur);
									Array.update(mark, !cur, !cycle_number);
									whileloop cur u
								)
					in
						whileloop cur u
					end
				)
				end;
				()
			)
			else 
			(
				Array.update(par, u, p);
				Array.update(color, u, 1);
				
				let
					val adj_list = Array.sub(graph, u);
					fun iterate_neighbors nil = ()
						| iterate_neighbors (neighbor::neighbors) = 
							if (u = Array.sub(par, u)) then ()
							else
								(
									dfs_aux neighbor u graph
								)
				in
					iterate_neighbors adj_list
				end;			
				
				Array.update(color, u, 2);
				()
			)
		)
		
in
	dfs_aux 1 0 graph;
	(cycle_number, color, mark)
end; *)

(* counts nodes in tree *)
fun count_nodes node parent nil vertices_in_cycle graph = 1
| count_nodes node parent (neighbor::neighbors) vertices_in_cycle graph =
	if (neighbor = parent orelse (List.exists (fn x => x = neighbor) vertices_in_cycle)) then
		count_nodes node parent neighbors vertices_in_cycle graph
	else
		count_nodes neighbor node (Array.sub (graph, neighbor)) vertices_in_cycle graph + count_nodes node parent neighbors vertices_in_cycle graph

(* Out of a list of nodes-roots finds the  size of the tree*)
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


(* gets vertices in cycle and prints all the sizes of the trees SORTED*)
fun print_sorted_tree_sizes vertices_in_cycle graph =
	let
		val trees = ListMergeSort.sort (fn (s, t) => s > t) (get_tree_sizes vertices_in_cycle vertices_in_cycle graph)
	in
		print_tree_list trees
	end;


(* counts vertices in cycle and returns them along with the number of trees *)
fun vertices_in_cycle 0 mark = (0, [])
	| vertices_in_cycle index mark = 
	let
		val (a,b) = vertices_in_cycle (index-1) mark
	in
		if (Array.sub(mark, index-1) < 0) then (a+1, b@[index-1])
		else (a, b)
	end; 

fun print_final_output mark vertices graph =
	let
		val (trees_in_cycle, trees) = vertices_in_cycle vertices mark
	in	
		print ("CORONA " ^ (Int.toString(trees_in_cycle)) ^ "\n");
		print_sorted_tree_sizes trees graph
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
				in
					let
					  val (cycle_number, color, mark) = dfs_cycle N graph
					in
						print("CYCLE NUMBER: ");
						print(Int.toString(!cycle_number) ^ "\n");
						print("COLOR: ");
						print_list_other_malakia((Array.toList(color)));
						print("MARK: ");
						print_list_other_malakia((Array.toList(mark)));
						if( (Array.exists (fn x => x = 0) color) orelse (!cycle_number <> 1) ) then print ("NO CORONA\n") 
						else print_final_output mark N graph
					end
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
