#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:48G
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH -t 12:00:00
#SBATCH --mem=48G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/rita/%A_%3a-%x.out
#SBATCH --error=./slurm/rita/%A_%3a-%x.err
#SBATCH --job-name="RITA_xlarge"
#SBATCH --array=0-2

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"

source ../zero_shot_config.sh
source activate proteingym_env

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
# export output_scores_folder="${DMS_output_score_folder_subs}/RITA/small"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
# export output_scores_folder="${DMS_output_score_folder_subs}/RITA/medium"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
# export output_scores_folder="${DMS_output_score_folder_subs}/RITA/large"

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
export output_scores_folder="${DMS_output_score_folder_subs}/RITA/xlarge"



srun python ../../../proteingym/baselines/rita/compute_fitness.py \
            --RITA_model_name_or_path ${RITA_model_path} \
            --DMS_reference_file_path ${DMS_reference_file_path_subs} \
            --DMS_data_folder ${DMS_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder}