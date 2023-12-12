#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1#,vram:24G  # small: any GPU, medium: 24G, large: 24G
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --requeue
#SBATCH --qos=gpuquad_qos
#SBATCH -t 0-16:00
#SBATCH --mem=80G
#SBATCH --output=./slurm/trancepteve_indels/%A_%3a-%x.out
#SBATCH --error=./slurm/trancepteve_indels/%A_%3a-%x.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
# #SBATCH --mail-user="daniel_ritter@hms.harvard.edu"
#SBATCH --job-name="trancepteve_s_indels"
# #SBATCH --array=0
#SBATCH --array=1-45

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
export output_scores_folder=${DMS_output_score_folder_indels}/TranceptEVE/TranceptEVE_S

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export output_scores_folder=${DMS_output_score_folder_indels}/TranceptEVE/TranceptEVE_M

# export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
# export output_scores_folder=${DMS_output_score_folder_indels}/TranceptEVE/TranceptEVE_L

# Temporary
# export DMS_reference_file_path_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/archive/tmp_BLAT_chunked/tmp_BLAT_reference.csv"
# export DMS_data_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/archive/tmp_BLAT_chunked/"
export DMS_reference_file_path_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/split_capsd.csv"
export DMS_data_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/split_CAPSD_library"
# Using the same output folder, we can concat inside there later?

# Replace the following paths based on where you store models and data
export DMS_index=$SLURM_ARRAY_TASK_ID
export inference_time_retrieval_type="TranceptEVE"
export EVE_num_samples_log_proba=200000 
export EVE_model_parameters_location="../../proteingym/baselines/trancepteve/trancepteve/utils/eve_model_default_params.json"
export EVE_seeds="0 1 2 3 4"
export scoring_window="optimal" 
export clustal_omega_location=/n/groups/marks/projects/indels_human/indels_benchmark/clustal/clustalo-1.2.4-Ubuntu
export batch_size_inference=1 
srun python3 ../../proteingym/baselines/trancepteve/score_trancepteve.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path_indels} \
                --DMS_data_folder ${DMS_data_folder_indels} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} \
                --inference_time_retrieval_type ${inference_time_retrieval_type} \
                --indel_mode \
                --batch_size_inference ${batch_size_inference} \
                --clustal_omega_location ${clustal_omega_location} \
                --MSA_folder ${DMS_MSA_data_folder} \
                --MSA_weights_folder ${DMS_MSA_weights_folder} \
                --EVE_num_samples_log_proba ${EVE_num_samples_log_proba} \
                --EVE_model_parameters_location ${EVE_model_parameters_location} \
                --EVE_model_folder ${DMS_EVE_model_folder} \
                --scoring_window ${scoring_window} \
                --EVE_seeds ${EVE_seeds} \
                --EVE_recalibrate_probas