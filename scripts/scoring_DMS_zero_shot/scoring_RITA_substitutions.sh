#!/bin/bash 

source activate proteingym_env

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/small"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_small.csv"

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/medium"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_medium.csv"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/large"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_large.csv"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/xlarge"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_xlarge.csv"

export DMS_reference_file_path='../../reference_files/DMS_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged'


python ../../proteingym/baselines/rita/compute_fitness.py \
            --RITA_model_name_or_path ${RITA_model_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}