import sys

fname = sys.argv[1]
with open(fname, "r", encoding="utf8") as fr:
  all_lines = [" ".join(x.strip().split()[:1020]) for x in fr]

with open(fname + ".cut1020", "w", encoding="utf8") as fw:
  for line in all_lines:
    print(line, file=fw)