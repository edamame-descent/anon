#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:24G
#SBATCH -p gpu_quad,gpu_marks,gpu_requeue,gpu
#SBATCH --qos gpuquad_qos
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/tranception/%A_%3a-%x.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/tranception/%A_%3a-%x.err   # Optional: Redirect STDERR to its own file
#SBATCH --job-name="tranception_L_scoring"
#SBATCH --array=0-2

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
# export output_scores_folder=${DMS_output_score_folder_subs}/Tranception/Tranception_S

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder=${DMS_output_score_folder_subs}/Tranception/Tranception_M

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export output_scores_folder=${DMS_output_score_folder_subs}/Tranception/Tranception_L

export DMS_index=$SLURM_ARRAY_TASK_ID

srun python ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path_subs} \
                --DMS_data_folder ${DMS_data_folder_subs} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --inference_time_retrieval \
                --MSA_folder ${DMS_MSA_data_folder} \
                --MSA_weights_folder ${DMS_MSA_weights_folder}