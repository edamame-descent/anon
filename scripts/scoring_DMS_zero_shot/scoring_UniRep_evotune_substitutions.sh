#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 8:00:00
#SBATCH --mem=90G
#SBATCH --output=/home/pn73/protein_transformer/slurm_stdout/slurm-%j.out
#SBATCH --error=/home/pn73/protein_transformer/slurm_stdout/slurm-%j.err
#SBATCH --job-name="Uni"
#SBATCH --array=0-86

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export model_path=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/evotuning/substitutions
export data_path=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/DMS_files/ProteinGym_substitutions
export output_dir=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/Unirep_evotune/substitutions
export mapping_path=/home/pn73/Tranception/proteingym/ProteinGym_reference_file_substitutions.csv

srun python unirep_inference.py \
            --model_path $model_path \
            --data_path $data_path \
            --output_dir $output_dir \
            --mapping_path $mapping_path \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --batch_size 32 \
            --evotune