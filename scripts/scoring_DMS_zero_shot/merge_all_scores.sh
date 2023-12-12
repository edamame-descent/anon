#!/bin/bash 
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu:1
#SBATCH -p gpu_marks
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=../slurm/merge/merge-%j.out
#SBATCH --error=../slurm/merge/merge-%j.err
#SBATCH --job-name="PG_merge"


module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.2

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

export mutation_type='substitutions'

python3 ../../proteingym/merge.py \
            --DMS_assays_location ${DMS_data_folder_subs} \
            --model_scores_location ${DMS_output_score_folder_subs} \
            --merged_scores_dir ${DMS_merged_score_folder_subs} \
            --mutation_type ${mutation_type}
