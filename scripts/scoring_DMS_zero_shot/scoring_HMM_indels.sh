#!/bin/bash 

# source activate proteingym_env

# Note: HMMER needs to built with make dev to have the correct example scoring script we call within 
# our python script

export TEMP_FOLDER="./HMM_temp"
export OUTPUT_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/HMM"
export DMS_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels_merged"
export DMS_REFERENCE_FILE="../../reference_files/DMS_indels.csv"
export MSA_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged"
export HMMER_PATH="/n/groups/marks/software/jackhmmer/hmmer-3.3.1"
export protein_index=0
python ../../proteingym/baselines/HMM/score_hmm.py \
--DMS_reference_file=$DMS_REFERENCE_FILE --DMS_folder=$DMS_FOLDER \
--DMS_index=$protein_index \
--hmmer_path=$HMMER_PATH \
--MSA_folder=$MSA_FOLDER \
--output_scores_folder=$OUTPUT_FOLDER --intermediate_outputs_folder=$TEMP_FOLDER
