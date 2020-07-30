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

public class StayHome {
    public static void main(String[] args) {
        String arg = null;
        if (args.length == 1) {
            arg = args[0];
            try {
                File myF = new File(arg);
            } catch (FileNotFoundException e) {
                System.out.println("An error occurred.");
                e.printStackTrace();
            }
            Map MyMap = new Map();
            MyMap.CreateMap(MyF);
            MyMap.Flood();
            MyMap.Bfs();
            MyMap.Output();
        } else
            System.out.println(" Wrong input \n");
    }
}
