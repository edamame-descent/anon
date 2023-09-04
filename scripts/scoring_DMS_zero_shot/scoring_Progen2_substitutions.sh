#!/bin/bash 

source activate proteingym_env

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/small"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_small.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/medium"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_medium.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/base"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_base.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/large"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_large.csv"

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/xlarge"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_xlarge.csv"

export DMS_reference_file_path='../../reference_files/DMS_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged'
export protein_index=0
python ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $protein_index \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}