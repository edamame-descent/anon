#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 96:00:00
#SBATCH --mem=48G
#SBATCH --output=./slurm/tranception/%A_%3a-%x.out
#SBATCH --error=./slurm/tranception/%A_%3a-%x.err
#SBATCH --job-name="scoring_tranception_L"
#SBATCH --array=0
# #SBATCH --array=0-1554%50

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export output_scores_folder="${clinical_output_score_folder_indels}/Tranception/Tranception_L"

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder="${clinical_output_score_folder_indels}/Tranception/Tranception_M"

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
# export output_scores_folder="${clinical_output_score_folder_indels}/Tranception/Tranception_S"

export DMS_index=$SLURM_ARRAY_TASK_ID

# Clustal Omega is required when scoring indels with retrieval (not needed if scoring indels with no retrieval)
export clustal_omega_location=/home/pn73/clustal-omega-binaries/clustalo

# Leveraging retrieval when scoring indels require batch size of 1 (no retrieval can use any batch size fitting in memory)
export batch_size_inference=1 

srun python3 ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --batch_size_inference ${batch_size_inference} \
                --DMS_reference_file_path ${clinical_reference_file_path_indels} \
                --DMS_data_folder ${clinical_data_folder_indels} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --indel_mode \
                --clustal_omega_location ${clustal_omega_location} \
                --inference_time_retrieval \
                --MSA_folder ${clinical_MSA_data_folder_indels} \
                --MSA_weights_folder ${clinical_MSA_weights_folder_indels} 