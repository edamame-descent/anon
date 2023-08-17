#!/bin/bash
#SBATCH --cpus-per-task 4
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-23:59                      # Runtime in D-HH:MM format
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu,gpu_marks#,gpu_requeue
#SBATCH --gres=gpu:1
##SBATCH --constraint=gpu_doublep
#SBATCH --qos=gpuquad_qos
#SBATCH --mem=80G                          # Memory total in MB (for all cores)

#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT #,FAIL,ARRAY_TASKS
#SBATCH --mail-user="lodevicus_vanniekerk@hms.harvard.edu"

#SBATCH --job-name="eve_proteingym_v2"

# Job array-specific
# Note: Script fails silently if the slurm output directory doesn't exist
#SBATCH --output=slurm/eve/eve_proteingym_v2-%A_%3a-%x-%u.out   # Nice tip: using %3a to pad to 3 characters (23 -> 023)
##SBATCH --error=slurm/eve/eve_proteingym_v2-%A_%3a-%x-%u.err   # Optional: Redirect STDERR to its own file
#SBATCH --array=0

# Quite neat workflow:
# Submit job array in held state, then release first job to test
# Add a dependency so that the next jobs are submitted as soon as the first job completes successfully:
# scontrol update Dependency=afterok:<jobid>_0 JobId=<jobid>
# Release all the other jobs; they'll be stuck until the first job is done
################################################################################

set -eo pipefail # fail fully on first line failure (from Joost slurm_for_ml)
# Make prints more stable (Milad)
export PYTHONUNBUFFERED=1

echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "GPU available: $(nvidia-smi)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"

# Monitor GPU usage (store outputs in ./logs/gpu_logs/)
~/job_gpu_monitor.sh --interval 1m ./logs/gpu_logs &


export MSA_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_test'
export MSA_list='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVCouplings_runs/msa_dedup_2023_08_10.csv'
export MSA_weights_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_v2/substitutions_MSAs'
export VAE_checkpoint_location='/n/groups/marks/users/lood/EVE/results/VAE_parameters_proteingym2/'
export model_name_suffix='2023_08_10'  # Essential for skip_existing to work
export model_parameters_location='/n/groups/marks/users/lood/EVE/default_model_params.json'
export training_logs_location='./logs/'
export protein_index=${SLURM_ARRAY_TASK_ID}

# DMS-specific args
export computation_mode='DMS'
#export all_singles_mutations_folder='./data/mutations'
export mutations_location='/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/DMS/DMS_Benchmarking_Dataset_v5_20220227'  # Javier new DMS folder
export output_evol_indices_location='./results/evol_indices_2022_08_08_disorder_ProteinGym/'  # Custom output location
export output_evol_indices_filename_suffix=$model_name_suffix
export num_samples_compute_evol_indices=20000
export batch_size=1024  # Pushing batch size to limit of GPU memory


python compute_evol_indices_DMS.py \
    --MSA_data_folder ${MSA_data_folder} \
    --MSA_list ${MSA_list} \
    --protein_index ${protein_index} \
    --VAE_checkpoint_location ${VAE_checkpoint_location} \
    --model_name_suffix ${model_name_suffix} \
    --model_parameters_location ${model_parameters_location} \
    --computation_mode ${computation_mode} \
    --mutations_location ${mutations_location} \
    --output_evol_indices_location ${output_evol_indices_location} \
    --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
    --batch_size ${batch_size} \
    --aggregation_method "full" \
    --threshold_focus_cols_frac_gaps 1
    #--skip_existing \
    #--MSA_weights_location ${MSA_weights_location} \
