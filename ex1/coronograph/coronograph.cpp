

/**************************************************************************
Project     : Programming Languages 1 - Assignment 1 - Exercise 2
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : April 29, 2020.
Description : Coronograph. (C++)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************/

#include <algorithm>
#include <fstream>
#include <list>
#include <set>
#include <vector>
using namespace std;

/*
  Code in Graph::dfsCycle and Graph::printCycles
  is from geeksforgeeks.org (but modified by us)
  ---------------------------------------------------------------------------------
  Title: Print all the cycles in an undirected graph
  Author: Striver
  Link:
  https://www.geeksforgeeks.org/print-all-the-cycles-in-an-undirected-graph/
*/

void read_file(const char *infile);

class Graph {
 private:
  int vertices_count;
  int edges_count;
  int index;
  list<int> *adj_lists;
  int *color;
  int *par;
  unsigned *mark;
  void dfsCycle(int u, int p, unsigned &cycle_number);
  int countNodes(int n, int p, const set<int> &vertices_in_cycle);

 public:
  Graph(int V, int edges_count, int index = 1);
  ~Graph();
  void addEdge(int v, int w);
  bool findTreesIfCorona(int &trees_count, vector<int> &tree_sizes);
};

void is_corona(Graph *g);

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
  vector<int> tree_sizes;
  if (g->findTreesIfCorona(trees_count, tree_sizes) == 1) {
    printf("CORONA %d\n", trees_count);
    sort(tree_sizes.begin(), tree_sizes.end());
    vector<int>::iterator it = tree_sizes.begin();
    while (it != tree_sizes.end()) {
      printf("%d", *it);
      ++it;
      if (it != tree_sizes.end()) printf(" ");
    }
    printf("\n");
  } else {
    printf("NO CORONA\n");
  }
}

Graph::Graph(int V, int edges_count, int index) {
  this->vertices_count = V;
  this->edges_count = edges_count;
  this->index = index;
  adj_lists = new list<int>[V];

  color = new int[vertices_count];
  par = new int[vertices_count];
  mark = new unsigned[vertices_count];

  for (int i = 0; i < vertices_count; ++i) {
    mark[i] = 0;
    color[i] = 0;
  }
}

Graph::~Graph() {
  delete[] adj_lists;
  delete[] color;
  delete[] par;
  delete[] mark;
}

void Graph::addEdge(int v, int w) {
  adj_lists[v - this->index].push_back(w - this->index);
  adj_lists[w - this->index].push_back(v - this->index);
}

int Graph::countNodes(int n, int p, const set<int> &vertices_in_cycle) {
  int count = 1;
  set<int>::iterator it;
  for (int v : adj_lists[n]) {
    if (v == p) continue;

    it = vertices_in_cycle.find(v);
    if (it != vertices_in_cycle.end())
      continue;
    else
      count += countNodes(v, n, vertices_in_cycle);
  }
  return count;
}

/*
Code Graph::dfs_cycle and Graph::printCycles by geeksforgeeks.org (and modified
by us)
---------------------------------------------------------------------------------
Title: Print all the cycles in an undirected graph
Author: Striver
Link: https://www.geeksforgeeks.org/print-all-the-cycles-in-an-undirected-graph/
*/
void Graph::dfsCycle(int u, int p, unsigned &cycle_number) {
  if (cycle_number >= 2) return;

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
    while (cur != u) {
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
}

bool Graph::findTreesIfCorona(int &trees_count, vector<int> &tree_sizes) {
  // arrays required to color the
  // graph, store the parent of node

  // mark with unique numbers

  // store the numbers of cycle
  unsigned cycle_number = 0;

  dfsCycle(1, 0, cycle_number);

  if (cycle_number != 1) {
    return false;
  }
  for (int i = 0; i < vertices_count; i++) {
    if (color[i] == 0) {
      return false;
    }
  }
  set<int> vertices_in_cycle;
  for (int i = 0; i < vertices_count; ++i) {
    if (mark[i] != 0) {
      trees_count++;
      vertices_in_cycle.insert(i);
    }
  }
  // count tree nodes...
  set<int>::iterator it;
  for (it = vertices_in_cycle.begin(); it != vertices_in_cycle.end(); ++it)
    tree_sizes.push_back(countNodes(*it, -1, vertices_in_cycle));
  return true;
}
