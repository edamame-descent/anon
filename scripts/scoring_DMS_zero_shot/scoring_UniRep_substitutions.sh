#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
# #SBATCH -p gpu_marks
#SBATCH -t 24:00:00
#SBATCH --mem=24G
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/unirep/unirep-%j.out
#SBATCH --error=./slurm/unirep/unirep-%j.err
#SBATCH --job-name="unirep-substitution-scoring"
# #SBATCH --array=1-82
#SBATCH --array=15
# #SBATCH --array=0
module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

#source activate protein_transformer_env
source activate /n/groups/marks/software/anaconda_o2/envs/protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export model_path=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/1900_weights
export data_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new
export output_dir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/UniRep
export mapping_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv

srun python ../../proteingym/baselines/unirep/unirep_inference.py \
            --model_path $model_path \
            --data_path $data_path \
            --output_dir $output_dir \
            --mapping_path $mapping_path \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --batch_size 8