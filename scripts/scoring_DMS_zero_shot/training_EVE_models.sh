#!/bin/bash
#SBATCH --cpus-per-task 2
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 2-00:00       # TMP NPC1 reruns              # Runtime in D-HH:MM format
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --requeue
#SBATCH --gres=gpu:1,vram:24G
#SBATCH --qos=gpuquad_qos
#SBATCH --mem=40G                          # Memory total in MB (for all cores)
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="daniel_ritter@hms.harvard.edu"
#SBATCH --job-name="eve_training"
#SBATCH --output=./slurm/eve_training/%A_%3a-%x-%u.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
#SBATCH --error=./slurm/eve_training/%A_%3a-%x-%u.err   # Optional: Redirect STDERR to its own file
# Every thousands separator is a seed
#SBATCH --array=0000,0001,0002,1000,1001,1002,2000,2001,2002,3000,3001,3002,4000,4001,4002
################################################################################

set -eo pipefail # fail fully on first line failure (from Joost slurm_for_ml)

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2

source ../zero_shot_config.sh
source activate proteingym_env

export dms_index=$(($SLURM_ARRAY_TASK_ID%1000))
# Get seed index as the thousands digit of the array index
export seed=$(($SLURM_ARRAY_TASK_ID/1000))

echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "dms_index: $dms_index"
echo "seed: $seed"

export model_parameters_location='../../proteingym/baselines/EVE/EVE/default_model_params.json'
export training_logs_location='../../proteingym/baselines/EVE/logs/'
export DMS_index=${SLURM_ARRAY_TASK_ID}
export DMS_reference_file_path=$DMS_reference_file_path_subs
# export DMS_reference_file_path=$DMS_reference_file_path_indels

python ../../proteingym/baselines/EVE/train_VAE.py \
    --MSA_data_folder ${DMS_MSA_data_folder} \
    --DMS_reference_file_path ${DMS_reference_file_path} \
    --protein_index "${DMS_index}" \
    --MSA_weights_location ${DMS_MSA_weights_folder} \
    --VAE_checkpoint_location ${DMS_EVE_model_folder} \
    --model_parameters_location ${model_parameters_location} \
    --training_logs_location ${training_logs_location} \
    --threshold_focus_cols_frac_gaps 1 \
    --seed ${seed} \
    --skip_existing \
    --experimental_stream_data \
    --force_load_weights

echo "Done"
