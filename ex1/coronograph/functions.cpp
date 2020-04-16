#include <algorithm>
#include <fstream>
#include <iostream>
#include <list>
#include <set>
#include <vector>
using namespace std;

void read_file(const char *infile) {
  FILE *fp = fopen(infile, "r");
  int graph_count, vertices_count, edges_count, vertex1, vertex2;

  if (fp == NULL) {
    printf("Error reading file: %s", infile);
    exit(EXIT_FAILURE);
  }

  if (!fscanf(fp, "%d", &graph_count)) {
    printf("Error reading file\n");
    exit(EXIT_FAILURE);
  }

  for (int i = 0; i < graph_count; ++i) {
    if (!fscanf(fp, "%d %d", &vertices_count, &edges_count)) {
      printf("Error reading file\n");
      exit(EXIT_FAILURE);
    }

    Graph *graph = new Graph(vertices_count, edges_count);

    for (int i = 0; i < edges_count; ++i) {
      if (!fscanf(fp, "%d %d", &vertex1, &vertex2)) {
        printf("Error reading file\n");
        exit(EXIT_FAILURE);
      }

      graph->addEdge(vertex1, vertex2);
    }

    is_corona(graph);

    delete graph;
  }
  fclose(fp);
}

void is_corona(Graph *g) {
  int trees_count = 0;
  set<int> tree_sizes;
  if (g->printCycles(trees_count, tree_sizes) == 1) {
    printf("CORONA %d\n", trees_count);
    set<int>::iterator it;
    for (it = tree_sizes.begin(); it != tree_sizes.end(); ++it)
      printf("%d ", *it);
    printf("\n");
  } else {
    printf("NO CORONA\n");
  }
}

Graph::Graph(int V, int edges_count, int index) {
  this->vertices_count = V;
  this->edges_count = edges_count;
  this->index = index;
  adj_list = new list<int>[V];
}

Graph::~Graph() { delete[] adj_list; }

void Graph::addEdge(int v, int w) {
  adj_list[v - this->index].push_back(w - this->index);
  adj_list[w - this->index].push_back(v - this->index);
}

int Graph::countNodes(int n, int p, const set<int> &cycle) {
  int count = 1;
  set<int>::iterator it;
  for (int v : adj_list[n]) {
    if (v == p) continue;

    it = cycle.find(v);
    if (it != cycle.end())
      continue;
    else
      count += countNodes(v, n, cycle);
  }
  return count;
}

// Function to mark the vertex with
// different colors for different cycles
void Graph::dfs_cycle(int u, int p, int *color, int *mark, int *par,
                      int &cyclenumber) {
  // already (completely) visited vertex.
  if (color[u] == 2) {
    return;
  }

  // seen vertex, but was not completely visited -> cycle detected.
  // backtrack based on parents to find the complete cycle.
  if (color[u] == 1) {
    cyclenumber++;
    int cur = p;
    mark[cur] = cyclenumber;

    // backtrack the vertex which are
    // in the current cycle thats found
    while (cur != u) {
      cur = par[cur];
      mark[cur] = cyclenumber;
    }
    return;
  }
  par[u] = p;

  // partially visited.
  color[u] = 1;

  // simple dfs on graph
  for (int v : adj_list[u]) {
    // if it has not been visited previously
    if (v == par[u]) {
      continue;
    }
    dfs_cycle(v, u, color, mark, par, cyclenumber);
  }

  // completely visited.
  color[u] = 2;
}

bool Graph::printCycles(int &trees_count, set<int> &tree_sizes) {
  // push the edges that into the
  // cycle adjacency list

  // arrays required to color the
  // graph, store the parent of node
  int color[vertices_count];
  int par[vertices_count];

  // mark with unique numbers
  int mark[vertices_count];
  for (int i = 0; i < vertices_count; i++) {
    mark[i] = 0;
    color[i] = 0;
  }
  // store the numbers of cycle
  int cyclenumber = 0;

  dfs_cycle(1, 0, color, mark, par, cyclenumber);

  if (cyclenumber != 1) return false;
  for (int i = 0; i < vertices_count; i++) {
    if (color[i] == 0) return false;
  }

  set<int> cycle;
  for (int i = 0; i < vertices_count; i++) {
    if (mark[i] != 0) {
      trees_count++;
      cycle.insert(i);
    }
  }
  // count tree nodes...
  set<int>::iterator it;
  for (it = cycle.begin(); it != cycle.end(); ++it)
    tree_sizes.insert(countNodes(*it, -1, cycle));
  return true;
}
