#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 1-12:00  # time (D-HH:MM)
#SBATCH --mem=32G
#SBATCH --gres=gpu:1,vram:24G
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu_requeue,gpu,gpu_marks
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/esm2/%x-%A_%3a-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/esm2/%x-%A_%3a-%u.err
#SBATCH --job-name="ESM-IF1"
#SBATCH --array=96

module load miniconda3/4.10.3
module load gcc/9.2.0
module load cuda/11.2

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

## Regression weights are at: https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt
#https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt
# alter these if DMS csvs and structures are in different locations or structures are in a different location

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM-IF1/esm_if1_gvp4_t16_142M_UR50.pt
export DMS_output_score_folder=${DMS_output_score_folder_subs}/ESM-IF1/

srun /n/groups/marks/software/anaconda_o2/envs/proteingym_env/bin/python ../../proteingym/baselines/esm/compute_fitness_esm_if1.py \
    --model_location ${model_checkpoint} \
    --structure_folder ${DMS_structure_folder} \
    --DMS_index $SLURM_ARRAY_TASK_ID \
    --DMS_reference_file_path ${DMS_reference_file_path_subs} \
    --DMS_data_folder ${DMS_data_folder_subs} \
    --output_scores_folder ${DMS_output_score_folder} 