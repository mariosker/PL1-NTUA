'''
Project     : Programming Languages 1 - Assignment 2 - Exercise 3
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 9, 2020.
Description : Stayhome. (Python)
-----------
School of ECE, National Technical University of Athens.
'''

import sys  # for parsing command line arsguments


class CoronaSpread:
    def __init__(self):
        self.outbreak_map = []
        self.airport_coords = []
        self.traveler_coords = 0
        self.destination_coords = 0
        self.outbreak_starting_point = 0
        self.map_height = 0
        self.map_width = 0

    def create_map(self, file):
        """creates map from a file. The map contains pathways, blocked pathways
        and airports. Also the function saves where the traveller, the airports
        , the destination and the outbreak initial point are.
'X')
        Args:
            file (file object): the file to be read
        """
        for n_coord, line in enumerate(file):
            corona_line = []
            for m_coord, character in enumerate(line):
                #  acceptable characters: S', 'T', 'W', 'A', 'X', '.'
                if character == "S":
                    self.traveler_coords = (n_coord, m_coord)
                    corona_line.append(-1)
                    continue

                if character == "T":
                    self.destination_coords = (n_coord, m_coord)
                    corona_line.append(-1)
                    continue

                if character == "W":
                    self.outbreak_starting_point = (n_coord, m_coord)
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

            self.outbreak_map.append(corona_line)
            self.map_height = len(self.outbreak_map)
            self.map_width = len(self.outbreak_map[0])

    def print_map(self):
        """prints the map
        """
        print("    ", end=" ")
        for i in range(self.map_width):
            print("{:2}".format(str(i)), end=" ")

        print("\n   ", end=" ")
        for i in range(self.map_width):
            print("___", end="")
        print()

        for k, line in enumerate(self.outbreak_map):
            print("{:2} |".format(str(k)), end=" ")
            for i in line:
                print("{:>2}".format(str(i)), end=" ")
            print()

    def flood_fill_map(self):
        """Based on the flood fill algorithm, the function fills the map with
        the time required for the virus to reach a tile. The virus moves with
        a step = 2 and if it reaches an airport then after 5 units of time it
        is spread to all the other airports of the map.
        We used the iterative algorithm written in the flood-fill wikipedia page
        and modified it.
        link:[https://en.wikipedia.org/wiki/Flood_fill#Alternative_implementations]
        """
        def move(n, m):
            nonlocal reached_airport
            if (self.outbreak_map[n][m] != 'X'):
                next_value = self.outbreak_map[n][m]
                if (next_value < 0 or time < next_value):
                    if next_value == -2:
                        reached_airport = True
                    queue.append((n, m, time))
                    self.outbreak_map[n][m] = time

        (x, y) = self.outbreak_starting_point
        time = 0

        reached_airport = False
        spreaded_to_all_airports = False

        queue = [(x, y, time)]

        width = self.map_width
        height = self.map_height

        while queue:
            if not spreaded_to_all_airports:
                if reached_airport:
                    for (x, y) in self.airport_coords:
                        next_airport = self.outbreak_map[x][y]
                        if next_airport > time + 5 or next_airport < 0:
                            self.outbreak_map[x][y] = time + 5
                        queue.append((x, y, time + 5))
                    spreaded_to_all_airports = True

            (n, m, time) = queue.pop(0)
            curr_value = self.outbreak_map[n][m]
            time += 2

            # up
            if (n > 0):
                move(n - 1, m)
            # right
            if (m < width - 1):
                move(n, m + 1)
            # down
            if (n < height - 1):
                move(n + 1, m)
            # left
            if (m > 0):
                move(n, m - 1)

    def print_safe_path(self):
        """Uses a bfs algorithm to find the shortest path to reach the
        traveller's destination. We used the algorithm written in the
        MITopencourses site and modified it.
        link:[https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-006-introduction-to-algorithms-fall-2011/]
        """
        queue = [self.traveler_coords]
        tile_time = {self.traveler_coords: 0}
        parent_tile = {self.traveler_coords: None}
        time = 1

        def move(x, y, time):
            next_tile_data = self.outbreak_map[x][y]
            if next_tile_data != 'X':
                if (x, y) not in tile_time and time < next_tile_data:
                    tile_time[(x, y)] = time
                    parent_tile[(x, y)] = u
                    next.append((x, y))

        while queue:
            next = []
            for u in queue:
                (n, m) = u
                print("Current:", u)
                # down
                if (n < self.map_height - 1):
                    move(n + 1, m, time)
                # left
                if (m > 0):
                    move(n, m - 1, time)
                # right
                if (m < self.map_width - 1):
                    move(n, m + 1, time)
                # up
                if (n > 0):
                    move(n - 1, m, time)
            queue = next
            time += 1

        final_destination = self.destination_coords
        if final_destination not in parent_tile:
            print("IMPOSSIBLE")
        else:
            print(tile_time[final_destination])
            directions = ""
            cur, prev = parent_tile[final_destination], final_destination
            while cur:
                (n, m), (x, y) = cur, prev
                if (n == x + 1):
                    directions = "U" + directions
                elif (n == x - 1):
                    directions = "D" + directions
                elif (m == y + 1):
                    directions = "L" + directions
                elif (m == y - 1):
                    directions = "R" + directions
                cur, prev = parent_tile[cur], cur
            print(directions)


def main(argv):
    filename = argv[1]
    corona = CoronaSpread()
    with open(filename, 'r') as f:
        corona.create_map(f)
    corona.print_map()
    corona.flood_fill_map()
    corona.print_map()
    corona.print_safe_path()


if __name__ == "__main__":
    main(sys.argv)
