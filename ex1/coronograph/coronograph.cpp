#include "functions.h"

using namespace std;

int main(int argc, char const *argv[]) {
  if (argc < 2) {
    printf("Program requires arguments");
    exit(EXIT_FAILURE);
  } else {
    for (int i = 1; i < argc; ++i) read_file(argv[i]);
  }

  return 0;
}
