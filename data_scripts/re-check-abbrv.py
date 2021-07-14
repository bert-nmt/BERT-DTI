import json
import re
import sys

src = sys.argv[1]
tgt = sys.argv[2]

with open(src, "r", encoding="utf8") as fr:
    all_src = [x.strip() for x in fr]
with open(tgt, "r", encoding="utf8") as fr:
    all_tgt = []
    for line in fr:
        segs_raw = re.split(r"<[dtr]{1}>", line.strip())
        segs = [e.strip() for e in segs_raw]
        segs.pop(0)
        all_tgt.append(segs)
    

    

filtered_tgt = []
succ, fail = 0, 0
for (doc, triplets) in zip(all_src, all_tgt):
    buf = []
    for triplet in triplets:
        m = re.search(r"\([^\)]+\)$", triplet)
        if m:
            matched = m.group()
            if not matched[1:-1].lower() in doc.lower():
                t = triplet.replace(matched, "").strip()
                buf.append(t)
                fail += 1
            else:
                buf.append(triplet)
                succ += 1
        else:
            buf.append(triplet)
    assert len(buf) % 3 == 0      
    filtered_tgt.append(buf)   
    

with open(tgt + ".filtered", "w", encoding="utf8") as fw:
    for line in filtered_tgt:
        m = len(line) // 3
        dump_str = ""
        for idx in range(m):
            dump_str += f" <d> {line[idx*3]} <t> {line[idx*3+1]} <r> {line[idx*3+2]}"
        print(dump_str[1:], file=fw)
        
