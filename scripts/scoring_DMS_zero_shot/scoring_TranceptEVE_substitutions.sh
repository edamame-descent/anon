#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_marks
#SBATCH -t 30:00:00
#SBATCH --mem=40G
#SBATCH --output=../slurm/slurm-%j.out
#SBATCH --error=../slurm/slurm-%j.err
#SBATCH --job-name="PTeval"
#SBATCH --array=1-8

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

#conda env update --file /home/pn73/protein_transformer/tranception_env.yml

export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/DMS_files/ProteinGym_substitutions
export PATH_TO_MSA=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/MSA/MSA_EVEscape
export PATH_TO_MSA_WEIGHTS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/MSA/MSA_weights_tranceptEVE/EVEscape/all_positions
export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/TranceptEVE/EVEscape/proteingym 
export INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE=$SLURM_ARRAY_TASK_ID

export EVE_MODEL_FOLDER1=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/EVE/EVEscape/all_positions
export EVE_MODEL_FOLDER2=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/EVE/EVEscape/all_positions
export EVE_MODEL_FOLDER3=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/EVE/EVEscape/all_positions
export EVE_MODEL_FOLDER4=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/EVE/EVEscape/all_positions
export EVE_MODEL_FOLDER5=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/EVE/EVEscape/all_positions

#srun --gres=gpu:1 --partition=gpu_quad --mem=90G --cpus-per-task=8 -t 24:00:00 --pty bash
#srun --gres=gpu:1 --partition=gpu_marks --mem=90G --cpus-per-task=4 -t 24:00:00 --pty bash

#Remove srun
#############################################################################################################################

source activate tranception_env

# Replace the following paths based on where you store models and data
export checkpoint=$PATH_TO_MODEL_CHECKPOINT
export DMS_data_folder=$PATH_TO_DMS_SUBSTITUTIONS
export DMS_index=$INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE
export output_scores_folder=$PATH_TO_OUTPUT_SCORES
export MSA_folder=$PATH_TO_MSA
export MSA_weights_folder=$PATH_TO_MSA_WEIGHTS_SUBSTITUTIONS 

export EVE_model_folder1=$EVE_MODEL_FOLDER1
export EVE_model_folder2=$EVE_MODEL_FOLDER2
export EVE_model_folder3=$EVE_MODEL_FOLDER3
export EVE_model_folder4=$EVE_MODEL_FOLDER4
export EVE_model_folder5=$EVE_MODEL_FOLDER5

export DMS_reference_file_path="../proteingym/EVEscape_reference_file_substitutions.csv"
export inference_time_retrieval_type="TranceptEVE"
export EVE_num_samples_log_proba=200000 
export EVE_model_parameters_location="../trancepteve/utils/eve_model_default_params.json"

#export retrieval_inference_MSA_weight=0.3
#export retrieval_inference_EVE_weight=0.6
export scoring_window="optimal" 

srun python3 ../score_trancepteve.py \
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
                --EVE_model_folder ${EVE_model_folder1} ${EVE_model_folder2} ${EVE_model_folder3} ${EVE_model_folder4} ${EVE_model_folder5} \
                --scoring_window ${scoring_window} \
                --EVE_recalibrate_probas