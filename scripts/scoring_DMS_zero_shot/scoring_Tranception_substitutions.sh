#!/bin/bash 

source activate proteingym_env

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
# export output_scores_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Tranception/Tranception_S

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Tranception/Tranception_M

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export output_scores_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Tranception/Tranception_L

export DMS_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged
export MSA_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs
export protein_index=0
export MSA_weights_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_merged/DMS_substitutions_MSAs

export DMS_reference_file_path="../../reference_files/DMS_substitutions.csv"

python ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${protein_index} \
                --output_scores_folder ${output_scores_folder} \
                --inference_time_retrieval \
                --MSA_folder ${MSA_folder} \
                --MSA_weights_folder ${MSA_weights_folder}