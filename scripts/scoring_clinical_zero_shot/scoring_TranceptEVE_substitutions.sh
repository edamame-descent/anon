#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:12G
#SBATCH -p gpu_quad,gpu,gpu_requeue
#SBATCH --requeue
#SBATCH --qos=gpuquad_qos
#SBATCH -t 0-00:30
#SBATCH --mem=60G
#SBATCH --output=./slurm/trancepteve/%A_%3a-%x.out
#SBATCH --error=./slurm/trancepteve/%A_%3a-%x.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="trancepteve_m_clinical_subs"
# #SBATCH --array=0-2524
#SBATCH --array=0
module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh 
source activate proteingym_env

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
# export output_scores_folder=${clinical_output_score_folder_subs}/TranceptEVE/TranceptEVE_S

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
export output_scores_folder=${clinical_output_score_folder_subs}/TranceptEVE/TranceptEVE_M

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
# export output_scores_folder=${clinical_output_score_folder_subs}/TranceptEVE/TranceptEVE_L

export DMS_index=$SLURM_ARRAY_TASK_ID
export DMS_reference_file_path="../../reference_files/clinical_substitutions.csv"
export inference_time_retrieval_type="TranceptEVE"
export EVE_num_samples_log_proba=200000 
export EVE_model_parameters_location="../../proteingym/baselines/trancepteve/trancepteve/utils/eve_model_default_params.json"
export EVE_seeds="0"
export scoring_window="optimal" 
srun python ../../proteingym/baselines/trancepteve/score_trancepteve.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${clinical_reference_file_path_subs} \
                --DMS_data_folder ${clinical_data_folder_subs} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --inference_time_retrieval_type ${inference_time_retrieval_type} \
                --MSA_folder ${clinical_MSA_data_folder_subs} \
                --MSA_weights_folder ${clinical_MSA_weights_folder_subs} \
                --EVE_num_samples_log_proba ${EVE_num_samples_log_proba} \
                --EVE_model_parameters_location ${EVE_model_parameters_location} \
                --EVE_model_folder ${clinical_EVE_model_folder} \
                --scoring_window ${scoring_window} \
                --EVE_seeds ${EVE_seeds} \
                --EVE_recalibrate_probas \
                --clinvar_scoring