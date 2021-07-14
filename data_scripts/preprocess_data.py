# coding: utf-8

import json
import re
import sys

from collections import OrderedDict

in_f = sys.argv[1]
out_f = sys.argv[2]


def merge_title_and_abstract(title, abstract):
    if re.search(r"\W$", title):
        doc = title + " " + abstract
    else:
        doc = title + ". " + abstract

    return doc


with open(f"{in_f}", "r", encoding="utf8") as fr:
    DB = json.load(fr, object_pairs_hook=OrderedDict)

pmid_list, doc_list, label_list = [], [], []

for k, v in DB.items():
    pmid_list.append(k)
    doc = merge_title_and_abstract(v["title"].strip(), v["abstract"].strip())
    doc_list.append(doc)
    label_list.append([])
    for triplet in v["triples"]:
        s = f"<d> {triplet['drug'].strip()} <r> {triplet['interaction'].strip()} <t> {triplet['target'].strip()}"
        label_list[-1].append(s)

with open(f"{out_f}.x", "w", encoding="utf8") as fw:
    for e in doc_list:
        print(e.strip(), file=fw)

with open(f"{out_f}.y", "w", encoding="utf8") as fw:
    for e in label_list:
        print(" ".join(e), file=fw)

with open(f"{out_f}.pmid", "w", encoding="utf8") as fw:
    for e in pmid_list:
        print(e, file=fw)
