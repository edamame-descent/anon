#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 24:00:00
#SBATCH --mem=90G
#SBATCH --output=./slurm/unirep/%A_%3a-%x.out
#SBATCH --error=./slurm/unirep/%A_%3a-%x.err
#SBATCH --job-name="Uni"
#SBATCH --array=0-6

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export model_path=/home/pn73/protein_transformer/baselines/Unirep/1900_weights
export output_dir="${clinical_output_score_folder_indels}/Unirep"

srun python ../../proteingym/baselines/unirep/unirep_inference.py \
            --model_path $model_path \
            --data_path $clinical_data_folder_indels \
            --output_dir $output_dir \
            --mapping_path $clinical_reference_file_path_indels \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --batch_size 32