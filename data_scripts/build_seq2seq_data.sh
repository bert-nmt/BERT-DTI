INPUT_DIR=$1  # path to dir contain json raw data
OUTPUT_DIR=$2  # path to save processed seq2seq data

# eg:
#INPUT_DIR=/KD-DTI/
#OUTPUT_DIR=./data/seq2seq/


echo Output to: $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

python ./data_scripts/preprocess_data.py ${INPUT_DIR}train.json  ${OUTPUT_DIR}train
python ./data_scripts/preprocess_data.py ${INPUT_DIR}valid.json  ${OUTPUT_DIR}valid
python ./data_scripts/preprocess_data.py ${INPUT_DIR}test.json  ${OUTPUT_DIR}test
