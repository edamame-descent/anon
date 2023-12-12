#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 72:00:00
#SBATCH --mem=90G
#SBATCH --output=./slurm/protgpt2/%A_%4a-%x-%u.out
#SBATCH --error=./slurm/protgpt2/%A_%4a-%x-%u.err
#SBATCH --job-name="PTeval"
#SBATCH --array=0-2,4-6,12-21

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

export ProtGP2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ProtGPT2"
export output_scores_folder="${clinical_output_score_folder_subs}/ProtGPT2"

srun python3 ../../proteingym/baselines/protgpt2/compute_fitness.py \
            --ProtGP2_model_name_or_path ${ProtGP2_model_name_or_path} \
            --DMS_reference_file_path ${clinical_reference_file_path_subs} \
            --DMS_data_folder ${clinical_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --indel_mode