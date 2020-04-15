#include <bits/stdc++.h>

#include <fstream>
#include <iostream>
#include <list>
#include <vector>

const int N = 100000;

using namespace std;

void read_file(const char *infile);

class Graph {
 private:
  void dfs_cycle(int u, int p, int color[], int mark[], int par[],
                 int &cyclenumber);
  int vertices_count;
  list<int> *adj_lists;

 public:
  Graph(int V);
  ~Graph();
  void addEdge(int v, int w);
  int cyclenumber;
  int mark[];
  void printCycles(int edges, int mark[], int &cyclenumber);
};

int main(int argc, char const *argv[]) {
  if (argc < 2) {
    printf("Program requires arguments");
    exit(EXIT_FAILURE);
  } else {
    for (int i = 1; i < argc; ++i) read_file(argv[i]);
  }

  return 0;
}

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

    // TODO: init graph
    Graph *graph = new Graph(vertices_count);

    for (int i = 0; i < edges_count; ++i) {
      if (!fscanf(fp, "%d %d", &vertex1, &vertex2)) {
        printf("Error reading file\n");
        exit(EXIT_FAILURE);
      }

      // TODO: add edge
      graph->addEdge(vertex1, vertex2);
    }
    // TODO: call solver function
    graph->printCycles(edges_count, graph->mark, graph->cyclenumber);
    // for (int v : graph->find_cycle())
    //   cout << v << " ";

    // TODO: delete graph
    delete graph;
  }
  fclose(fp);
}

Graph::Graph(int V) {
  this->vertices_count = V;
  this->adj_lists = new list<int>[V];
}

Graph::~Graph() { delete[] adj_lists; }

// add the edges to the graph
void Graph::addEdge(int v, int w) {
  this->adj_lists[v - 1].push_front(w - 1);
  this->adj_lists[w - 1].push_front(v - 1);
}

// Function to mark the vertex with
// different colors for different cycles
void Graph::dfs_cycle(int u, int p, int color[], int mark[], int par[],
                      int &cyclenumber) {
  vector<int> graph[N];
  vector<int> cycles[N];
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
  for (int v : graph[u]) {
    // if it has not been visited previously
    if (v == par[u]) {
      continue;
    }
    dfs_cycle(v, u, color, mark, par, cyclenumber);
  }

  // completely visited.
  color[u] = 2;
}

// Function to print the cycles
void Graph::printCycles(int vertices_count, int mark[], int &cyclenumber) {
  vector<int> graph[N];
  vector<int> cycles[N];

  // push the edges that into the
  // cycle adjacency list
  for (int i = 1; i <= this->vertices_count; i++) {
    if (mark[i] != 0) cycles[mark[i]].push_back(i);
  }

  // print all the vertex with same cycle
  for (int i = 1; i <= cyclenumber; i++) {
    // Print the i-th cycle
    cout << "Cycle Number " << i << ": ";
    for (int x : cycles[i]) cout << x << " ";
    cout << endl;
  }
}
