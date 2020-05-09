(**************************************************************************
Project     : Programming Languages 1 - Assignment 2 - Exercise 3
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : May 9, 2020.
Description : Stayhome. (SML)
-----------
School of ECE, National Technical University of Athens.
**************************************************************************)


(*Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun parse file =
    let
		(* Function to read an integer from an input stream *)
        fun next_int input =
	    	Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

		(* Open input file. *)
    	val inStream = TextIO.openIn file

		(* Read an integer and consume newline. *)
        val n = next_int inStream
		val _ = TextIO.inputLine inStream

		(* Function to read the pair of integer in subsequent lines *)
        fun scanner 0 acc = acc
          | scanner i acc =
            let
                val f = next_int inStream
                val s = next_int inStream
            in
                scanner (i - 1) ((f, s) :: acc)
            end
    in
        (n,  rev(scanner n []))
    end
