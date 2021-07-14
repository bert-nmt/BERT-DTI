FAIRSEQ=/tmp/bert-nmt


python $FAIRSEQ/preprocess.py \
--source-lang x --target-lang y \
--trainpref train.bpe \
--validpref valid.bpe \
--testpref test.bpe \
--destdir data-bin-PubMedBERT \
--joined-dictionary \
--workers 6 \
--bert-model-name microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract


# If you want to reuse dictionary, please remove --joined-dictionary, and specific --srcdict xxx and --tgtdict xxx
# You CANNOT use --srcdict/--tgtdict and --joined-dictionary at the same time