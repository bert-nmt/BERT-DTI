FAIRSEQ=/tmp/bert-nmt



python $FAIRSEQ/preprocess.py \
--source-lang x --target-lang y \
--trainpref train.bpe \
--validpref valid.bpe \
--testpref test.bpe \
--destdir data-bin-BERT \
--joined-dictionary \
--workers 20 \
--bert-model-name bert-base-uncased


# If you want to reuse dictionary, please remove --joined-dictionary, and specific --srcdict xxx and --tgtdict xxx
# You CANNOT use --srcdict/--tgtdict and --joined-dictionary at the same time