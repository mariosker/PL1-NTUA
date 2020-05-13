/**************************************************************************
Project     : Programming Languages 1 - Assignment 1 - Exercise 1
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : April 29, 2020.
Description : Powers of 2. (C++)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************/


#include <cmath>
#include <fstream>
#include <vector>

using namespace std;

void read_file(const char* infile);
void printvector(const vector<unsigned>& vec);
void powers2(unsigned k, unsigned n);

int main(int argc, char const* argv[]) {
  if (argc < 2) {
    printf("Program requires arguments");
    exit(EXIT_FAILURE);
  } else {
    for (int i = 1; i < argc; ++i) read_file(argv[i]);
  }

  return 0;
}

void read_file(const char* infile) {
  FILE* fp = fopen(infile, "r");
  unsigned test_count, test_arg1, test_arg2;

  if (fp == NULL) {
    printf("Error reading file: %s", infile);
    exit(EXIT_FAILURE);
  }

  if (!fscanf(fp, "%u", &test_count)) {
    printf("Error reading file\n");
    exit(EXIT_FAILURE);
  }

  for (unsigned i = 0; i < test_count; ++i) {
    if (!fscanf(fp, "%u %u", &test_arg1, &test_arg2)) {
      printf("Error reading file\n");
      exit(EXIT_FAILURE);
    }

    powers2(test_arg1, test_arg2);
  }

  fclose(fp);
}

void printvector(const vector<unsigned>& vec) {
  bool is_first = true;

  printf("[");

  for (unsigned i = 0; i < vec.size(); ++i) {
    if (is_first) {
      is_first = false;
    } else {
      printf(",");
    }

    printf("%u", vec[i]);
  }

  printf("]\n");
}

void powers2(unsigned n, unsigned k) {
  vector<unsigned> my_vector(k, 1);
  unsigned sum = k;
  if (sum > n) {
    printf("[]\n");
    return;
  }

  for (int i = k - 1; i != -1; --i) {
    sum -= 1;
    my_vector[i] = (unsigned)log2(n - sum);
    sum += pow(2, my_vector[i]);
  }

  if (sum != n) {
    printf("[]\n");
    return;
  }

  vector<unsigned> sol(my_vector.back() + 1, 0);
  for (unsigned i = 0; i < my_vector.size(); ++i) {
    sol[my_vector[i]]++;
  }

  printvector(sol);
}