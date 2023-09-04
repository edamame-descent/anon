#!/bin/bash 

source activate proteingym_env

export ProtGPT2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ProtGPT2"
export output_scores_folder="/n/groups/marks/users/daniel_r/test"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/protgpt2_substitutions.csv"

export DMS_reference_file_path='../../reference_files/DMS_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged'
export protein_index=0
python ../../proteingym/baselines/protgpt2/compute_fitness.py \
            --ProtGPT2_model_name_or_path ${ProtGPT2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $protein_index \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}