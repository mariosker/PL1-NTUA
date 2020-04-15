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
  list<int> *adj_list;
  // void dfsUtil(int u, int *color, int *parent);
  enum Color { WHITE, GRAY, BLACK };

 public:
  Graph(int V, int edges_count, int index = 1);
  ~Graph();
  void addEdge(int v, int w);
  void printGraph();
  void find_cycle();
  bool dfs(int v, vector<char> &color, vector<int> &parent, int &cycle_start,
           int &cycle_end);
};

#endif  // FUNCTIONS_
