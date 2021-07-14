ARCH=transformer_iwslt_de_en
FAIRSEQ=/blob2/yinxia/wu2/code/fairseq
export PYTHONPATH=$FAIRSEQ:$PYTHONPATH



encL=2
decL=2
dr=$1
wd=0
las=$2
lr=$3
warm=8000
hid=256

DATA_PATH=$4  # path to the processed /data-bin, eg: ./data/seq2seq/data-bin
SAVEDIR=./models/vanilla-encL${encL}_decL${decL}_H256-dr$dr-ls$las-lr$lr

mkdir -p $SAVEDIR

python $FAIRSEQ/train.py $DATA_PATH \
--fp16 \
--source-lang x --target-lang y \
--arch $ARCH --share-all-embeddings \
--optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
--lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates $warm \
--lr $lr --min-lr 1e-09 \
--dropout $dr --weight-decay $wd \
--criterion label_smoothed_cross_entropy --label-smoothing $las \
--max-epoch 150 --keep-interval-updates 100 \
--max-tokens 24000 --no-progress-bar \
--save-dir $SAVEDIR \
--seed 1 \
--restore-file checkpoint_last.pt \
--update-freq 1 \
--attention-dropout 0.1 \
--activation-dropout 0.1 \
--distributed-no-spawn \
--encoder-layers $encL \
--decoder-layers $decL \
--ddp-backend "no_c10d" \
--no-epoch-checkpoints \
--encoder-embed-dim $hid \
--decoder-embed-dim $hid --skip-invalid-size-inputs-valid-test | tee $SAVEDIR/training.log
