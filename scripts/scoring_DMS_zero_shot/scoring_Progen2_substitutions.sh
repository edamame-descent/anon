#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH -t 06:00:00
#SBATCH --mem=24G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/progen2/%A_%3a-%x.out
#SBATCH --error=./slurm/progen2/%A_%3a-%x.err
#SBATCH --job-name="Progen2_small"
#SBATCH --array=86

# Fail on first error
set -e #uo pipefail

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
export output_scores_folder="${DMS_output_score_folder_subs}/Progen2/small"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
# export output_scores_folder="${DMS_output_score_folder_subs}/Progen2/medium"
 
# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
# export output_scores_folder="${DMS_output_score_folder_subs}/Progen2/base"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
# export output_scores_folder="${DMS_output_score_folder_subs}/Progen2/large"
 
# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
# export output_scores_folder="${DMS_output_score_folder_subs}/Progen2/xlarge"

srun python ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path_subs} \
            --DMS_data_folder ${DMS_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
echo "Done"