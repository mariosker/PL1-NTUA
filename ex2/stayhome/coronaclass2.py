'''
Project     : Programming Languages 1 - Assignment 2 - Exercise 3
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 7, 2020.
Description : Stayhome. (Python)
-----------
School of ECE, National Technical University of Athens.
'''

import sys  # for parsing command line arguments
# import os  # used for clearing the screen output
# clear = lambda: os.system('clear')


class corona_spread:
    def __init__(self):
        self.corona_map = []
        self.airport_coords = []
        self.sotiris_coords = 0
        self.home_coords = 0
        self.corona_coords = 0
        self.max_n = 0
        self.max_m = 0

    def create_map(self, file):
        for n_coord, line in enumerate(file):
            corona_line = []
            for m_coord, character in enumerate(line):
                #  acceptable characters: S', 'T', 'W', 'A', 'X', '.'
                if character == "S":
                    self.sotiris_coords = (n_coord, m_coord)
                    corona_line.append(-1)
                    continue

                if character == "T":
                    self.home_coords = (n_coord, m_coord)
                    corona_line.append(-1)
                    continue

                if character == "W":
                    self.corona_coords = (n_coord, m_coord)
                    corona_line.append(0)
                    continue

                if character == "A":
                    self.airport_coords.append((n_coord, m_coord))
                    corona_line.append(-2)
                    continue

                if character == "X":
                    corona_line.append('X')
                    continue

                if character == ".":
                    corona_line.append(-1)
                    continue
            self.corona_map.append(corona_line)
            self.max_n = len(self.corona_map)
            self.max_m = len(self.corona_map[0])

    '''
    def print_map(self):
        print("    ", end=" ")
        for i in range(self.max_m):
            print("{:2}".format(str(i)), end=" ")

        print("\n   ", end=" ")
        for i in range(self.max_m):
            print("___", end="")
        print()

        for k, line in enumerate(self.corona_map):
            print("{:2} |".format(str(k)), end=" ")
            for i in line:
                print("{:>2}".format(str(i)), end=" ")
            print()
    '''

    def flood_map(self):
        def move(n, m):
            nonlocal reached_airport
            if (self.corona_map[n][m] != 'X'):
                next_value = self.corona_map[n][m]
                if (next_value < 0 or time < next_value):
                    if next_value == -2:
                        reached_airport = True
                    queue.append((n, m, time))
                    self.corona_map[n][m] = time

        (x, y) = self.corona_coords
        time = 0

        reached_airport = False
        spreaded_to_all_airports = False

        queue = []
        queue.append((x, y, time))

        while queue:
            if reached_airport and not spreaded_to_all_airports:
                for (x, y) in self.airport_coords:
                    next_value = self.corona_map[x][y]
                    if next_value > time + 5 or next_value < 0:
                        self.corona_map[x][y] = time + 5
                    queue.append((x, y, time + 5))
                spreaded_to_all_airports = True

            (n, m, time) = queue.pop(0)
            curr_value = self.corona_map[n][m]
            time += 2

            # up
            if (n > 0):
                move(n - 1, m)
            # right
            if (m < self.max_m - 1):
                move(n, m + 1)
            # down
            if (n < self.max_n - 1):
                move(n + 1, m)
            # left
            if (m > 0):
                move(n, m - 1)

            # DEBUG: START print map step by step
            # clear()
            # self.print_map()
            # input()
            # DEBUG: END

    def bfs(self):
        def move(n, m, path):
            if (self.corona_map[n][m] != 'X'):
                next_value = self.corona_map[n][m]
                if time < next_value and ((n, m) not in path):
                    path.append((n, m))
                    queue.append((n, m, time, path))

        flag_found = False
        min_time = self.max_m * self.max_n
        time = 0
        (x, y) = self.sotiris_coords
        queue = []
        queue.append((x, y, time, [(x, y)]))
        possible_path = ""
        while queue:
            (n, m, time, path) = queue.pop(0)
            time += 1
            if time > min_time:
                continue
            if (n, m) == self.home_coords:
                flag_found = True
                min_time = time if time < min_time else min_time

                direct = ""
                for i in range(len(path) - 1):
                    (n1, m1) = path[i]
                    (n2, m2) = path[i + 1]
                    if (n1 == n2 + 1):
                        direct += "U"
                    if (n1 == n2 - 1):
                        direct += "D"
                    if (m1 == m2 + 1):
                        direct += "L"
                    if (m1 == m2 - 1):
                        direct += "R"

                if possible_path == "" or possible_path > direct:
                    possible_path = direct
                continue
            # down
            if (n < self.max_n - 1):
                move(n + 1, m, path[:])
            # left
            if (m > 0):
                move(n, m - 1, path[:])
            # right
            if (m < self.max_m - 1):
                move(n, m + 1, path[:])
            # up
            if (n > 0):
                move(n - 1, m, path[:])

        if not flag_found:
            print("IMPOSSIBLE")
        else:
            print(min_time - 1)
            print(possible_path)


def main(argv):
    filename = argv[0]
    corona = corona_spread()
    with open(filename, 'r') as f:
        # print("Corona map:")
        corona.create_map(f)

    # DEBUG: START print map and map info
    # corona.print_map()
    # print("Airport", corona.airport_coords)
    # print("Corona", corona.corona_coords)
    # print("Sotiris", corona.sotiris_coords)
    # print("Home", corona.home_coords)
    # DEBUG: END
    print("map created")
    corona.flood_map()
    print("flood done")
    # DEBUG: START print map after flooding
    # print()
    # print("Corona map after flood-fill:")
    # corona.print_map()
    # DEBUG: END

    corona.bfs()


if __name__ == "__main__":
    # main(["test1.txt"])
    # main(["test2.txt"])
    # main(["test3.txt"])
    main(["bigtest.txt"])
    # main(sys.argv())
