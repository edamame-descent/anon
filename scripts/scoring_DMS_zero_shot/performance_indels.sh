#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 01:00:00
#SBATCH --mem=8G
#SBATCH --output=./slurm/performance/perf-%j.out
#SBATCH --error=./slurm/performance/perf-%j.err
#SBATCH --job-name="perf_indels"

module load miniconda3/4.10.3

source ../zero_shot_config.sh
source activate proteingym_env

export output_performance_file_folder=../../benchmarks/DMS_zero_shot/indels

srun python3 ../../proteingym/performance_DMS_benchmarks.py \
                --input_scoring_files_folder ${DMS_merged_score_folder_indels} \
                --output_performance_file_folder ${output_performance_file_folder} \
                --DMS_reference_file_path ${DMS_reference_file_path_indels} \
                --DMS_data_folder ${DMS_data_folder_indels} \
                --indel_mode
                ##--performance_by_depth