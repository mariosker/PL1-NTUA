#!/bin/bash




if [ "$#" -eq 1 ] &&  [ $1 == '-help' ] 
then
	echo "HELLO PLEASE READ CAREFULLY"
	echo "THE WORST SCRIPT IN HISTORY IS HERE AND YOU HAVE TO BE CAREFUL"
	echo "THANKS !!!111742!!!1"
	echo "./run.sh path-to-executable path-to-input_tests path-to-output-tests num_of_tests"
	echo "1st argument e.g.: ~/Documents/powers2 (like running it) so"
	echo "from current directory would be: ./powers2"
	echo "2nd: path of  directory from current working directory or full path"
	echo "e.g: ~/6thsemester/proglang/.../InputTestcases or InputTestcases or -s if you are in the same directory"
	echo "3rd: outputh path likewise"
	echo "4th: number of testcases"
	exit 0
fi


if [ "$#" -ne 4 ] 
then
	echo "Usage: $0" >&2
	echo "use -help for more info" >&2
	exit 1
fi

if [ $2 == '-s' ] 
then
	temp=`ls | grep "0.txt" | head -1`
	inputpath=${temp%0.txt*}
else
	temp=`ls $2 | grep "0.txt" | head -1`
	inputpath="$2/${temp%0.txt*}"
fi

if [ $3 == '-s' ] 
then
	temp=`ls | grep "0.txt" | head -1`
	outputpath=${temp%0.txt*}
else
	temp=`ls $3 | grep "0.txt" | head -1`
	outputpath="$3/${temp%0.txt*}"
fi

number_of_inputs=$4
rm output.txt
rm realoutput.txt



for (( i=0; i <= $number_of_inputs; i++))
do
	echo "testing now testcase with filename: $inputpath${i}.txt"
	cat $outputpath${i}.txt > realoutput.txt
	$1 $inputpath${i}.txt > output.txt
	./idiff output.txt realoutput.txt
done


#echo "Big time is now let's see if you're right . . ."
#./idiff output.txt realoutput.txt
