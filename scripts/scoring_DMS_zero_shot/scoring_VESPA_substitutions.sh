#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad,gpu_requeue,gpu,gpu_marks
#SBATCH -p gpu_requeue
#SBATCH --requeue
#SBATCH --qos gpuquad_qos 
#SBATCH -t 12:00:00
#SBATCH --mem=24G  # 24G for small, 48G for M/L?
#SBATCH --output=./slurm/vespa/%A_%3a-%x.out
#SBATCH --error=./slurm/vespa/%A_%3a-%x.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="VESPA_scoring"

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate proteingym_env

export DMS_index_range_start=0
export DMS_index_range_end=10
export vespa_cache="/n/groups/marks/users/daniel_r/VESPA_cache"

python ../../proteingym/baselines/vespa/compute_fitness.py \
    --cache_location $vespa_cache \
    --DMS_reference_file_path $DMS_reference_file_path_subs \
    --MSA_data_folder $DMS_MSA_data_folder \
    --DMS_data_folder $DMS_data_folder_subs \
    --DMS_index_range_start $DMS_index_range_start \
    --DMS_index_range_end $DMS_index_range_end 
