#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad,gpu,gpu_marks
#SBATCH --qos gpuquad_qos
#SBATCH -t 8:00:00
#SBATCH --mem=40G
#SBATCH --output=./slurm/unirep_evotune_scoring/unirep_evotune-%A_%3a-%x.out
#SBATCH --error=./slurm/unirep_evotune_scoring/unirep_evotune-%A_%3a-%x.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="unirep-evotune-scoring"
#SBATCH --array=0-2

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export model_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/UniRep/evotuning/DMS_substitutions
export output_dir=${DMS_output_score_folder_subs}/UniRep_evotuned

srun python ../../proteingym/baselines/unirep/unirep_inference.py \
            --model_path $model_path \
            --data_path $DMS_data_folder_subs \
            --output_dir $output_dir \
            --mapping_path $DMS_reference_file_path_subs \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --batch_size 32 \
            --evotune