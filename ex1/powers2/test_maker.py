from random import randint
import os

folder_for_testfiles = "testfiles"
folder_for_outputfiles = "output_tests"
folder_for_comparingfiles = "output_tests2"
exec_file = "./powers2"


def create_tests(test):
    os.mkdir(folder_for_testfiles)
    for i in range(test):
        with open("{}/testfile{}.txt".format(folder_for_testfiles, i),
                  "w") as f:
            test_cases_count = randint(1, 10)
            f.write(str(test_cases_count) + "\n")
            for i in range(test_cases_count):
                N = randint(1, 1000000000)
                K = randint(1, 200000)
                f.write(str(N) + " " + str(K) + "\n")


def run_tests(test):
    os.mkdir(folder_for_outputfiles)
    for i in range(test):
        os.system("{} {}/testfile{}.txt > {}/testout{}.txt".format(
            exec_file, folder_for_testfiles, i, folder_for_outputfiles, i))


def compare_files(in1, in2):
    with open(in1, "r") as f1:
        with open(in2, "r") as f2:
            for line1, line2 in zip(f1, f2):
                if line1 == line2:
                    continue
                else:
                    print("error\n", line1, "\n", line2)


def multi_files(test):
    for i in range(test):
        compare_files("{}/testout{}.txt".format(folder_for_outputfiles, i),
                      "{}/testout{}.txt".format(folder_for_comparingfiles, i))


# create_tests(20)
# run_tests(20)
# multi_files(20)
