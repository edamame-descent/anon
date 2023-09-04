#!/bin/bash 

source activate proteingym_env

export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions
export PATH_TO_MODEL_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/merged_scores_20230613
export PATH_TO_OUTPUT_PERFORMANCE=../../output/all_scores_20230613
export DMS_reference_file_path=../../reference_files/DMS_substitutions.csv

#############################################################################################################################

export model_list="all_models"
# Replace the following paths based on where you store models and data
export DMS_data_folder=$PATH_TO_DMS_SUBSTITUTIONS
export input_scoring_files_folder=$PATH_TO_MODEL_SCORES
export output_performance_file_folder=$PATH_TO_OUTPUT_PERFORMANCE

python ../../proteingym/performance_DMS_benchmarks.py \
                --model_list ${model_list} \
                --input_scoring_files_folder ${input_scoring_files_folder} \
                --output_performance_file_folder ${output_performance_file_folder} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} 
                ##--performance_by_depth