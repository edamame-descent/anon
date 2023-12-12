#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1 #,vram:24G  # Large: >=24G, and 90G RAM
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
# #SBATCH -p gpu_requeue
#SBATCH --qos gpuquad_qos
#SBATCH --requeue
# Exclude A100 and A40s, for smaller jobs
# #SBATCH --exclude="compute-g-17-162,compute-g-17-163,compute-g-17-164,compute-g-17-165,compute-gc-17-249,compute-gc-17-252,compute-gc-17-253,compute-gc-17-254"

#SBATCH -t 0-12:00
#SBATCH --mem=80G
#SBATCH --output=./slurm/tranception_indels/%x-%A_%3a-%x.out
#SBATCH --error=./slurm/tranception_indels/%x-%A_%3a-%x.err

#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
# #SBATCH --mail-user="daniel_ritter@hms.harvard.edu"
#SBATCH --job-name="tranception_S_indels"
# #SBATCH --array=0
#SBATCH --array=1-45

set -e  # Fail fully on first line failure

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
# export output_scores_folder=${DMS_output_score_folder_indels}/Tranception/Tranception_L

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder=${DMS_output_score_folder_indels}/Tranception/Tranception_M

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
export output_scores_folder=${DMS_output_score_folder_indels}/Tranception/Tranception_S

export DMS_index=$SLURM_ARRAY_TASK_ID
export clustal_omega_location=/n/groups/marks/projects/indels_human/indels_benchmark/clustal/clustalo-1.2.4-Ubuntu
# Leveraging retrieval when scoring indels require batch size of 1 (no retrieval can use any batch size fitting in memory)
export batch_size_inference=1 
export DMS_reference_file_path_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/split_capsd.csv"
export DMS_data_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/split_CAPSD_library"

python3 ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --batch_size_inference ${batch_size_inference} \
                --DMS_reference_file_path ${DMS_reference_file_path_indels} \
                --DMS_data_folder ${DMS_data_folder_indels} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --indel_mode \
                --clustal_omega_location ${clustal_omega_location} \
                --inference_time_retrieval \
                --MSA_folder ${DMS_MSA_data_folder} \
                --MSA_weights_folder ${DMS_MSA_weights_folder} 
                #--scoring_window 'optimal'
echo "Done"