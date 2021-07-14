FAIRSEQ=/tmp/bert-nmt


python $FAIRSEQ/preprocess.py \
--source-lang x --target-lang y \
--trainpref train.bpe \
--validpref valid.bpe \
--testpref test.bpe \
--destdir data-bin \
--joined-dictionary \
--workers 20


# If you want to reuse dictionary, please remove --joined-dictionary, and specific --srcdict xxx and --tgtdict xxx
# You CANNOT use --srcdict/--tgtdict and --joined-dictionary at the same time

