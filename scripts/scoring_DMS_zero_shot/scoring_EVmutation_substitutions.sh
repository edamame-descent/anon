#!/bin/bash
#SBATCH -c 1                               # 1 core
#SBATCH -t 0-00:30                        # Runtime of 5 minutes, in D-HH:MM format
#SBATCH -p short                           # Run in short partition
#SBATCH --mem=20G   
#SBATCH --mail-type=TIME_LIMIT_80,FAIL,ARRAY_TASKS
#SBATCH --mail-user="daniel_ritter@hms.harvard.edu"

#SBATCH --job-name="EVmut_scoring"

# Job array-specific
#SBATCH --output=./slurm/evmutation/%A_%3a-%x.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/evmutation/%A_%3a-%x.err   # Optional: Redirect STDERR to its own file
# Set the number of tasks (number of rows in the CSV file)
#SBATCH --array=0,1,2

module load miniconda3/4.10.3

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/ecs_test_0822

export output_score_folder=${DMS_output_score_folder_subs}/EVmutation/

/n/groups/marks/software/anaconda_o2/envs/ecs_test_0822/bin/python ../../proteingym/baselines/EVmutation/score_mutants.py \
    --DMS_index ${SLURM_ARRAY_TASK_ID} \
    --DMS_data_folder $DMS_data_folder_subs \
    --model_folder "/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVCouplings_runs_no_column_cov/alignment_runs" \
    --output_scores_folder $output_score_folder \
    --DMS_reference_file_path ${DMS_reference_file_path_subs}