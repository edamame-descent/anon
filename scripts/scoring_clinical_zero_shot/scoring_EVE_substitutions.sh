#!/bin/bash
#SBATCH --cpus-per-task 1
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-04:00                      # Runtime in D-HH:MM format
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --gres=gpu:1,vram:24G
#SBATCH --qos=gpuquad_qos
#SBATCH --mem=80G                          # Memory total in MB (for all cores)

# Lood: Turned off email notifications
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="daniel_ritter@hms.harvard.edu"

#SBATCH --job-name="eve_score_clinical_subs_2023_11_13"

#SBATCH --output=./slurm/eve/%A_%4a-%x-%u.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/eve/%A_%4a-%x-%u.err   # Optional: Redirect STDERR to its own file
# #SBATCH --array=0-2524
#SBATCH --array=2524
set -e #o pipefail # fail fully on first line failure (from Joost slurm_for_ml)
# Make prints more stable (Milad)
export PYTHONUNBUFFERED=1

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2 

source ../zero_shot_config.sh
source activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

export dms_index=$SLURM_ARRAY_TASK_ID


export model_parameters_location='../../proteingym/baselines/EVE/EVE/default_model_params.json'
export training_logs_location='../../proteingym/baselines/EVE/logs/'

# DMS-specific args
export computation_mode='DMS'
export output_scores_folder="${clinical_output_score_folder_subs}/EVE"  # Custom output location
export num_samples_compute_evol_indices=20000
export batch_size=1024  # Pushing batch size to limit of GPU memory
export random_seeds="0"

python ../../proteingym/baselines/EVE/compute_evol_indices_DMS.py \
    --MSA_data_folder ${clinical_MSA_data_folder_subs} \
    --DMS_reference_file_path ${clinical_reference_file_path_subs} \
    --protein_index ${dms_index} \
    --VAE_checkpoint_location ${clinical_EVE_model_folder} \
    --model_parameters_location ${model_parameters_location} \
    --DMS_data_folder ${clinical_data_folder_subs} \
    --output_scores_folder ${output_scores_folder} \
    --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
    --batch_size ${batch_size} \
    --aggregation_method "full" \
    --threshold_focus_cols_frac_gaps 1 \
    --MSA_weights_location ${clinical_MSA_weights_folder_subs} \
    --random_seeds ${random_seeds} 
echo "Done"
