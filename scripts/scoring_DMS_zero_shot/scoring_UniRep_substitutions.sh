#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 24:00:00
#SBATCH --mem=90G
#SBATCH --output=/home/pn73/proteingym_dev/slurm/unirep-%j.out
#SBATCH --error=/home/pn73/proteingym_dev/slurm/unirep-%j.err
#SBATCH --job-name="Uni"
#SBATCH --array=87
#0-86

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

#source activate protein_transformer_env
source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export model_path=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/1900_weights
export data_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions
export output_dir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions
export mapping_path=/home/pn73/proteingym_dev/reference_files/DMS_substitutions.csv

srun python ~/proteingym_dev/proteingym/baselines/unirep/unirep_inference.py \
            --model_path $model_path \
            --data_path $data_path \
            --output_dir $output_dir \
            --mapping_path $mapping_path \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --batch_size 8