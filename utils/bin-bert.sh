# Note: to use bert-nmt with pubmedbert, you should do as follows:
#    https://github.com/bert-nmt/bert-nmt
#    cd bert-nmt
#    git checkout update-20-10
#    pip install --editable . --user

# That is not enough. There is some bug with this version. To use it correctly,
#    go to fairseq/binarizer.py, Line 50 to 52, change `dict.model_max_length` to 512 (3 places in total)

FAIRSEQ=/path_to_bert-nmt_code/bert-nmt



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