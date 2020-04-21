(**************************************************************************
Project     : Programming Languages 1 - Assignment 1 - Exercise 1
Author(s)   : Ioannis Michail Kazelidis (gkazel@outlook.com)
              Marios Kerasiotis (marioskerasiotis@gmail.com)
Date        : April 29, 2020.
Description : Powers of 2. (SML)
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

(* Function prints list in the form [*, ..., *] *)
(* Code is from lab-1 intro to sml *)
fun print_list lst =
	let
		fun print_aux nil = print "]\n"
			| print_aux (h::[]) = (print (Int.toString(h)); print_aux [])
			| print_aux (h::t) = (print (Int.toString(h)); print ","; print_aux t);
	in
		print "[";
		print_aux lst
	end;

(* Source code acquired from: StackOverflow
https://stackoverflow.com/questions/30201666/convert-array-to-list-in-sml *)
fun arrayToList arr = Array.foldr (op ::) [] arr;

(* Source code acquired from:
An Introduction to Standard ML- Michael P. Fourman
http://homepages.inf.ed.ac.uk/mfourman/teaching/mlCourse/notes/practicals/p1.html *)
fun power (x:IntInf.int, 0) = 1
  | power (x:IntInf.int, n:IntInf.int) = if n mod 2 = 0 then power (x*x, n div 2)
                                        else x * power (x*x, n div 2);

(* Iterates over the list and assigns the exponent *)
fun fordown n (k:IntInf.int) lst (sum:IntInf.int)= (
        if k < 0 then ((sum + 1), lst)
        else (
            Array.update (lst,  Int.fromLarge k, IntInf.log2 ((n - sum)) );
            fordown n (k-1) lst ( (sum - 1) + power (2, Int.toLarge(Array.sub(lst, Int.fromLarge k))))
            )
);

(* Function does a for loop to give the transformer function the wanted array *)
fun forup n lim sol arr =
  if n > lim then sol
  else (
      let
        val current = Array.sub(arr, n)
        val cur = Array.sub(sol, current)
      in
        Array.update (sol, current, cur+1);
        forup (n+1) lim sol arr
      end
  )

(*Function counts how many times an exponent of 2 appears in the given array and it creates an new array with these counters*)
fun transformer arr =
  let
  val len = Array.sub(arr, ((Array.length arr)-1)) + 1;
  val sol = Array.array(len, 0)
  in
    forup 0 ((Array.length arr)-1) sol arr
  end

(* Function runs our solution on a test case*)
fun solver n 0 = print_list []
  | solver n k =
        if (n < k) then print_list []
        else
            let
                val (s, a) =  fordown n (k-1) (Array.array( Int.fromLarge k, 1)) (k-1)
            in
                if (s <> n) then print_list [] else (print_list (arrayToList (transformer a)))
            end;


(* Function iterates over tests to call solver function *)
fun solve_each_pair 0 acc = ()
	| solve_each_pair n [] = ()
	| solve_each_pair n ((a, b)::t) = (
        solver (Int.toLarge a) (Int.toLarge b);
		solve_each_pair (n-1) t
  );

(* callable function *)
fun powers2 filename =
	let
	  val (a, b) = parse filename;
	in
	  solve_each_pair  a  b
	end;
