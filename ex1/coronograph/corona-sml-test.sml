fun print_list_other_malakia lst =
	let
		fun print_aux nil = print "]\n"
			| print_aux (h::[]) = (print (Int.toString(h)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h)); print ","; print_aux t);
	in
		print "[";
		print_aux lst
	end;


fun dfs_cycle vertices graph =
let
	val color = Array.array(vertices, 0);
	val mark = Array.array(vertices, 0);
	val par = Array.array(vertices, 0);
  
	val cycle_number = ref 0;
	val a = ref 0;
	
	fun dfs_aux u p graph = 
		if (Array.sub(color,u) = 2) then () else
		(
			
			(* FIXME: Start *)
			print("Debug#0: u:" ^ Int.toString(u)^" p:"^ Int.toString(p) ^" ");
			print_list_other_malakia ((Array.toList(mark)));
			(* FIXME: End *)
			
			if(Array.sub(color,u) = 1) then
			(
				
				(* FIXME: Start *)
				print("--Debug#1: ");
				print_list_other_malakia ((Array.toList(mark)));
				(* FIXME: End *)
				
				cycle_number := !cycle_number + 1;
				Array.update(mark, p, !cycle_number);
		
				(* FIXME: Start *)
				print("----Debug#2: ");
				print_list_other_malakia ((Array.toList(mark)));
				(* FIXME: End *)
		
				let 
					val cur = ref p;
				in
				(
					let
						fun whileloop cur u =
							if (!cur <> u) then
								(
									cur := Array.sub(par, !cur);
									Array.update(mark, !cur, !cycle_number);
									whileloop cur u
								)
							else ()
					in
						whileloop cur u
					end
				)
				end;
				(* FIXME: Start *)
				print("------Debug#3: ");
				print_list_other_malakia ((Array.toList(mark)));
				(* FIXME: End *)
				()
			)
			else
			(
				
				(* FIXME: Start *)
				print("--------Debug#4: ");
				print_list_other_malakia ((Array.toList(mark)));
				(* FIXME: End *)
				
				Array.update(par, u, p);
				Array.update(color, u, 1);
				
				let
					val adj_list = Array.sub(graph, u);
					fun iterate_neighbors nil = ()
						| iterate_neighbors (neighbor::neighbors) = 
							if (u = Array.sub(par, u)) then iterate_neighbors neighbors
							else
								(
									(* FIXME: Start *)
									print("---------Debug#4i: v: " ^ Int.toString(neighbor) ^ " ");
									print_list_other_malakia ((Array.toList(mark)));
									(* FIXME: End *)
									dfs_aux neighbor u graph;
									iterate_neighbors neighbors
								)
				in
					iterate_neighbors adj_list
				end
			);
							Array.update(color, u, 2);
				(* FIXME: Start *)
				print("----------Debug#5: ");
				print_list_other_malakia ((Array.toList(mark)));
				(* FIXME: End *)
			()
		);
		
in
	print("============DFS============\n");
	dfs_aux 1 0 graph;
	print("===========================\n");
	(cycle_number, color, mark)
end;
