'''
Project     : Programming Languages 1 - Assignment 3 - Exercise 2
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : August 5, 2020.
Description : Vaccine. (Python)
-----------
School of ECE, National Technical University of Athens.
'''

import sys
import time
from collections import deque

DEBUG = False
RED = '\033[91m'
GREEN = '\033[92m'
BLUE = '\033[94m'
ENDC = '\033[0m'


class RnaData:
    """Contains two stacks, one has the initial rna and other the final rna sequence.
    """
    def __init__(self,
                 initial_rna_sequence,
                 final_rna_sequence=None,
                 previous=None,
                 correction=None,
                 initial_rna_size=None):
        self.initial_rna_size = initial_rna_size if initial_rna_size is not None else len(
            initial_rna_sequence)

        self.initial_rna_sequence = initial_rna_sequence
        self.final_rna_sequence = final_rna_sequence
        self.previous = previous
        self.correction = correction

    def push(self):
        if self.initial_rna_size == 0:
            return
        base = self.initial_rna_sequence[-1]
        self.initial_rna_sequence = self.initial_rna_sequence[:-1]
        self.final_rna_sequence = self.final_rna_sequence + base if self.final_rna_sequence is not None else base
        self.initial_rna_size -= 1

    def complement(self):
        complement = {'A': 'U', 'C': 'G', 'G': 'C', 'U': 'A'}
        self.initial_rna_sequence = ''.join(
            [complement[base] for base in self.initial_rna_sequence])

    def reverse(self):
        if self.final_rna_sequence is not None:
            self.final_rna_sequence = self.final_rna_sequence[::-1]

    def is_valid(self):
        if self.final_rna_sequence == None:
            return True

        found = set()
        previous = None

        for b in self.final_rna_sequence:
            if b not in found:
                found.add(b)
                previous = b
            elif previous != b:
                return False

        return True

    def next(self):
        c = None
        p = None
        r = None

        if self.final_rna_sequence is not None:
            if self.correction != 'r':
                r = RnaData(self.initial_rna_sequence, self.final_rna_sequence,
                            self, 'r', self.initial_rna_size)
                r.reverse()

        if self.initial_rna_size != 0:
            p = RnaData(self.initial_rna_sequence, self.final_rna_sequence,
                        self, 'p', self.initial_rna_size)
            p.push()

            if not p.is_valid():
                p = None

            if self.correction != 'c':
                c = RnaData(self.initial_rna_sequence, self.final_rna_sequence,
                            self, 'c', self.initial_rna_size)
                c.complement()

        return (c, p, r)

    def __eq__(self, other):
        if isinstance(other, RnaData):
            return (self.initial_rna_sequence,
                    self.final_rna_sequence) == (other.initial_rna_sequence,
                                                 other.final_rna_sequence)
        return NotImplemented

    def __hash__(self):
        return hash((self.initial_rna_sequence, self.final_rna_sequence))


# def bfs(initial_rna):
#     seen = set()
#     seenadd = seen.add
#     seenadd(initial_rna)

#     frontier = [initial_rna]
#     while frontier:
#         next = []
#         nextappend = next.append
#         for u in frontier:
#             if u.initial_rna_size == 0:
#                 a = []
#                 aappend = a.append
#                 while u.previous is not None:
#                     aappend(u.correction)
#                     u = u.previous
#                 a.reverse()
#                 return "".join(a)
#             next_moves = u.next()

#             for v in next_moves:
#                 if v is not None and v not in seen:
#                     seenadd(v)
#                     nextappend(v)

#         frontier = next
#     return None


def bfs(initial_rna):
    seen = set()
    seenadd = seen.add
    seenadd(initial_rna)

    frontier = deque()
    frontieradd = frontier.append
    frontierpop = frontier.popleft

    frontieradd(initial_rna)
    while frontier:
        u = frontierpop()
        if u.initial_rna_size == 0:
            a = []
            aappend = a.append
            while u.previous is not None:
                aappend(u.correction)
                u = u.previous
            a.reverse()
            return "".join(a)

        for v in u.next():
            if v is not None and v not in seen:
                seenadd(v)
                frontieradd(v)

    return None


def main(argv):
    if DEBUG:
        start = time.time()
        filename = "testcases/vaccine.in11"
        if len(argv) == 2:
            filename = argv[1]
        with open(filename, 'rt') as fn:
            next(fn)
            tests = fn.readlines()
        for l in tests:
            rna = l[:-1]
            res = bfs(RnaData(rna, initial_rna_size=len(rna)))
            print(res)
        end = time.time()

        print(GREEN + "TOTAL TIME: ", end - start, ENDC)

    else:
        if len(argv) != 2:
            print("Expected 1 argument, got", len(argv) - 1)
            exit(2)
        filename = argv[1]

        with open(filename, 'rt') as fn:
            next(fn)
            tests = fn.readlines()
        for l in tests:
            rna = l[:-1]
            res = bfs(RnaData(rna, initial_rna_size=len(rna)))
            print(res)


if __name__ == "__main__":
    main(sys.argv)
