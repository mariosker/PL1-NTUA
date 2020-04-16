#if !defined(FUNCTIONS_)
#define FUNCTIONS_

#include <algorithm>
#include <fstream>
#include <iostream>
#include <list>
#include <set>
#include <vector>
using namespace std;

void read_file(const char *infile);

class Graph {
 private:
  int vertices_count;
  int edges_count;
  int index;
  list<int> *adj_lists;
  void dfsCycle(int u, int p, int *color, int *mark, int *par,
                int &cyclenumber);
  int countNodes(int n, int p, const set<int> &cycle);

 public:
  Graph(int V, int edges_count, int index = 1);
  ~Graph();
  void addEdge(int v, int w);
  bool printCycles(int &trees_count, set<int> &tree_sizes);
};

void is_corona(Graph *g);
#endif  // FUNCTIONS_
