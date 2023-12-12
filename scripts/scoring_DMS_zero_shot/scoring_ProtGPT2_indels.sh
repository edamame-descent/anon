#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:24G
# #SBATCH -p gpu_quad,gpu,gpu_requeue,gpu_marks
#SBATCH -p gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --requeue

#SBATCH -t 3:00:00
#SBATCH --mem=32G
# tmp Lood disable emails
# #SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
# #SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/protgpt2_indels/pgtp2-%A_%3a-%x.out
#SBATCH --error=./slurm/protgpt2_indels/pgtp2-%A_%3a-%x.err
#SBATCH --job-name="PTeval"
#SBATCH --array=0-2

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/11.2

source ../zero_shot_config.sh
source activate proteingym_env

export ProtGPT2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ProtGPT2"
export output_scores_folder="${DMS_output_score_folder_indels}/ProtGPT2"

python ../../proteingym/baselines/protgpt2/compute_fitness.py \
            --ProtGPT2_model_name_or_path ${ProtGPT2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path_subs} \
            --DMS_data_folder ${DMS_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --indel_mode