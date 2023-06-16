#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=../slurm/pgtp2-%j.out
#SBATCH --error=../slurm/pgtp2-%j.err
#SBATCH --job-name="pgtp2"
#SBATCH --array=93

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_transformer_env

export ProtGP2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ProtGPT2"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/ProtGPT2"
export performance_file="/home/pn73/ProteinGym/archives/performance_files/protgpt2_substitutions.csv"

export DMS_reference_file_path='/home/pn73/ProteinGym/ProteinGym_reference_file_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions'

srun python3 ../baselines/protgpt2/compute_fitness.py \
            --ProtGP2_model_name_or_path ${ProtGP2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}