#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_marks
#SBATCH -t 10:00:00
#SBATCH --mem=50G
#SBATCH --output=/home/pn73/proteingym_dev/slurm/perf-%j.out
#SBATCH --error=/home/pn73/proteingym_dev/slurm/perf-%j.err
#SBATCH --job-name="perf"

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate tranception_env

export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels
export PATH_TO_MODEL_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels/merged_scores_20230613
export PATH_TO_OUTPUT_PERFORMANCE=/home/pn73/proteingym_dev/output/all_scores_20230613_indels
export DMS_reference_file_path=/home/pn73/proteingym_dev/reference_files/DMS_indels.csv

#############################################################################################################################

export model_list="all_models"
# Replace the following paths based on where you store models and data
export DMS_data_folder=$PATH_TO_DMS_SUBSTITUTIONS
export input_scoring_files_folder=$PATH_TO_MODEL_SCORES
export output_performance_file_folder=$PATH_TO_OUTPUT_PERFORMANCE

srun python3 /home/pn73/proteingym_dev/proteingym/performance_DMS_benchmarks.py \
                --model_list ${model_list} \
                --input_scoring_files_folder ${input_scoring_files_folder} \
                --output_performance_file_folder ${output_performance_file_folder} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --indel_mode
                ##--performance_by_depth