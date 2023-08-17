#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=32G
#SBATCH --output=./slurm/rita/rita-xlarge-%j.out
#SBATCH --error=./slurm/rita/rita-xlarge-%j.err
#SBATCH --job-name="RITA"
# #SBATCH --array=0-82
# #SBATCH --array=33,35,38,64
#SBATCH --array=15

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

source activate /n/groups/marks/software/anaconda_o2/envs/indels_env

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/RITA/small"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_small.csv"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/RITA/medium"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_medium.csv"

# export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/RITA/large"
# export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_large.csv"

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/RITA/xlarge"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/RITA_xlarge.csv"

export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new'


srun python ../../proteingym/baselines/rita/compute_fitness.py \
            --RITA_model_name_or_path ${RITA_model_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}