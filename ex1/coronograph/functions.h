#if !defined(FUNCTIONS_)
#define FUNCTIONS_

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
  void dfsUtil(int u, int p, int &cyclenumber, int *color, int *parent,
               int *mark);
  enum Color { WHITE, GRAY, BLACK };

 public:
  Graph(int V, int edges_count, int index = 1);
  ~Graph();
  void addEdge(int v, int w);
  void printGraph();
  void detect_cycle();
};

#endif  // FUNCTIONS_
