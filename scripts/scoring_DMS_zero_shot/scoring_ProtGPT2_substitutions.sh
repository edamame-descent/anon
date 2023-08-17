#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/protgpt2/pgtp2-%j.out
#SBATCH --error=./slurm/protgpt2/pgtp2-%j.err
#SBATCH --job-name="pgtp2"
# #SBATCH --array=2-82
# #SBATCH --array=1
#SBATCH --array=15

# env -u SLURM_MEM_PER_NODE -u SLURM_CPU_BIND

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/11.2

source activate /n/groups/marks/software/anaconda_o2/envs/indels_env

export ProtGPT2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ProtGPT2"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/ProtGPT2"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/protgpt2_substitutions.csv"

export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new'

srun python ../../proteingym/baselines/protgpt2/compute_fitness.py \
            --ProtGPT2_model_name_or_path ${ProtGPT2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}