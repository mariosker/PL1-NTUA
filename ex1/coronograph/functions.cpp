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
    graph->find_cycle();

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

bool Graph::dfs(int v, vector<char> &color, vector<int> &parent,
                int &cycle_start, int &cycle_end) {
  color[v] = 1;
  list<int>::iterator i;
  for (i = adj_list[v].begin(); i != adj_list[v].end(); ++i) {
    int u = *i;
    if (color[u] == 0) {
      parent[u] = v;
      if (dfs(u, color, parent, cycle_start, cycle_end)) return true;
    } else if (color[u] == 1) {
      cycle_end = v;
      cycle_start = u;
      return true;
    }
  }
  color[v] = 2;
  return false;
}

void Graph::find_cycle() {
  vector<char> color;
  vector<int> parent;
  int cycle_start, cycle_end;

  color.assign(vertices_count, 0);
  parent.assign(vertices_count, -1);
  cycle_start = -1;

  for (int v = 0; v < vertices_count; v++) {
    if (color[v] == 0 && Graph::dfs(v, color, parent, cycle_start, cycle_end))
      break;
  }

  if (cycle_start == -1) {
    cout << "Acyclic" << endl;
  } else {
    vector<int> cycle;
    cycle.push_back(cycle_start);
    for (int v = cycle_end; v != cycle_start; v = parent[v]) cycle.push_back(v);
    cycle.push_back(cycle_start);
    reverse(cycle.begin(), cycle.end());

    cout << "Cycle found: ";
    for (int v : cycle) cout << v + index << " ";
    cout << endl;
  }
}
