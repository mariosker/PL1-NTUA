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

void Graph::dfs_cycle(int u, int p, int &cycle_number, vector<int> &color,
                      vector<int> &mark, vector<int> &parent) {
  // completely visited vertex.
  if (color[u] == 2) return;

  // seen vertex, but was not completely visited -> cycle detected.
  // backtrack based on parents to find the complete cycle.
  if (color[u] == 1) {
    cycle_number++;
    int cur = p;
    mark[cur] = cycle_number;

    // backtrack the vertex which are
    // in the current cycle thats found
    while (cur != u) {
      cur = parent[cur];
      mark[cur] = cycle_number;
    }
    return;
  }

  parent[u] = p;
  color[u] = 1;  // partially visited

  // simple dfs on graph
  for (int v : adj_list[u]) {
    // if it has not been visited previously
    if (v == parent[u]) {
      continue;
    }
    dfs_cycle(v, u, cycle_number, color, mark, parent);
  }

  // completely visited.
  color[u] = 2;
}

void Graph::detect_cycle() {
  vector<int> color(vertices_count, 0);
  vector<int> mark(vertices_count, 0);
  vector<int> parent(vertices_count, 0);

  vector<int> cycles[vertices_count];

  int cycle_number = 0;

  dfs_cycle(1, 0, cycle_number, color, mark, parent);

  for (int i = 0; i < edges_count; i++) {
    if (mark[i] != 0) cycles[mark[i]].push_back(i);
  }

  for (int i = 0; i < cycle_number; i++) {
    // Print the i-th cycle
    cout << "Cycle Number " << i << ": ";
    for (int x : cycles[i]) cout << x + index << " ";
    cout << endl;
  }
}
