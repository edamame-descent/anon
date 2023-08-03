#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=../../slurm_stdout/slurm-%j.out
#SBATCH --error=../../slurm_stdout/slurm-%j.err
#SBATCH --job-name="PTeval"
#SBATCH --array=0-2,4-6
#0-6

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_transformer_env

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/RITA/small"
# export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/RITA/RITA_small_substitutions.csv"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/RITA/medium"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/RITA/RITA_medium_substitutions.csv"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/RITA/large"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/RITA/RITA_large_substitutions.csv"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/RITA/xlarge"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/RITA/RITA_xlarge_substitutions.csv"

export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/clinical_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/substitutions'


srun python3 ../../proteingym/baselines/rita/compute_fitness.py \
            --RITA_model_path ${RITA_model_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file} \
            --indel_mode