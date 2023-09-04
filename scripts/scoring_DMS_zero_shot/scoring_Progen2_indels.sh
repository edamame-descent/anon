#!/bin/bash 

# source activate proteingym_env

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Progen2/small"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_small_indels.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Progen2/medium"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_medium_indels.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Progen2/base"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_base_indels.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Progen2/large"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_large_indels.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Progen2/xlarge"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_xlarge_indels.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-oas"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-oas/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_oas_indels.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-BFD90"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-BFD90/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_BFD90_indels.csv"

#export DMS_reference_file_path='/home/pn73/Tranception/proteingym/ProteinGym_reference_file_indels.csv'
#export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/DMS_files/ProteinGym_indels'

export DMS_reference_file_path='../../reference_files/DMS_indels.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels_merged'
export protein_index=0
python ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $protein_index \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file} \
            --indel_mode