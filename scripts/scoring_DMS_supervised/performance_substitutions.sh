#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 01:00:00
#SBATCH --mem=8G
#SBATCH --output=./slurm/performance/perf-%j.out
#SBATCH --error=./slurm/performance/perf-%j.err
#SBATCH --job-name="perf_subs"

module load miniconda3/4.10.3

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

export output_performance_file_folder=../../benchmarks/DMS_supervised/substitutions
export input_scoring_file=../../benchmarks/raw_score_files/DMS_supervised_substitutions.csv
export DMS_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/supervised_files

python3 ../../proteingym/performance_DMS_supervised_benchmarks.py \
                --input_scoring_file ${input_scoring_file} \
                --output_performance_file_folder ${output_performance_file_folder} \
                --DMS_reference_file_path ${DMS_reference_file_path_subs}