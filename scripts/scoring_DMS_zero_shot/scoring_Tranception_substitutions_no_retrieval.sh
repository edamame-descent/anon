#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-11:59  # time (D-HH:MM)
#SBATCH --mem=24G
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="tranception_L_no_retrieval_DMS_scoring"
#SBATCH -p gpu_quad,gpu_marks,gpu_requeue,gpu
#SBATCH --gres=gpu:1,vram:24G
#SBATCH --array=95
#SBATCH --output=./slurm/tranception_no_retrieval/%x-%A_%3a-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/tranception_no_retrieval/%x-%A_%3a-%u.err

# Fail on first error
set -e #uo pipefail

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"
echo "GPU available: $(nvidia-smi)"

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
export output_scores_folder=${DMS_output_score_folder_subs}/Tranception_no_retrieval/Tranception_S

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder=${DMS_output_score_folder_subs}/Tranception_no_retrieval/Tranception_M

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
# export output_scores_folder=${DMS_output_score_folder_subs}/Tranception_no_retrieval/Tranception_L

export DMS_index=$SLURM_ARRAY_TASK_ID

srun python ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path_subs} \
                --DMS_data_folder ${DMS_data_folder_subs} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} 
echo "Done"