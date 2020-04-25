fun print_list_other_malakia lst =
	let
		fun print_aux nil = print "]\n"
			| print_aux (h::[]) = (print (Int.toString(h)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h)); print ","; print_aux t);
	in
		print "[";
		print_aux (lst)
	end;


(* fun dfs_cycle vertices graph =
let
	val color = Array.array(vertices, 0);
	val mark = Array.array(vertices, 0);
	val par = Array.array(vertices, 0);

	val cycle_number = 0;

	fun troll n =
	let
		fun add_one x = x + 1;
		val y = add_one n
	in
		y
	end

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

				troll cycle_number;

				(*FIXME:*)print("cycle_number: " ^ Int.toString(cycle_number) ^ "\n");

				Array.update(mark, p, cycle_number);

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
									(* FIXME: Start *)
									print("-----Debug#2i: cur : " ^ (Int.toString(!cur)) ^ " ");
									print_list_other_malakia ((Array.toList(mark)));
									(* FIXME: End *)
									cur := Array.sub(par, !cur);
									Array.update(mark, !cur, cycle_number);
									whileloop cur u
								)
							else ()
					in
						whileloop cur u
					end
				)
				end;
				(* FIXME PAPA: Start *)
				print("------Debug#3: ");
				print_list_other_malakia ((Array.toList(mark)));
				(* FIXME: End : I like it when you call me your whore :) *)
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
									(* FIXME DADDY: Start *)
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
	dfs_aux 1 0 graph;
	(cycle_number, color, mark)
end; *)


fun dfs_cycle vertices graph =
let
	val visited = Array.array(vertices, 0); (*its like color*)
	val parent = Array.array(vertices, ~1);
	val cycle = Array.array(vertices,0);  (*its like mark*)

	fun dfs_util v par graph =
		if (Array.sub(visited, v) <> 0) then
		(	
			Array.update(visited, v, 2);
			0
		)
		else
		(
			Array.update(visited, v, 1);
			Array.update(parent, v, par);

			let
				val adj_list = Array.sub(graph, v);
				fun iterate_neighbors nil = 0
					| iterate_neighbors (neighbor::neighbors) =
						if (Array.sub(visited, neighbor) = 0) then
						(
							let
								val res = iterate_neighbors neighbors
							in
								if (res > 1) then 2 else
								(dfs_util neighbor v graph) + (res)
							end
						)
						else
						(
							if (par <> neighbor ) then
							(
								let
									fun whileloop cur neighbor =
										if (cur <> neighbor) then
										(
											Array.update(cycle, cur, 1);
											whileloop (Array.sub(parent, cur)) neighbor
										)
										else ()
								in
									Array.update(cycle, neighbor, 1);
									whileloop v neighbor;

									let
										val res = iterate_neighbors neighbors
									in
										if (res > 1) then 2 else
											1 + res
									end
								end
							)
							else
							(
								let
									val res = iterate_neighbors neighbors
								in
									if (res > 1) then 2 else
										res
								end
							)
						)
			in
				iterate_neighbors adj_list
			end
		);
		val y = dfs_util 0 1 graph
in
	(y,visited,cycle)
end
