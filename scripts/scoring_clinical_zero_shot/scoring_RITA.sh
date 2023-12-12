#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=./slurm/rita/%A_%3a-%x.out
#SBATCH --error=./slurm/rita/%A_%3a-%x.err
#SBATCH --job-name="PTeval"
#SBATCH --array=0-2,4-6
#0-6

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_transformer_env

export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/small"
export output_scores_folder="${clinical_output_score_folder_subs}/RITA/small"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/medium"
#export output_scores_folder="${clinical_output_score_folder_subs}/RITA/medium"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/large"
#export output_scores_folder="${clinical_output_score_folder_subs}/RITA/large"

#export RITA_model_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/RITA/xlarge"
#export output_scores_folder="${clinical_output_score_folder_subs}/RITA/xlarge"

srun python3 ../../proteingym/baselines/rita/compute_fitness.py \
            --RITA_model_path ${RITA_model_path} \
            --DMS_reference_file_path ${clinical_reference_file_path_subs} \
            --DMS_data_folder ${clinical_data_folder_subs} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --indel_mode