import sys
from collections import deque


def debug(msg):
    print('\033[93m' + 'DEBUG: ' + msg + '\033[0m')


class rna_data:
    def __init__(self,
                 initial_rna_sequence,
                 final_rna_sequence=None,
                 correction=None):
        self.initial_size = len(initial_rna_sequence)
        if type(initial_rna_sequence) == str:
            self.initial_rna_sequence = deque(initial_rna_sequence)
        else:
            self.initial_rna_sequence = initial_rna_sequence

        if final_rna_sequence == None:
            self.final_rna_sequence = deque()
        else:
            self.final_rna_sequence = deque(final_rna_sequence)

        self.correction = correction
        if correction == None:
            self.correction = 'non'
        elif correction == 'p':
            self.push()
        elif correction == 'c':
            self.complement()
        elif correction == 'r':
            self.reverse()

    def push(self):
        if self.initial_size == 0:
            return
        base = self.initial_rna_sequence.pop()
        self.final_rna_sequence.appendleft(base)
        self.initial_size -= 1

    def complement(self):
        for i in range(len(self.final_rna_sequence)):
            if (self.final_rna_sequence[i] == "A"):
                self.final_rna_sequence[i] = "U"
            elif (self.final_rna_sequence[i] == "C"):
                self.final_rna_sequence[i] = "G"
            elif (self.final_rna_sequence[i] == "G"):
                self.final_rna_sequence[i] = "C"
            elif (self.final_rna_sequence[i] == "U"):
                self.final_rna_sequence[i] = "A"

    def reverse(self):
        self.final_rna_sequence.reverse()

    def is_valid(self):
        if self.initial_size != 0:
            return False
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

    def __str__(self):
        return self.correction + "+" + "".join(
            self.initial_rna_sequence) + "+" + "".join(self.final_rna_sequence)


def bfs(initial_rna):
    level = {str(initial_rna): 0}
    parent = {str(initial_rna): None}
    frontier = [initial_rna]
    i = 1
    while frontier:
        # prt = [str(i) for i in frontier]
        # print(prt)
        next = []
        for u in frontier:
            if (u.initial_size) == 0:
                if u.is_valid():
                    # debug("Valid" + str(u))
                    # print(parent)
                    final = str(u)
                    moves = ''
                    while not final.startswith("non"):
                        moves += final[0]
                        final = parent[final]
                    return moves[::-1]

            if (u.initial_size != 0):
                p = rna_data("".join(u.initial_rna_sequence),
                             "".join(u.final_rna_sequence), 'p')
                c = rna_data("".join(u.initial_rna_sequence),
                             "".join(u.final_rna_sequence), 'c')
            else:
                p = None
                c = None

            r = rna_data("".join(u.initial_rna_sequence),
                         "".join(u.final_rna_sequence), 'r')

            corrections = [r]
            if u.initial_size != 0:
                corrections.extend([p, c])
            for v in corrections:
                if str(v) not in level:
                    level[str(v)] = i
                    parent[str(v)] = str(u)
                    next.append(v)
        frontier = next
        i += 1
    return (None)


def main(argv):
    # if (len(argv) != 2):
    #     print("Expected 1 argument, got", len(argv) - 1)
    #     exit(2)
    # filename = argv[1]
    filename = "test.txt"
    with open(filename, 'rt') as fn:
        count_bases = int(fn.readline())
        # debug("Number of tests: " + str(count_bases))
        for i in range(count_bases):
            base = rna_data(fn.readline()[:-1])
            # debug("Test starting with final base: " + str(base))
            a = bfs(base)
            print(a)


if __name__ == "__main__":
    main(sys.argv)
