fname=$1
lang="en"

BINHOME="/tmp"
SCRIPTS=$BINHOME/mosesdecoder/scripts
TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
DETOK=$BINHOME/mosesdecoder/scripts/tokenizer/detokenizer.perl
LC=$SCRIPTS/tokenizer/lowercase.perl
CLEAN=$SCRIPTS/training/clean-corpus-n.perl
NORM_PUNC=$SCRIPTS/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$SCRIPTS/tokenizer/remove-non-printing-char.perl

M_THREADS=8

cat $fname | \
perl $LC | \
perl $NORM_PUNC $lang | \
perl $REM_NON_PRINT_CHAR | \
perl $TOKENIZER -threads $M_THREADS -l $lang -a > ${fname}.tok