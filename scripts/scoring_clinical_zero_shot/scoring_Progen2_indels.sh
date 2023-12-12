#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=./slurm/progen2/%A_%3a-%x.out
#SBATCH --error=./slurm/progen2/%A_%3a-%x.err
#SBATCH --job-name="progen2_clinical_indels"
#SBATCH --array=0-2,4-6,12-21

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
#export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/small"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
#export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/medium"

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/base"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
#export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/large"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
#export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/xlarge"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-oas"
#export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/oas"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-BFD90"
#export output_scores_folder="${clinical_output_score_folder_indels}/Progen2/bfd90"


srun python3 ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${clinical_reference_file_path_indels} \
            --DMS_data_folder ${clinical_data_folder_indels} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --indel_mode