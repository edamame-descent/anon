#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 96:00:00
#SBATCH --mem=48G
#SBATCH --output=../slurm/slurm-%j.out
#SBATCH --error=../slurm/slurm-%j.err
#SBATCH --job-name="scoring_tranception_S"
#SBATCH --array=0
# #SBATCH --array=0-1554%50

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
export PATH_TO_DMS_INDELS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/indels
export PATH_TO_MSA=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/clinical_indels_MSAs
export PATH_TO_MSA_WEIGHTS_INDELS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/clinical_indels_MSAs
export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_indels/Tranception/Tranception_S #scores_indels_final
export INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE=$SLURM_ARRAY_TASK_ID

export PATH_TO_CLUSTAL_OMEGA=/home/pn73/clustal-omega-binaries/clustalo
#Remove srun
#############################################################################################################################

source activate tranception_env

# Replace the following paths based on where you store models and data
export checkpoint=$PATH_TO_MODEL_CHECKPOINT
export DMS_data_folder=$PATH_TO_DMS_INDELS
export DMS_index=$INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE
export output_scores_folder=$PATH_TO_OUTPUT_SCORES
export MSA_folder=$PATH_TO_MSA
export MSA_weights_folder=$PATH_TO_MSA_WEIGHTS_INDELS
# Clustal Omega is required when scoring indels with retrieval (not needed if scoring indels with no retrieval)
export clustal_omega_location=$PATH_TO_CLUSTAL_OMEGA 

export DMS_reference_file_path="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/clinical_indels.csv"
# Leveraging retrieval when scoring indels require batch size of 1 (no retrieval can use any batch size fitting in memory)
export batch_size_inference=1 

srun python3 ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --batch_size_inference ${batch_size_inference} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --indel_mode \
                --clustal_omega_location ${clustal_omega_location} \
                --inference_time_retrieval \
                --MSA_folder ${MSA_folder} \
                --MSA_weights_folder ${MSA_weights_folder} 