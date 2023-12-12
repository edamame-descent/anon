#!/bin/bash
#SBATCH -t 0-01:00                     
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --requeue
#SBATCH --gres=gpu:1
#SBATCH --qos=gpuquad_qos
#SBATCH --mem=48G                
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="daniel_ritter@hms.harvard.edu"
#SBATCH --job-name="eve_scoring"
#SBATCH --output=./slurm/eve/%A_%4a-%x-%u.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/eve/%A_%4a-%x-%u.err   # Optional: Redirect STDERR to its own file
#SBATCH --array=0-2

set -e #o pipefail # fail fully on first line failure (from Joost slurm_for_ml)

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2 

source ../zero_shot_config.sh
source activate proteingym_env

export DMS_index=$SLURM_ARRAY_TASK_ID
export model_parameters_location='../../proteingym/baselines/EVE/EVE/default_model_params.json'
export training_logs_location='../../proteingym/baselines/EVE/logs/'
export computation_mode='DMS'
export output_score_folde="${DMS_output_score_folder_subs}/EVE/"
export num_samples_compute_evol_indices=20000
export batch_size=1024  # Pushing batch size to limit of GPU memory
export random_seeds="0 1 2 3 4"

python ../../proteingym/baselines/EVE/compute_evol_indices_DMS.py \
    --MSA_data_folder ${DMS_MSA_data_folder} \
    --DMS_reference_file_path ${DMS_reference_file_path_subs} \
    --protein_index ${DMS_index} \
    --VAE_checkpoint_location ${DMS_EVE_model_folder} \
    --model_parameters_location ${model_parameters_location} \
    --DMS_data_folder ${DMS_data_folder_subs} \
    --output_evol_indices_location ${output_score_folder} \
    --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
    --batch_size ${batch_size} \
    --aggregation_method "full" \
    --threshold_focus_cols_frac_gaps 1 \
    --skip_existing \
    --MSA_weights_location ${DMS_MSA_weights_folder} \
    --random_seeds ${random_seeds} 
echo "Done"
