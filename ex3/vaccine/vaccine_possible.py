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

DEBUG = True
DEFAULT_FILENAME = "testcases/vaccine.in11"

RED = '\033[91m'
GREEN = '\033[92m'
BLUE = '\033[94m'
ENDC = '\033[0m'

complement = {'A': 'U', 'C': 'G', 'G': 'C', 'U': 'A'}


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
        bases = [complement[base] for base in self.initial_rna_sequence]
        self.initial_rna_sequence = ''.join(bases)

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
            if b in found and previous == b:
                continue
            if b in found and previous != b:
                return False
        return True

    # def next(self):
    #     if self.final_rna_sequence is not None:
    #         r = RnaData(self.initial_rna_sequence, self.final_rna_sequence, self, 'r',
    #                     self.initial_rna_size)
    #         r.reverse()
    #     else:
    #         r = None

    #     if self.initial_rna_size != 0:
    #         p = RnaData(self.initial_rna_sequence, self.final_rna_sequence, self, 'p',
    #                     self.initial_rna_size)
    #         p.push()

    #         if not p.is_valid():
    #             p = None

    #         c = RnaData(self.initial_rna_sequence, self.final_rna_sequence, self, 'c',
    #                     self.initial_rna_size)
    #         c.complement()
    #     else:
    #         p = None
    #         c = None

    #     return [c, p, r]

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

        return [c, p, r]

    def __key(self):
        return (self.initial_rna_sequence, self.final_rna_sequence)

    def __eq__(self, other):
        if isinstance(other, RnaData):
            return self.__key() == other.__key()
        return NotImplemented

    def __hash__(self):
        return hash(self.__key())


def bfs(initial_rna):
    seen = set()
    seen.add(initial_rna)

    frontier = [initial_rna]
    while frontier:
        next = []
        for u in frontier:
            if u.initial_rna_size == 0:
                if u.is_valid():
                    a = []
                    while u.previous is not None:
                        a.append(u.correction)
                        u = u.previous
                    a.reverse()
                    return "".join(a)
            next_moves = u.next()

            for v in next_moves:
                if v is not None:
                    if v not in seen:
                        seen.add(v)
                        next.append(v)

        frontier = next
    return None


def main(argv):
    if DEBUG:

        #start = time.time()
        #base = RnaData(
        #    "GGUUCCAGAUAGGUUAUAGAAGAGUUAAUUGUUCGGCUAGCGGCCCCCGGAAUGUUCGAGUAGGGGGCACUAUGACCCACUCCCCUUUUUAAAAG"
        #)
        #res = bfs(base)
        #print(res)
        #end = time.time()
        #print(GREEN + "TOTAL TIME: ", end - start, ENDC)
        #exit()

        start_time = time.time()
        filename = DEFAULT_FILENAME

        if len(argv) == 2:
            filename = argv[1]

        with open(filename, 'rt') as fn:
            count_bases = int(fn.readline())

            for _ in range(count_bases):
                case_start_time = time.time()
                base = RnaData(fn.readline()[:-1])
                result = bfs(base)
                print(result, end="")
                case_end_time = time.time()

                print(
                    BLUE + " [CASE TIME: {:.2f}]".format(case_end_time -
                                                         case_start_time),
                    ENDC)
        end_time = time.time()

        print(GREEN + "TOTAL TIME: {:.3f}".format(end_time - start_time), ENDC)

    else:
        if len(argv) != 2:
            print("Expected 1 argument, got", len(argv) - 1)
            exit(2)
        filename = argv[1]

        with open(filename, 'rt') as fn:
            count_bases = int(fn.readline())
            for _ in range(count_bases):
                base = RnaData(fn.readline()[:-1])
                result = bfs(base)
                print(result)


if __name__ == "__main__":
    main(sys.argv)
