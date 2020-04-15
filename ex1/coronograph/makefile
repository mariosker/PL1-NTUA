coronograph: coronograph.o functions.o
	g++ -std=c++11 -Wall -Werror -O3 coronograph.o functions.o -o coronograph

coronograph.o: coronograph.cpp
	g++ -std=c++11 -Wall -Werror -O3  -c coronograph.cpp

functions.o: functions.cpp
	g++ -std=c++11 -Wall -Werror -O3 -c functions.cpp

test: coronograph corona.txt
	./coronograph corona.txt

valgrind: coronograph corona.txt
	valgrind --leak-check=full -s ./coronograph corona.txt

clean:
	rm -f *.o coronograph
