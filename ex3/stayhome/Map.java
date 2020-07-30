import java.util.*;

public class Map {
    // General
    private int[][] map;
    private int x_size, y_size;
    private Tuple traveler_coords, destination_coords, outbreak_starting_point;

    // For Flooding
    private List<Tuple> airport_coords;
    private boolean reached_airport = false;
    private int time = 0;
    private Queue<Thruple> queue = new LinkedList<>();

    // For Bfs
    private Queue<Tuple> bfsqueue = new LinkedList<>();
    private Queue<Tuple> next = new LinkedList<>();
    HashMap<Tuple, Integer> tile_time = new HashMap<Tuple, Integer>();
    HashMap<Tuple, Tuple> parent_tile = new HashMap<Tuple, Tuple>();

    public Map(int[][] map, int x_size, int y_size, Tuple traveler_coords, Tuple destination_coords,
            Tuple outbreak_starting_point, List<Tuple> airport_coords) {
        this.map = map;
        this.x_size = x_size;
        this.y_size = y_size;
        this.traveler_coords = traveler_coords;
        this.destination_coords = destination_coords;
        this.outbreak_starting_point = outbreak_starting_point;
        this.airport_coords = airport_coords;
    }

    public void print_map() {
        for (int i = 0; i < this.y_size; i++) {
            for (int j = 0; j < this.x_size; j++) {
                System.out.printf("%3d ", this.map[i][j]);
            }
            System.out.println();
        }
        for (Tuple x : this.airport_coords) {
            System.out.printf("(%2d, %2d) -", x.y, x.x);
        }
        System.out.println();
    }

    private void move(Tuple data, int time) {
        int next_value;
        if (this.map[data.y][data.x] != -3) {
            next_value = this.map[data.y][data.x];
            if (next_value < 0 || time < next_value) {
                if (next_value == -2) {
                    this.reached_airport = true;
                }
                this.queue.add(new Thruple(data.y, data.x, time));
                this.map[data.y][data.x] = time;
            }
        }
    }

    private void move2(Tuple data, int time, Tuple prev) {
        int next_tile_data = this.map[data.y][data.x];
        if (next_tile_data != -3) {
            if (!this.tile_time.containsKey(data) && time < next_tile_data) {
                this.tile_time.put(data, time);
                this.parent_tile.put(data, prev);
                this.next.add(data);
            }
        }
    }

    public void flood_fill_map() {
        Tuple co = this.outbreak_starting_point;
        int time = 0;

        this.reached_airport = false;
        boolean spreaded_to_all_airports = false;

        this.queue.add(new Thruple(co.y, co.x, time));

        while (!this.queue.isEmpty()) {
            if (!spreaded_to_all_airports) {
                if (this.reached_airport) {
                    for (Tuple coords : this.airport_coords) {
                        int next_airport = this.map[coords.y][coords.x];
                        if (next_airport > (time + 5) || next_airport < 0) {
                            this.map[coords.y][coords.x] = (time + 5);
                        }
                        this.queue.add(new Thruple(coords.y, coords.x, time + 5));
                    }
                    spreaded_to_all_airports = true;
                }
            }

            Thruple temp = this.queue.poll();
            time = temp.time;
            time += 2;
            Tuple temp_coords_up = new Tuple(temp.y - 1, temp.x);
            Tuple temp_coords_right = new Tuple(temp.y, temp.x + 1);
            Tuple temp_coords_down = new Tuple(temp.y + 1, temp.x);
            Tuple temp_coords_left = new Tuple(temp.y, temp.x - 1);
            // up
            if (temp.y > 0) {
                this.move(temp_coords_up, time);
            }
            // right
            if (temp.x < this.x_size - 1) {
                this.move(temp_coords_right, time);
            }
            // down
            if (temp.y < this.y_size - 1) {
                this.move(temp_coords_down, time);
            }
            // left
            if (temp.x > 0) {
                this.move(temp_coords_left, time);
            }
        }
    }

    public void print_safe_path() {
        this.bfsqueue.add(this.traveler_coords);
        int time = 1;
        this.tile_time.put(this.traveler_coords, 0);
        this.parent_tile.put(this.traveler_coords, new Tuple(-5, -5));

        while (!this.bfsqueue.isEmpty()) {
            this.next.clear();
            for (Tuple u : this.bfsqueue) {
                Tuple temp_coords_up = new Tuple(u.y - 1, u.x);
                Tuple temp_coords_right = new Tuple(u.y, u.x + 1);
                Tuple temp_coords_down = new Tuple(u.y + 1, u.x);
                Tuple temp_coords_left = new Tuple(u.y, u.x - 1);

                // down
                if (u.y < this.y_size - 1) {
                    this.move2(temp_coords_down, time, u);
                }
                // left
                if (u.x > 0) {
                    this.move2(temp_coords_left, time, u);
                }
                // right
                if (u.x < this.x_size - 1) {
                    this.move2(temp_coords_right, time, u);
                }

                // up
                if (u.y > 0) {
                    this.move2(temp_coords_up, time, u);
                }
            }
            this.bfsqueue = new LinkedList<>(this.next);
            time += 1;
        }
        if (!this.parent_tile.containsKey(this.destination_coords)) {
            System.out.println("IMPOSSIBLE");
        } else {
            time = this.tile_time.get(this.destination_coords);
            System.out.printf("%d\n", time);
            char[] directions = new char[time];
            Tuple prev = this.destination_coords;
            Tuple cur = this.parent_tile.get(this.destination_coords);

            for (int i = 0; i < time; i++) {
                if (cur.y == prev.y + 1) {
                    directions[time - i - 1] = 'U';
                }
                if (cur.y == prev.y - 1) {
                    directions[time - i - 1] = 'D';
                }
                if (cur.x == prev.x + 1) {
                    directions[time - i - 1] = 'L';
                }
                if (cur.x == prev.x - 1) {
                    directions[time - i - 1] = 'R';
                }
                prev = cur;
                cur = this.parent_tile.get(cur);

            }
            StringBuilder sb = new StringBuilder();
            for (Character ch : directions) {
                sb.append(ch);
            }
            // convert in string
            String string = sb.toString();

            // print string
            System.out.print(string);
        }
    }
}
