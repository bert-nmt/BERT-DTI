#!/bin/bash
target_lst=(
PubMedBert-encL2_decL2_H256-dr0.1-ls0.2-lr5e-4.post.extracted.v1.json
)

base_dir=/path_to_prediction_dir
gold_file=/path_to_prediction_file/test.json


for target in ${target_lst[@]}
do
  pmid_file=/path_to_test_pmid_file/test.pmid
  python ./hard_match_evaluation.py $base_dir/$target $gold_file $pmid_file
done
