#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-18:00  # time (D-HH:MM)
#SBATCH --mem=32G
#SBATCH --gres=gpu:1,vram:24G
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu_requeue,gpu,gpu_marks
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/pmpnn/%x-%A_%3a-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/pmpnn/%x-%A_%3a-%u.err
#SBATCH --job-name="ProteinMPNN"
#SBATCH --array=0-2

module load miniconda3/4.10.3
module load gcc/9.2.0
module load cuda/11.2

source ../zero_shot_config.sh
source activate proteingym_env

export output_scores_folder=${DMS_output_score_folder_subs}/ProteinMPNN

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ProteinMPNN/v_48_020.pt
export DMS_index=$SLURM_ARRAY_TASK_ID

srun python ../../proteingym/baselines/protein_mpnn/compute_fitness.py \
    --checkpoint ${model_checkpoint} \
    --structure_folder ${DMS_structure_folder} \
    --DMS_index $DMS_index \
    --DMS_reference_file_path ${DMS_reference_file_path_subs} \
    --DMS_data_folder ${DMS_data_folder_subs} \
    --output_scores_folder ${output_scores_folder}