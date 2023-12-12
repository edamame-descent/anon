#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -p short
#SBATCH -t 01:00:00
#SBATCH --mem=16G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/gemme/gemme-%A_%3a-%x.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/gemme/gemme-%A_%3a-%x.err   # Optional: Redirect STDERR to its own file
#SBATCH --job-name="gemme_scoring"
# #SBATCH --array=0-2524
#SBATCH --array=2309,2349,476,340,433

module load miniconda3/4.10.3
module load gcc/9.2.0
module load java/jdk-11.0.11
module load R/4.3.1


source activate proteingym_env

DMS_index=$SLURM_ARRAY_TASK_ID
OUTPUT_SCORES_FOLDER="${clinical_output_score_folder_subs}/GEMME"
GEMME_LOCATION="/n/groups/marks/software/GEMME/GEMME"
JET2_LOCATION="/n/groups/marks/software/JET2/JET2"
TEMP_FOLDER="./gemme_tmp/"

python ../../proteingym/baselines/gemme/compute_fitness.py --DMS_index=$DMS_index --DMS_reference_file_path=$clinical_reference_file_path_subs \
--DMS_data_folder=$clinical_data_folder_subs --MSA_folder=$clinical_MSA_data_folder_subs --output_scores_folder=$OUTPUT_SCORES_FOLDER \
--GEMME_path=$GEMME_LOCATION --JET_path=$JET2_LOCATION --temp_folder=$TEMP_FOLDER