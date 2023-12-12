#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:24G
#SBATCH -p gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --requeue

#SBATCH -t 12:00:00
#SBATCH --mem=48G
#SBATCH --output=./slurm/rita_indels/%x-%A_%3a-%x-%u.out
#SBATCH --error=./slurm/rita_indels/%x-%A_%3a-%x-%u.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="rita-xlarge"
#SBATCH --array=0-2
# Fail fully on first line failure
set -e

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
# export output_scores_folder="${DMS_output_score_folder_indels}/RITA/small"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
# export output_scores_folder="${DMS_output_score_folder_indels}/RITA/medium"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
# export output_scores_folder="${DMS_output_score_folder_indels}/RITA/large"

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
export output_scores_folder="${DMS_output_score_folder_indels}/RITA/xlarge"

python ../../proteingym/baselines/rita/compute_fitness.py \
            --RITA_model_name_or_path ${RITA_model_path} \
            --DMS_reference_file_path ${DMS_reference_file_path_subs} \
            --DMS_data_folder ${DMS_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --indel_mode
echo "Done"