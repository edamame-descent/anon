#!/bin/bash 

source activate proteingym_env

# Replace or uncomment the following based on where you store models and data and what DMS index/model you want to run

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
# export output_scores=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Tranception/Tranception_L

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Tranception/Tranception_M

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
export output_scores_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/Tranception/Tranception_S #scores_indels_final

# Clustal Omega is required when scoring indels with retrieval (not needed if scoring indels with no retrieval)
export clustal_omega_location=/n/groups/marks/projects/indels_human/indels_benchmark/clustal/clustalo-1.2.4-Ubuntu
export DMS_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels_merged
export protein_index=52
export MSA_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs
export MSA_weights_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_merged/DMS_substitutions_MSAs

export DMS_reference_file_path="../../reference_files/DMS_indels.csv"
# Leveraging retrieval when scoring indels require batch size of 1 (no retrieval can use any batch size fitting in memory)
export batch_size_inference=1 

python ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --batch_size_inference ${batch_size_inference} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${protein_index} \
                --output_scores_folder ${output_scores_folder} \
                --indel_mode \
                --clustal_omega_location ${clustal_omega_location} \
                --inference_time_retrieval \
                --MSA_folder ${MSA_folder} \
                --MSA_weights_folder ${MSA_weights_folder} 
                
                #--scoring_window 'optimal'
                