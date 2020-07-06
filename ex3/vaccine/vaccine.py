import sys


def debug(msg):
    print('\033[93m' + 'DEBUG: ' + msg + '\033[0m')


def main(argv):
    if (len(argv) != 2):
        print("Expected 1 argument, got", len(argv) - 1)
        exit(2)
    filename = argv[1]
    try:
        with open(filename, 'r') as fn:
            pass
    except Exception as e:
        print("Error opening file:", filename)
        exit(2)


if __name__ == "__main__":
    main(sys.argv)
