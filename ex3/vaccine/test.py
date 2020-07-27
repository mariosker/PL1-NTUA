import sys


def main(argv):
    filename = "testcases/vaccine.in1"
    # filename = "test.txt"
    # if (len(argv) != 2):
    #     print("Expected 1 argument, got", len(argv) - 1)
    #     exit(2)
    # filename = argv[1]
    with open(filename, 'rt') as fn:
        count_bases = int(fn.readline())
        for i in range(count_bases):
            a = fn.readline()
            print(generate_strings(len(a)), end="-")


if __name__ == "__main__":
    main(sys.argv)