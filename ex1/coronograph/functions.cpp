#include "functions.h"

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

    // TODO: Delete bellow
    graph->printGraph();
    graph->detect_cycle();

    delete graph;
  }
  fclose(fp);
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

void Graph::printGraph() {
  for (int i = 0; i < vertices_count; i++) {
    printf("%d-> [ ", i + index);

    for (int v : adj_list[i]) printf("%d ", v + index);
    printf("]\n");
  }
}

void Graph::dfsUtil(int u, int p, int &cyclenumber, int *color, int *parent,
                    int *mark) {
  if (color[u] == BLACK) return;  // it is a visited vertex

  if (color[u] == GRAY) {  // we have a cycle
    cyclenumber++;
    int cur = p;

    mark[cur] = cyclenumber;

    while (cur != u) {
      cur = parent[cur];
      mark[cur] = cyclenumber;
    }
    return;
  }

  // it is not yet initialized
  parent[u] = p;
  color[u] = GRAY;

  list<int>::iterator i;
  for (i = adj_list[u].begin(); i != adj_list[u].end(); ++i) {
    int v = *i;

    if (parent[u] == v) continue;

    dfsUtil(v, u, cyclenumber, color, parent, mark);
  }

  color[u] = BLACK;
  return;
}

void Graph::detect_cycle() {
  int cyclenumber = 0;

  vector<int> cycles[edges_count];

  int color[vertices_count];
  int parent[vertices_count];
  int mark[vertices_count];
  for (int i = 0; i < vertices_count; ++i) {
    color[i] = WHITE;
    mark[i] = 0;
  }

  dfsUtil(0, 3, cyclenumber, color, parent, mark);

  if (cyclenumber == 0)
    printf("NO CYCLE\n");
  else {
    printf("CYLCE %d\n", cyclenumber);
  }
}
