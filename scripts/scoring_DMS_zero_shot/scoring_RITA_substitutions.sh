#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:rtx8000:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=40G
#SBATCH --output=../slurm/RITA-%j.out
#SBATCH --error=../slurm/RITA-%j.err
#SBATCH --job-name="RITA"
#SBATCH --array=87-99

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_transformer_env

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/small"
export performance_file="/home/pn73/ProteinGym/archives/rita_performance_files/RITA_small.csv"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/medium"
#export performance_file="/home/pn73/ProteinGym/archives/rita_performance_files/RITA_medium.csv"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/large"
#export performance_file="/home/pn73/ProteinGym/archives/rita_performance_files/RITA_large.csv"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/RITA/xlarge"
#export performance_file="/home/pn73/ProteinGym/archives/rita_performance_files/RITA_xlarge.csv"

export DMS_reference_file_path='/home/pn73/ProteinGym/ProteinGym_reference_file_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions'


srun python3 ../baselines/rita/compute_fitness.py \
            --RITA_model_name_or_path ${RITA_model_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}