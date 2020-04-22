(* signature ORD_NODE =
sig
  type node
  val compare : node * node -> order
  val format : node -> string
end

signature GRAPH =
sig
  structure Node : ORD_NODE
  type graph
  val empty : graph

  (* val addEdge : graph * Node.node * Node.node -> graph
  *  addEdge (g, x, y) => g with an edge added from x to y. *)
  val addEdge : graph * Node.node * Node.node -> graph

  val format : graph -> string
end

functor UndirectedGraphFn (Node : ORD_NODE) :> GRAPH =
struct
  structure Node = Node
  structure Key = struct
    type ord_key = Node.node
    val compare = Node.compare
  end
  structure Map = BinaryMapFn(Key)

  type graph = Node.node list Map.map (* Adjacency list *)
  val empty = Map.empty

  fun addEdge (g, x, y) = (* snip *)
  fun format g = (* snip *)
end

structure UDG = UndirectedGraphFn(struct
  type node = int
  val compare = Int.compare
  val format = Int.toString
end)




vector = array(array * n)

fun create_arrays n = (Array.array(n), Array.array)
val (vector,color, mark) = create_arrays vector

fun add_edges vect =

add_edges vector[i].pushback



(* -=========================================================================== *)

(*C++*)
class Graph {
 private:
  int vertices_count;
  int edges_count;
  int index;
  list<int> *adj_lists;
  void dfsCycle(int u, int p, int *color, unsigned *mark, int *par,
                unsigned &cycle_number);
  int countNodes(int n, int p, const set<int> &vertices_in_cycle);

 public:
  Graph(int V, int edges_count, int index = 1);
  ~Graph();
  void addEdge(int v, int w);
  bool findTreesIfCorona(int &trees_count, set<int> &tree_sizes);
};

(*SML*)
structure Graph = struct
  val vertices_count
  val edges_count
  val index
  val Array.adj_lists(1000000,0);
  fun dfsCycle(int u, int p, int *color, unsigned *mark, int *par,
                unsigned &cycle_number)
  fun countNodes(int n, int p, const set<int> &vertices_in_cycle)

  datatype vertex = V of (vertex*int) list ref
  type edge = vertex*vertex*int
  type graph = vertex list

  fun eq(V(v1), V(v2)) = (v1 = v2)
  fun vertices(g) = g
  fun edgeinfo(e) = e
  fun outgoing(V(lr)) = map (fn(dst,w) => (V(lr), dst, w)) (!lr)

  fun add_vertex(g: graph): graph*vertex =
    let val v = V(ref [])
    in (v::g, v) end

  fun add_edge(src: vertex, dst: vertex, weight: int) =
    case src of V(lr) => lr := (dst,weight)::(!lr)
end
inStream *)


fun add_edges u w graph =
    let
        val first = Array.sub(graph, u);
        val second = Array.sub(graph, w)
    in
        Array.update(graph, u, first @ [w]);
        Array.update(graph, w, second @ [u])
    end
