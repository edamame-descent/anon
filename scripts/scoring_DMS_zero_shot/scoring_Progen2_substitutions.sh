#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 72:00:00
#SBATCH --mem=48G
#SBATCH --output=./slurm/progen2-small-%j.out
#SBATCH --error=./slurm/progen2-small-%j.err
#SBATCH --job-name="Progen2"
# #SBATCH --array=0-78%10
# #SBATCH --array=3,4,8,13
#SBATCH --array=15

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

source activate /home/dar0842/.conda/envs/tranception_env

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Progen2/small"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_small.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Progen2/medium"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_medium.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Progen2/base"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_base.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Progen2/large"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_large.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Progen2/xlarge"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_xlarge.csv"

# export DMS_reference_file_path='/home/pn73/ProteinGym/ProteinGym_reference_file_substitutions.csv'
# export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions'
# export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_filtered_08_07_2023.csv' 
export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new'

srun python3 ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}