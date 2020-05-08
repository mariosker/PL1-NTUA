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


class CoronaSpread:
    def __init__(self):
        self.map = []
        self.airport_coords = []
        self.traveler_coords = 0
        self.destination_coords = 0
        self.outbreak_starting_point = 0
        self.map_height = 0
        self.map_width = 0

    def create_map(self, file):
        for col, line in enumerate(file):
            map_row = []
            for row, character in enumerate(line):
                #  acceptable characters: S', 'T', 'W', 'A', 'X', '.'
                if character == "S":
                    self.traveler_coords = (col, row)
                    map_row.append(-1)
                    continue

                elif character == "T":
                    self.destination_coords = (col, row)
                    map_row.append(-1)
                    continue

                elif character == "W":
                    self.outbreak_starting_point = (col, row)
                    map_row.append(0)
                    continue

                elif character == "A":
                    self.airport_coords.append((col, row))
                    map_row.append(-2)
                    continue

                elif character == "X":
                    map_row.append('X')
                    continue

                elif character == ".":
                    map_row.append(-1)
                    continue
            self.map.append(map_row)
            self.map_height = col
            self.map_width = row

    def flood_fill_map(self):
        def move(n, m):
            nonlocal reached_airport
            if (self.map[n][m] != 'X'):
                next_value = self.map[n][m]
                if (next_value < 0 or time < next_value):
                    if next_value == -2:
                        reached_airport = True
                    queue.append((n, m, time))
                    self.map[n][m] = time

        (x, y) = self.outbreak_starting_point
        time = 0

        reached_airport = False
        spreaded_to_all_airports = False

        queue = []
        queue.append((x, y, time))

        while queue:
            if reached_airport and not spreaded_to_all_airports:
                for (x, y) in self.airport_coords:
                    next_airport = self.map[x][y]
                    if next_airport > time + 5 or next_airport < 0:
                        self.map[x][y] = time + 5
                    queue.append((x, y, time + 5))
                spreaded_to_all_airports = True

            (n, m, time) = queue.pop(0)
            curr_value = self.map[n][m]
            time += 2

            # up
            if (n > 0):
                move(n - 1, m)
            # right
            if (m < self.map_width - 1):
                move(n, m + 1)
            # down
            if (n < self.map_height - 1):
                move(n + 1, m)
            # left
            if (m > 0):
                move(n, m - 1)

    def print_safe_path(self):
        queue = [self.traveler_coords]
        tile_time = {self.traveler_coords: 0}
        parent_tile = {self.traveler_coords: None}
        time = 1

        def move(x, y, time):
            corona_arrival_time = self.map[x][y]
            if corona_arrival_time != 'X':
                if (x, y) not in tile_time and time < corona_arrival_time:
                    tile_time[(x, y)] = time
                    parent_tile[(x, y)] = u
                    next.append((x, y))

        while queue:
            next = []
            for u in queue:
                (n, m) = u
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
    with open(filename, 'rt') as f:
        corona.create_map(f)

    corona.flood_fill_map()
    corona.print_safe_path()


if __name__ == "__main__":
    main(sys.argv)
