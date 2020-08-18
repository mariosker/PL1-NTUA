/*
Project     : Programming Languages 1 - Assignment 3 - Exercise 1
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : July 10, 2020.
Description : Stayhome. (Java)
-----------
School of ECE, National Technical University of Athens.
*/

import java.io.*;
import java.util.*;

public class Stayhome {
    public static void main(String[] args) {
        String arg = null;
        if (args.length == 1) {
            arg = args[0];
            try {
                File myF = new File(arg);
                BufferedReader br = new BufferedReader(new FileReader(myF));

                String temp;
                int size = 0;
                int l = 0;
                temp = br.readLine(); // holds the first line
                size = temp.length(); // holds the size

                int[][] initial_map = new int[size][size];
                Tuple traveler_coords = new Tuple(0, 0);
                Tuple destination_coords = new Tuple(0, 0);
                Tuple outbreak_starting_point = new Tuple(0, 0);
                List<Tuple> airport_coords = new ArrayList<Tuple>();
                do {
                    for (int c = 0; c < size; c++) {
                        switch (temp.charAt(c)) {
                            case 'S':
                                initial_map[l][c] = -1;
                                traveler_coords.x = c;
                                traveler_coords.y = l;
                                break;
                            case 'T':
                                initial_map[l][c] = -1;
                                destination_coords.x = c;
                                destination_coords.y = l;
                                break;
                            case 'W':
                                initial_map[l][c] = 0;
                                outbreak_starting_point.x = c;
                                outbreak_starting_point.y = l;
                                break;
                            case 'A':
                                initial_map[l][c] = -2;
                                airport_coords.add(new Tuple(l, c));
                                break;
                            case 'X':
                                initial_map[l][c] = -3;
                                break;
                            case '.':
                                initial_map[l][c] = -1;
                                break;
                        }
                    }
                    l++;
                } while ((temp = br.readLine()) != null);
                br.close();

                Map sol_map = new Map(initial_map, size, l, traveler_coords, destination_coords,
                        outbreak_starting_point, airport_coords);
                sol_map.flood_fill_map();
                sol_map.print_safe_path();
            } catch (FileNotFoundException e) {
                System.out.println("An error occurred.");
                e.printStackTrace();
            } catch (IOException ie) {
                ie.printStackTrace();
            }
        } else
            System.out.println("Wrong input \n");
    }
}
