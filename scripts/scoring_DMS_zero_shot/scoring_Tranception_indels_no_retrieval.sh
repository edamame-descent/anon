#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1,vram:24G
# #SBATCH -p gpu_quad,gpu_requeue,gpu,gpu_marks
#SBATCH -p gpu_requeue
#SBATCH --requeue
#SBATCH --qos gpuquad_qos 
#SBATCH -t 24:00:00
#SBATCH --mem=48G 
#SBATCH --output=./slurm/tranception_indels/%A_%3a-%x.out
#SBATCH --error=./slurm/tranception_indels/%A_%3a-%x.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="tranception_L_no_retrieval"
#SBATCH --array=0-2

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export output_scores_folder=${DMS_output_score_folder_indels}/Tranception_no_retrieval/Tranception_L

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder=${DMS_output_score_folder_indels}/Tranception_no_retrieval/Tranception_M

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
# export output_scores_folder=${DMS_output_score_folder_indels}/Tranception_no_retrieval/Tranception_S

export DMS_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels/
export DMS_index=$SLURM_ARRAY_TASK_ID

srun python ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path_indels} \
                --DMS_data_folder ${DMS_data_folder_subs} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --indel_mode 
echo "Done"