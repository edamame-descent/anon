#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -p short
#SBATCH -t 06:00:00
#SBATCH --mem=48G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/gemme/gemme-%A_%3a-%x.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/gemme/gemme-%A_%3a-%x.err   # Optional: Redirect STDERR to its own file
#SBATCH --job-name="gemme_scoring"
#SBATCH --array=0-2

module load miniconda3/4.10.3
module load gcc/9.2.0
module load java/jdk-11.0.11
module load R/4.3.1

source ../zero_shot_config.sh
source activate proteingym_env

export DMS_index=$SLURM_ARRAY_TASK_ID
export GEMME_LOCATION="/n/groups/marks/software/GEMME/GEMME"
export JET2_LOCATION="/n/groups/marks/software/JET2/JET2"
export TEMP_FOLDER="./gemme_tmp/"
export DMS_output_score_folder="${DMS_output_score_folder_subs}/GEMME/"

srun python ../../proteingym/baselines/gemme/compute_fitness.py --DMS_index=$DMS_index --DMS_reference_file_path=$DMS_reference_file_path_subs \
--DMS_data_folder=$DMS_data_folder_subs --MSA_folder=$DMS_MSA_data_folder --output_scores_folder=$DMS_output_score_folder \
--GEMME_path=$GEMME_LOCATION --JET_path=$JET2_LOCATION --temp_folder=$TEMP_FOLDER