#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 30:00:00
#SBATCH --mem=50G
#SBATCH --output=/home/pn73/proteingym_dev/slurm/trn-%j.out
#SBATCH --error=/home/pn73/proteingym_dev/slurm/trn-%j.err
#SBATCH --job-name="PTeval"
#SBATCH --array=87-99

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

#conda env update --file /home/pn73/protein_transformer/tranception_env.yml

export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions
export PATH_TO_MSA=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files
export PATH_TO_MSA_WEIGHTS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/substitutions_MSAs
export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Tranception/Tranception_L
export INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE=$SLURM_ARRAY_TASK_ID

#Remove srun
#############################################################################################################################

source activate tranception_env

# Replace the following paths based on where you store models and data
export checkpoint=$PATH_TO_MODEL_CHECKPOINT
export DMS_data_folder=$PATH_TO_DMS_SUBSTITUTIONS
export DMS_index=$INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE
export output_scores_folder=$PATH_TO_OUTPUT_SCORES
export MSA_folder=$PATH_TO_MSA
export MSA_weights_folder=$PATH_TO_MSA_WEIGHTS_SUBSTITUTIONS 

export DMS_reference_file_path="/home/pn73/ProteinGym/ProteinGym_reference_file_substitutions.csv"

export retrieval_inference_weight=0.6

srun python3 ~/proteingym_dev/proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} 
                #--inference_time_retrieval \
                #--MSA_folder ${MSA_folder} \
                #--MSA_weights_folder ${MSA_weights_folder} \
                #--retrieval_inference_weight ${retrieval_inference_weight}