#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_marks
#SBATCH -t 01:00:00
#SBATCH --mem=8G
#SBATCH --output=./slurm/merge/merge-%j.out
#SBATCH --error=./slurm/merge/merge-%j.err
#SBATCH --job-name="PG_merge"


module load conda2/4.2.13

source ../zero_shot_config.sh
source activate proteingym_env 

export mutation_type='indels'

srun python3 ../../proteingym/merge.py \
            --DMS_assays_location ${DMS_data_folder_indels} \
            --model_scores_location ${DMS_output_score_folder_indels} \
            --merged_scores_dir ${DMS_merged_score_folder_indels} \
            --mutation_type ${mutation_type} \
            --DMS_reference_file ${DMS_reference_file_path_indels}