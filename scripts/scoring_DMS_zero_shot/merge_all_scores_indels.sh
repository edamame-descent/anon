#!/bin/bash 
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu:1
#SBATCH -p gpu_marks
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=/home/pn73/proteingym_dev/slurm/merge-%j.out
#SBATCH --error=/home/pn73/proteingym_dev/slurm/merge-%j.err
#SBATCH --job-name="PG_merge"


module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.2

#module load conda3/latest
#module load gcc/9.2.0
#module load cuda/11.7

#conda env update --file /home/pn73/protein_transformer/protein_transformer_env_O2.yml
#conda env update --file /home/pn73/proteingym_dev/proteingym_env.yml
#source activate proteingym_env
source activate protein_transformer_env

export DMS_assays_location=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels
export model_scores_location=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels
export merged_scores_dir='merged_scores_20230613'
export mutation_type='indels'

srun python3 ~/proteingym_dev/proteingym/merge.py \
            --DMS_assays_location ${DMS_assays_location} \
            --model_scores_location ${model_scores_location} \
            --merged_scores_dir ${merged_scores_dir} \
            --mutation_type ${mutation_type}