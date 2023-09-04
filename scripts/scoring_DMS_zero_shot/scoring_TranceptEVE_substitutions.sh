#!/bin/bash 

source activate proteingym_env

# replace the following paths based on where you store models and data and what DMS in the reference file you want to score 
export EVE_MODEL_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVE_runs/results/VAE_parameters"
export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
export DMS_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged
export DMS_index=175
# export output_scores_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/TranceptEVE/TranceptEVE_S
export output_scores_folder="/n/groups/marks/users/daniel_r/test"
export MSA_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs
export MSA_weights_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_merged/DMS_substitutions_MSAs

# export EVE_model_folder1=$EVE_MODEL_FOLDER1
# export EVE_model_folder2=$EVE_MODEL_FOLDER2
# export EVE_model_folder3=$EVE_MODEL_FOLDER3
# export EVE_model_folder4=$EVE_MODEL_FOLDER4
# export EVE_model_folder5=$EVE_MODEL_FOLDER5

export DMS_reference_file_path="../../reference_files/DMS_substitutions.csv"
export inference_time_retrieval_type="TranceptEVE"
export EVE_num_samples_log_proba=200000 
export EVE_model_parameters_location="../../proteingym/baselines/trancepteve/trancepteve/utils/eve_model_default_params.json"
export EVE_model_suffix="_proteingym_20230828_final"
#export retrieval_inference_MSA_weight=0.3
#export retrieval_inference_EVE_weight=0.6
export scoring_window="optimal" 
python ../../proteingym/baselines/trancepteve/score_trancepteve.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --inference_time_retrieval_type ${inference_time_retrieval_type} \
                --MSA_folder ${MSA_folder} \
                --MSA_weights_folder ${MSA_weights_folder} \
                --EVE_num_samples_log_proba ${EVE_num_samples_log_proba} \
                --EVE_model_parameters_location ${EVE_model_parameters_location} \
                --EVE_model_folder ${EVE_MODEL_FOLDER} \
                --scoring_window ${scoring_window} \
                --EVE_model_suffix ${EVE_model_suffix} \
                --EVE_recalibrate_probas