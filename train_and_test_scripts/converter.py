import os
import sys
import random
import re
import json


def converter(sample, s_idx, r_idx, o_idx):
    ret = {"triple_list_gold": [], "triple_list_pred": [], "new": [], "lack": [], "id": [0]}
    for s in sample:
        ret["triple_list_pred"].append({"subject": s[s_idx], "relation": s[r_idx], "object": s[o_idx]})
    return ret


out_file = sys.argv[1]
try:
    beam = int(sys.argv[2])
except:
    beam = 1

with open(out_file, "r", encoding="utf8") as ff:
    all_lines = [x.strip() for x in ff]

fail_cnt = 0

ret = []
order_idx = []


def get_order(line):
    s_idx, r_idx, t_idx = line.find("<d>"), line.find("<r>"), line.find("<t>")
    if s_idx == -1 or r_idx == -1 or t_idx == -1:
        return 0, 2, 1
    pos_ord = sorted([['s', s_idx], ['r', r_idx], ['o', t_idx]], key=lambda x: x[1])
    pos_ord = [x[0] for x in pos_ord]
    return pos_ord.index('s'), pos_ord.index('r'), pos_ord.index('o')


for line in all_lines:
    segs = re.split(r"<[d|t|r]{1}>", line)
    segs.pop(0)
    ret.append([])
    order_idx.append(get_order(line))
    if len(segs) % 3 != 0:  # output are broken
        if len(segs) < 3:
            fail_cnt += 1
            ret[-1].append(["fail", "fail", "fail"])
        else:
            X = segs[:3]   # only use the first triple
            ret[-1].append([x.strip() for x in X])
    else:
        m_tuple = len(segs) // 3
        for ii in range(m_tuple):
            X = segs[ii * 3: ii * 3 + 3]
            ret[-1].append([x.strip() for x in X])

ret_formatted = []

for idx in range(len(ret) // beam):
    r = []
    for idx2 in range(idx * beam, idx * beam + beam):
        r += ret[idx2]
    s_idx, r_idx, t_idx = order_idx[idx * beam]
    ret_formatted.append(converter(r, s_idx, r_idx, t_idx))

with open(f"{out_file}.extracted.v1.json", "w", encoding="utf8") as fw:
    for eg in ret_formatted:
        print(json.dumps(eg), file=fw)

print(f"failed = {fail_cnt}, total = {len(all_lines)}")
