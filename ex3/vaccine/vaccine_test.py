import sys
import time
import collections
DEBUG = False

BLUE = '\033[94m'
GREEN = '\033[92m'
ENDC = '\033[0m'
RED = '\033[91m'

complement_dict = {'A': 'U', 'C': 'G', 'G': 'C', 'U': 'A'}


class rna_data:
    def __init__(self,
                 initial_rna_sequence,
                 final_rna_sequence=collections.deque(),
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
        base = self.initial_rna_sequence.pop()
        self.final_rna_sequence.appendleft(base)
        self.initial_rna_size -= 1

    def complement(self):
        bases = [complement_dict[base] for base in self.initial_rna_sequence]
        self.initial_rna_sequence = bases

    def reverse(self):
        if self.final_rna_sequence != None:
            self.final_rna_sequence.reverse()

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
        r = rna_data(self.initial_rna_sequence, self.final_rna_sequence.copy(),
                     self, 'r', self.initial_rna_size)
        r.reverse()

        if self.initial_rna_size != 0:
            p = rna_data(self.initial_rna_sequence.copy(),
                         self.final_rna_sequence.copy(), self, 'p',
                         self.initial_rna_size)
            p.push()

            if not p.is_valid():
                p = None

            c = rna_data(self.initial_rna_sequence.copy(),
                         self.final_rna_sequence, self, 'c',
                         self.initial_rna_size)
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
            "".join(self.initial_rna_sequence),
            "".join(self.final_rna_sequence),
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
    start = time.time()
    filename = "testcases/vaccine.in11"
    # if (len(argv) != 2):
    #     print("Expected 1 argument, got", len(argv) - 1)
    #     exit(2)
    # filename = argv[1]

    sum_time = 0
    with open(filename, 'rt') as fn:
        count_bases = int(fn.readline())
        for i in range(count_bases):
            if DEBUG:
                s = time.time()
            rna = collections.deque(fn.readline()[:-1])
            base = rna_data(rna)
            res = bfs(base)

            if DEBUG:
                print(res, end=" - ")
                e = time.time()
                sum_time += e - s
                print(BLUE + "TEST TIME:", e - s, GREEN + "TOTAL TIME:",
                      sum_time, ENDC)
            else:
                print(res)
    if DEBUG:
        end = time.time()
        print(GREEN + "TOTAL TIME: ", end - start, ENDC)


if __name__ == "__main__":
    main(sys.argv)
