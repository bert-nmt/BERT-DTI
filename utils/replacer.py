import sys
import re

fname = sys.argv[1]

with open(fname, "r", encoding="utf8") as ff:
  all_lines = [x.strip() for x in ff]

newx = []
for line in all_lines:
  l = re.sub(r"&lt; ([a-z]{1,5}) &gt;", r"<\1>", line)
  l = re.sub(r"&lt; ([a-z]{1,5}[0-9]{1,5}) &gt;", r"<\1>", l)
  newx.append(l)

with open(fname + ".r", "w", encoding="utf8") as fw:
  for line in newx:
    print(line, file=fw)