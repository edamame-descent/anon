#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:32G  # xlarge: gpu:1,vram:32G
#SBATCH -p gpu_marks,gpu,gpu_quad,gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --requeue
#SBATCH -t 03:00:00
#SBATCH --mem=120G  # small, medium, large: 32G; xlarge: 120G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/progen2_indels/progen2-xlarge-%A_%3a-%x-%u.out
#SBATCH --error=./slurm/progen2_indels/progen2-xlarge-%A_%3a-%x-%u.err
#SBATCH --job-name="Progen2_xlarge"
#SBATCH --array=0-2  

# Fail fully on first line failure
set -e

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
# export output_scores_folder="${DMS_output_score_folder_indels}/Progen2/small"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
# export output_scores_folder="${DMS_output_score_folder_indels}/Progen2/medium"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
# export output_scores_folder="${DMS_output_score_folder_indels}/Progen2/base"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
# export output_scores_folder="${DMS_output_score_folder_indels}/Progen2/large"

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
export output_scores_folder="${DMS_output_score_folder_indels}/Progen2/xlarge"

srun python ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path_indels} \
            --DMS_data_folder ${DMS_data_folder_indels} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --indel_mode
echo "Done"