#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad,gpu,gpu_marks
#SBATCH --qos=gpuquad_qos
#SBATCH -t 0:45:00
#SBATCH --mem=32G
#SBATCH --output=./slurm/progen2_indels/slurm-%j.out
#SBATCH --error=./slurm/progen2_indels/slurm-%j.err
#SBATCH --job-name="ProBFD_base"
# #SBATCH --array=0-2,4-6,12-21
#SBATCH --array=8,9,11-74

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate /n/groups/marks/software/anaconda_o2/envs/indels_env

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-small/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_small_indels.csv"

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/v2_indel_scores/Progen2/medium"
export performance_file="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/performance_files/progen2_medium_indels.csv"

# export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
# export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-base/indels_v2"
# export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_base_indels2.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-large/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_large_indels.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-xlarge/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_xlarge_indels.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-oas"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-oas/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_oas_indels.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-BFD90"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/progen2/progen2-BFD90/indels"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_BFD90_indels.csv"

#export DMS_reference_file_path='/home/pn73/Tranception/proteingym/ProteinGym_reference_file_indels.csv'
#export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/DMS_files/ProteinGym_indels'

export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/DMS_indels_reference_file_reduced_2023_08_16.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels_new'

srun python3 ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file} \
            --indel_mode