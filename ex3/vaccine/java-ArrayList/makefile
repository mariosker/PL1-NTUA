Vaccine: Vaccine.java Solver.java
	javac Vaccine.java

test:
	rm -f outnow
	java Vaccine ..//testcases/vaccine.in1 >> outnow
	diff outnow ../testcases/vaccine.out1

zip:
	rm -f *.zip
	zip Vaccine.zip *.java

clean:
	rm -f Vaccine *.class *.zip out