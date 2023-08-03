#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 24:00:00
#SBATCH --mem=90G
#SBATCH --output=/home/pn73/protein_transformer/slurm_stdout/slurm-%j.out
#SBATCH --error=/home/pn73/protein_transformer/slurm_stdout/slurm-%j.err
#SBATCH --job-name="scoring_unirep_subs_evotune"
#SBATCH --array=0-6

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
# I'm guessing this model path won't work right off the bat for clinical 
export model_path=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/evotuning/substitutions
export data_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/substitutions
export output_dir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Unirep_evotune
export mapping_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/clinical_substitutions.csv

srun python ../../proteingym/baselines/unirep/unirep_inference.py \
            --model_path $model_path \
            --data_path $data_path \
            --output_dir $output_dir \
            --mapping_path $mapping_path \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --batch_size 32 \
            --evotune