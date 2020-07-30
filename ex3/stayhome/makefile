StayHome: StayHome.java
	javac StayHome.java

test: StayHome
	java StayHome testcases/stayhome.in1 >> outnow
	diff outnow testcases/stayhome.out1
	rm -f outnow

zip:
	zip StayHome.zip *.java

clean:
	rm -f StayHome *.class *.zip
