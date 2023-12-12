#!/bin/bash 
#SBATCH --cpus-per-task=20

# For typical short jobs
#SBATCH -t 0-11:59 # time (D-HH:MM)
#SBATCH --mem=20G  # tmp OOM issue
#SBATCH -p priority,short

# For OOM/time issues
##SBATCH -t 4-00:00 # time (D-HH:MM)
##SBATCH --mem=80G  # tmp OOM issue
##SBATCH -p priority,medium

##SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
##SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"

#SBATCH --output=./slurm/eve_weights/%x-%A_%3a-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/eve_weights/%x-%A_%3a-%u.err

#SBATCH --job-name="eve_weights_2023_10_18"
#SBATCH --array=0 # Take CSV line numbers minus 2 (they're 1-based and ignore header row)
# Fail on first error
set -eo pipefail 

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"

source ../zero_shot_config.sh

# EVE example
export DMS_index=${SLURM_ARRAY_TASK_ID}
echo "DMS index: ${DMS_index}"

srun python ../../proteingym/baselines/EVE/calc_weights.py \
    --MSA_data_folder ${DMS_MSA_data_folder} \
    --DMS_reference_file_path ${DMS_reference_file_path_subs} \
    --DMS_index "${DMS_index}" \
    --MSA_weights_location ${DMS_MSA_weights_folder} \
    --num_cpus -1 \
    --calc_method evcouplings \
    --threshold_focus_cols_frac_gaps 1 \
    --skip_existing
    #--overwrite

echo "Done"
