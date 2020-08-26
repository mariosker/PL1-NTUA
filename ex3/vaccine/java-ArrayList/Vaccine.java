/*
Project     : Programming Languages 1 - Assignment 3 - Exercise 2
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : August 5, 2020.
Description : Vaccine. (Java)
-----------
School of ECE, National Technical University of Athens.
*/

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Vaccine {
    public static void main(String[] args) {
        String arg = null;
        if (args.length == 1) {
            arg = args[0];
            try {
                File myF = new File(arg);
                BufferedReader br = new BufferedReader(new FileReader(myF));
                String temp;
                int cnt;

                temp = br.readLine();
                cnt = Integer.parseInt(temp);
                for (int i = 0; i < cnt; i++) {
                    temp = br.readLine();
                    Solver solu = new Solver(temp);
                    solu.BFS();
                }
                br.close();
            } catch (FileNotFoundException e) {
                System.out.println("An error occurred.");
                e.printStackTrace();
            } catch (IOException ie) {
                System.out.println("An error occurred.");
                ie.printStackTrace();
            }
        } else {
            System.out.println("Wrong input");
        }
    }
}