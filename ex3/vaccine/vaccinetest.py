import sys


class rna_data:
    def __init__(self, in_rna, f_rna, length, change=None):
        self.in_rna = in_rna
        self.f_rna = f_rna
        self.length = length
        self.change = change
        if (change == None):
            self.change = ''
        elif (change == 'p'):
            self.push()
        elif (change == 'c'):
            self.complement()
        elif (change == 'r'):
            self.reverse()

    def push(self):
        base = self.in_rna[-1]
        self.f_rna = base + self.f_rna
        self.length -= 1

    def complement(self):
        temp_rna = []
        temp_rna_append = temp_rna.append
        for c in self.f_rna:
            if (c == "A"):
                temp_rna_append("U")
            elif (c == "C"):
                temp_rna_append("G")
            elif (c == "G"):
                temp_rna_append("C")
            elif (c == "U"):
                temp_rna_append("A")
        self.f_rna = ''.join(temp_rna)

    def reverse(self):
        self.f_rna = self.f_rna[::-1]

    def is_valid(self):
        if (self.length != 0):
            return False
        found = set()
        previous = None

        for b in self.f_rna:
            if (b not in found):
                found.add(b)
                previous = b
            if (b in found and previous == b):
                continue
            if (b in found and previous != b):
                return False
        return True


def bfs(initial_rna: rna_data):
    level = {initial_rna: 0}
    parent = {initial_rna: None}
    frontier = [initial_rna]
    i = 1
    while frontier:
        next = []
        for u in frontier:
            if (u.length == 0):
                if (u.is_valid()):
                    final = u
                    moves = []
                    moves_append = moves.append
                    while not final.change == '':
                        moves_append(final.change)
                        final = parent[final]
                    moves.reverse()
                    return ''.join(moves)

            if (u.length != 0):
                p = rna_data(u.in_rna, u.f_rna, u.length, 'p')
                c = rna_data(u.in_rna, u.f_rna, u.length, 'c')
            else:
                p = None
                c = None

            r = rna_data(u.in_rna, u.f_rna, u.length, 'r')

            if (p == None and c == None):
                corrections = [r]
            else:
                corrections = [p, c, r]

            for v in corrections:
                if (v not in level):
                    level[v] = i
                    parent[v] = u
                    next.append(v)

        frontier = next
        i += 1
    return None


def main(argv):
    filename = "testcases/vaccine.in1"
    # filename = "test.txt"
    # if (len(argv) != 2):
    #     print("Expected 1 argument, got", len(argv) - 1)
    #     exit(2)
    # filename = argv[1]
    with open(filename, 'rt') as fn:
        count_bases = int(fn.readline())
        for i in range(count_bases):
            rna = fn.readline()[:-1]
            base = rna_data(rna, "", len(rna))
            res = bfs(base)
            print(res)


if __name__ == "__main__":
    main(sys.argv)
