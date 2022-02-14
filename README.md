# BERT-DTI
This repo provide the experiment codes for the KD-DTI benchmark, which aims to extract Drug-Target Interaction knowledge from biomedical literatures.
Our code is based on BERT-NMT.

Public version dataset is aviailable at [here](https://www.dropbox.com/sh/0e52w6p7wiek9ab/AADfoBOTAUOJOaP6Yxfq75R-a?dl=0&lst=)

## Get stared:
### Prepare environment
Run `./utils/prepare_environment.sh` to install required package and install bert-nmt to default path `/tmp/bert-nmt/`


### Preprocess the raw data:
Run `./data_scripts/build_seq2seq_data.sh`: a script that preprocess the raw files, it takes two params:
- input_dir: path to dir contain json raw data
- output_dir: path to save processed seq2seq data
``` Tips: see example params in the scripts ```

In this step, we need to process raw input into train.x, train.y, valid.x, valid.y, test.x, test.y

For the \*.x files, each line is a document.

For the \*.y files, each line is made up of <d> drug_1 <r> relation_1 <t> target_1  <d> drug_2 <r> relation_2 <t> target_2, etc

```Notice!! Before processing the data, you should first register a DrugBank account, download the xml data set, and replace the entity id with the entity name in the drugbank.```

### Tokenize and Binarize data:
Run `./data_scripts/move_and_bin_data.sh`: a script that tokenize and binarize the preprocessed files, it takes two params:
- input_dir: path to seq2seq raw data
- script_dir: code dir for BERT-DTI
``` Tips: see example params in the scripts ```

In this step, we first use `build_bpe_data.sh` to get the BPE data.

And get bin data for different settings:
- For conventional model, use `bin.sh`
- For bert model, use `bin-bert.sh`
- If you woud like to use PubMEBBERT, please use `bin-pubmedbert.sh`.


### Training and Inference
All train and inference scripts can be found at `./train_and_test_scripts/`

For training, run `./train_and_test_scripts/train_seq2seq{pretrained_model_name}.sh`, it takes four params:

- dr: dropout rate
- las: label smoothing rate
- lr: learning rate
- data_path: path to the processed /data-bin, eg: ./data/seq2seq/data-bin-BERT

For inference, run `./train_and_test_scripts/predict_seq2seq{pretrained_model_name}.sh`, it takes three params:
- model: path to checkpoint pt file
- data_path: path to dir of bin data
- output_file: path to result file


### Evaluation
Run `./evaluation_scripts/hard_match_evaluation.py` to get results
An example of usage is provided in `./evaluation_scripts/run_hard_eval.sh`
