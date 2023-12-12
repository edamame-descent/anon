#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:24G
#SBATCH -p gpu_quad,gpu,gpu_requeue,gpu_marks
#SBATCH --qos=gpuquad_qos
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/protgpt2/pgtp2-%A_%3a-%x.out
#SBATCH --error=./slurm/protgpt2/pgtp2-%A_%3a-%x.err
#SBATCH --job-name="pgtp2"
# #SBATCH --array=2-82
#SBATCH --array=95

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/11.2

source ../zero_shot_config.sh
source activate proteingym_env

export ProtGPT2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ProtGPT2"
export output_scores_folder="${DMS_output_score_folder_subs}/ProtGPT2"

srun python ../../proteingym/baselines/protgpt2/compute_fitness.py \
            --ProtGPT2_model_name_or_path ${ProtGPT2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path_subs} \
            --DMS_data_folder ${DMS_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder}