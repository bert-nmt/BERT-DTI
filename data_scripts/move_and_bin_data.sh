
input_dir=$1 # path_to_seq2seq_raw_data
script_dir=$2 # code_dir_for_BERT-DTI

# eg:
#input_dir=./data/seq2seq/
#script_dir=/BERT-DTI



echo process ${target}


echo copy script
P=(bin.sh
bin-pubmedbert.sh
bin-bert.sh
build_bpe_data.sh
cutter.py
replacer.py
prepare.sh)
for f in ${P[@]}; do
  cp $script_dir/utils/$f $input_dir/$f
done

cd $input_dir

echo RUN!! source build_bpe_data.sh
source build_bpe_data.sh

echo RUN!! source bin-pubmedbert.sh
source bin-pubmedbert.sh

echo RUN!! source bin-bert.sh
source bin-bert.sh

echo RUN!! source bin.sh
source bin.sh


