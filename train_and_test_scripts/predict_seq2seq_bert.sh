

## if [ ! -d "/tmp/bert-nmt" ]; then
#	cd /tmp
#	git clone https://github.com/bert-nmt/bert-nmt
#	git clone https://github.com/moses-smt/mosesdecoder.git
#	cd bert-nmt
#
#	git checkout update-20-10
#	pip install --editable . --user
#	pip install transformers==3.5.0 --user
## fi
#export MKL_THREADING_LAYER=GNU
#pip install torch==1.5.0  # to load new version checkpoint

FAIRSEQ=/tmp/bert-nmt

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
--bert-model-name bert-base-uncased \
--beam 5 --batch-size 128 --remove-bpe --skip-invalid-size-inputs-valid-test > $output_file

cat $output_file | grep ^H | sort -nr -k1.2 | cut -f3- | perl /tmp/mosesdecoder/scripts/tokenizer/detokenizer.perl -l en > $output_file.post

python ./train_and_test_scripts/converter.py $output_file.post