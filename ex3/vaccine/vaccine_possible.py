import sys
import time
from multiprocessing import Pool

DEBUG = True

BLUE = '\033[94m'
GREEN = '\033[92m'
ENDC = '\033[0m'
RED = '\033[91m'

complement = {'A': 'U', 'C': 'G', 'G': 'C', 'U': 'A'}


class rna_data:
    def __init__(self,
                 initial_rna_sequence,
                 final_rna_sequence=None,
                 previous=None,
                 correction=None,
                 initial_rna_size=None):
        self.initial_rna_size = initial_rna_size if initial_rna_size != None else len(
            initial_rna_sequence)

        self.initial_rna_sequence = initial_rna_sequence
        self.final_rna_sequence = final_rna_sequence
        self.previous = previous
        self.correction = correction

    def push(self):
        if (self.initial_rna_size == 0):
            return
        base = self.initial_rna_sequence[-1]
        self.initial_rna_sequence = self.initial_rna_sequence[:-1]
        self.final_rna_sequence = self.final_rna_sequence + base if self.final_rna_sequence != None else base
        self.initial_rna_size -= 1

    def complement(self):
        bases = list(self.initial_rna_sequence)
        bases = [complement[base] for base in bases]
        self.initial_rna_sequence = ''.join(bases)

    def reverse(self):
        if self.final_rna_sequence != None:
            self.final_rna_sequence = self.final_rna_sequence[::-1]

    def is_valid(self):
        if self.final_rna_sequence == None:
            return True

        found = set()
        previous = None

        for b in self.final_rna_sequence:
            if (b not in found):
                found.add(b)
                previous = b
            if (b in found and previous == b):
                continue
            if (b in found and previous != b):
                return False
        return True

    def next(self):
        if self.final_rna_sequence != None:
            r = rna_data(self.initial_rna_sequence, self.final_rna_sequence,
                         self, 'r', self.initial_rna_size)
            r.reverse()
        else:
            r = None

        if self.initial_rna_size != 0:
            p = rna_data(self.initial_rna_sequence, self.final_rna_sequence,
                         self, 'p', self.initial_rna_size)
            p.push()

            if not p.is_valid():
                p = None

            c = rna_data(self.initial_rna_sequence, self.final_rna_sequence,
                         self, 'c', self.initial_rna_size)
            c.complement()
        else:
            p = None
            c = None

        return [c, p, r]

    def __eq__(self, other):
        if (type(self) is not type(other)):
            return False

        return (self.initial_rna_sequence == other.initial_rna_sequence
                and self.final_rna_sequence == other.final_rna_sequence)

    def __hash__(self):
        return hash((
            self.initial_rna_sequence,
            self.final_rna_sequence,
        ))


def bfs(initial_rna):
    seen = set()
    seen.add(initial_rna)

    frontier = [initial_rna]
    while frontier:
        next = []
        for u in frontier:
            if (u.initial_rna_size == 0):
                if (u.is_valid()):
                    a = []
                    while (u.previous != None):
                        a.append(u.correction)
                        u = u.previous
                    a.reverse()
                    return "".join(a)
            next_moves = u.next()

            for v in next_moves:
                if v != None:
                    if (v not in seen):
                        seen.add(v)
                        next.append(v)

        frontier = next
    return None


def main(argv):
    if DEBUG:
        '''
        # start = time.time()
        # base = rna_data("AGCGGCGGGAACGGUCUACAAACGAACCGC")
        # res = bfs(base)
        # print(res)
        # end = time.time()
        # print(GREEN + "TOTAL TIME: ", end - start, ENDC)
        '''
        start = time.time()
        filename = "testcases/vaccine.in6"
        if (len(argv) == 2):
            filename = argv[1]
        with open(filename, 'rt') as fn:
            count_bases = int(fn.readline())
            for i in range(count_bases):
                s = time.time()
                base = rna_data(fn.readline()[:-1])
                res = bfs(base)
                print(res, end=" - ")
                e = time.time()

                print(BLUE + "TEST TIME:", e - s, ENDC)
        end = time.time()

        print(GREEN + "TOTAL TIME: ", end - start, ENDC)

    else:
        if (len(argv) != 2):
            print("Expected 1 argument, got", len(argv) - 1)
            exit(2)
        filename = argv[1]

        with open(filename, 'rt') as fn:
            count_bases = int(fn.readline())
            for i in range(count_bases):
                base = rna_data(fn.readline()[:-1])
                res = bfs(base)
                print(res)


if __name__ == "__main__":
    main(sys.argv)
