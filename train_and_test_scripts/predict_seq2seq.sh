# export CUDA_VISIBLE_DEVICES=0

if [ ! -d "~/fairseq" ]; then

git clone git clone --depth 1 --branch v0.6.2 https://github.com/pytorch/fairseq.git
cd ~/fairseq/
pip install --editable .

fi

cd /tmp
git clone https://github.com/moses-smt/mosesdecoder.git

FAIRSEQ=~/fairseq
export PYTHONPATH=$FAIRSEQ:$PYTHONPATH


src=x
tgt=y

model=$1
DATA_PATH=$2
output_file=$3


python $FAIRSEQ/generate.py \
--source-lang $src \
--target-lang $tgt \
$DATA_PATH \
--path $model \
--max-tokens 48000 \
--beam 5 --batch-size 128 --remove-bpe > $output_file

cat $output_file | grep ^H | sort -nr -k1.2 | cut -f3- | perl /tmp/mosesdecoder/scripts/tokenizer/detokenizer.perl -l en > $output_file.post

python ./train_and_test_scripts/converter.py $output_file.post
