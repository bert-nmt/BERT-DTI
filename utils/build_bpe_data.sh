BINHOME=/tmp

if [ ! -d $BINHOME/mosesdecoder ]; then
  git clone https://github.com/moses-smt/mosesdecoder $BINHOME/mosesdecoder
fi

if [ ! -d $BINHOME/fastBPE ]; then
  git clone https://github.com/glample/fastBPE $BINHOME/fastBPE
  cd  $BINHOME/fastBPE
  g++ -std=c++11 -pthread -O3 fastBPE/main.cc -IfastBPE -o fast
  cd $OLDPWD
fi

SCRIPTS=$BINHOME/mosesdecoder/scripts
LC=$SCRIPTS/tokenizer/lowercase.perl

cat train.x | perl $LC > train.bpe.bert.x
cat valid.x | perl $LC > valid.bpe.bert.x
cat test.x | perl $LC > test.bpe.bert.x

P=(train valid test)

for f in ${P[@]}; do
  x=$f.x
  y=$f.y
  bash prepare.sh $f.entity
  bash prepare.sh $x
  bash prepare.sh $y
done

for f in ${P[@]}; do
  python replacer.py $f.y.tok
  python replacer.py $f.x.tok
  python replacer.py $f.entity.tok
done

cat train.x.tok.r valid.x.tok.r  train.y.tok.r  valid.y.tok.r > tmp_all

if [ ! -d bpecodes ]; then
	$BINHOME/fastBPE/fast learnbpe 15000 tmp_all > bpecodes
fi

rm tmp_all

for p in ${P[@]}; do
  $BINHOME/fastBPE/fast applybpe ${p}.bpe.x ${p}.x.tok.r bpecodes
  python cutter.py ${p}.bpe.x
  rm ${p}.bpe.x
  mv ${p}.bpe.x.cut1020  ${p}.bpe.x
  $BINHOME/fastBPE/fast applybpe ${p}.bpe.y ${p}.y.tok.r bpecodes
  $BINHOME/fastBPE/fast applybpe ${p}.bpe.entity ${p}.entity.tok.r bpecodes
  python cutter.py ${p}.bpe.entity
  rm ${p}.bpe.entity
  mv ${p}.bpe.entity.cut1020 ${p}.bpe.entity
done


rm *.tok
rm *.tok.r