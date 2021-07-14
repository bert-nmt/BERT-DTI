#!/bin/bash
if [ ! -d "/tmp/bert-nmt" ]; then

	cd /tmp
	git clone https://github.com/bert-nmt/bert-nmt
	cd bert-nmt

	git checkout update-20-10
	pip install --editable . --user
	pip install transformers==3.5.0 --user
fi

FAIRSEQ=/tmp/bert-nmt

encL=2
decL=2
hid=256
dr=$1
las=$2
lr=$3

DATA_PATH=$4  # path to the processed /data-bin, eg: ./data/seq2seq/data-bin-PubMedBERT
SAVEDIR=./models/vanilla-encL${encL}_decL${decL}_H256-dr$dr-ls$las-lr$lr

ARCH=transformer_s2_iwslt_de_en

mkdir -p $SAVEDIR

### Note: According to our prev experiences and some exploration, to better utilise BERT, we should warm start from a pre-trained seq2seq model.
#if [ ! -f $SAVEDIR/checkpoint_last.pt ]; then
#  pretrained=/path to pretrained model/checkpoint_best.pt
#  warmup="--warmup-from-nmt --warmup-nmt-file $pretrained --reset-dataloader --reset-lr-scheduler --reset-optimizer --reset-meters"
#else
#  warmup=""
#fi
warmup=""

python $FAIRSEQ/train.py $DATA_PATH $warmup \
-s x -t y \
--arch $ARCH --share-all-embeddings \
--optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
--lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates 8000 \
--lr $lr --min-lr 1e-09 \
--dropout $dr --weight-decay 0.0 \
--criterion label_smoothed_cross_entropy --label-smoothing $las \
--encoder-layers $encL \
--decoder-layers $decL \
--encoder-embed-dim $hid \
--decoder-embed-dim $hid \
--keep-interval-updates 100 \
--max-tokens 24000  \
--max-update 150000 \
--save-dir $SAVEDIR \
--seed 1 \
--update-freq 1 \
--ddp-backend "no_c10d" \
--attention-dropout 0.1 \
--relu-dropout 0.1 \
--no-epoch-checkpoints \
--bert-model-name microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract  \
--encoder-bert-dropout --encoder-bert-dropout-ratio 0.5 \
--bert-gates 1 1  --skip-invalid-size-inputs-valid-test  | tee -a $SAVEDIR/training.log
