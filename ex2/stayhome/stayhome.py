def get_testcase(filename):
    with open(filename) as f:
        content = f.readlines()
        content = [[c for c in x if c != '\n'] for x in content]
        return content


print(get_testcase("./tests-input/test1.txt"))