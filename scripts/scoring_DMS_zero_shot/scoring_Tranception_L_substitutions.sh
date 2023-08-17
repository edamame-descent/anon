#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 30:00:00
#SBATCH --mem=80G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/tranception/tranception-large-%A_%3a-%x.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/tranception/tranception-large-%A_%3a-%x.err   # Optional: Redirect STDERR to its own file
#SBATCH --job-name="tranception_l_scoring"
# #SBATCH --array=0,3-7,9,10,12-82
# #SBATCH --array=3,17,29,45,59
#SBATCH --array=1,2,8,11

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new
export PATH_TO_MSA=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_test
export PATH_TO_MSA_WEIGHTS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_v2/substitutions_MSAs
export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Tranception/Tranception_L
export INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE=$SLURM_ARRAY_TASK_ID

#Remove srun
#############################################################################################################################

source activate /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel

# Replace the following paths based on where you store models and data
export checkpoint=$PATH_TO_MODEL_CHECKPOINT
export DMS_data_folder=$PATH_TO_DMS_SUBSTITUTIONS
export DMS_index=$INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE
export output_scores_folder=$PATH_TO_OUTPUT_SCORES
export MSA_folder=$PATH_TO_MSA
export MSA_weights_folder=$PATH_TO_MSA_WEIGHTS_SUBSTITUTIONS 

export DMS_reference_file_path="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv"

srun python ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --inference_time_retrieval \
                --MSA_folder ${MSA_folder} \
                --MSA_weights_folder ${MSA_weights_folder}