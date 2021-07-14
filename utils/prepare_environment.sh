pip install transformers==3.5.0 --user
pip install torch==1.5.0 --user

cp -R ./bert-nmt /tmp/
cd /tmp
git clone https://github.com/moses-smt/mosesdecoder.git

cd bert-nmt
git checkout update-20-10
pip install --editable . --user
