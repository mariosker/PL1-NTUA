# with open("flood10", 'r') as f:
#     for line in f:
#         line = line.strip("\n")
#         coords = line.split("  ")
#         for c in coords:
#             y = c[1:-1]
#             cc = y.split(",")
#             a = cc[0]
#             b = cc[1]
#             if '~' in a:
#                 a = a.replace('~', '-')
#             if '~' in b:
#                 b = b.replace('~', '-')
#             print('({:>3}, {:>3})'.format(a, b), end=" ")
#         print()

# with open("newoutput.txt", 'r') as f:
#     for line in f:
#         line = line.strip("\n")
#         coords = line.split("  ")
#         for c in coords:
#             c = c.replace('~', '-')
#             print('{:>3},'.format(c), end=" ")
#         print()

with open("test4smlout.txt", 'r') as f:
    a = f.read()
    # a = a.split("\n")
    a = [line for line in a.split('\n') if line.strip() != '']
    for i in a:
        print(i)
