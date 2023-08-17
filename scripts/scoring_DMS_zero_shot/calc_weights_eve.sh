#!/bin/bash 
#SBATCH --cpus-per-task=8
#SBATCH -t 3-00:00 # time (D-HH:MM)
#SBATCH --mem=80G

#SBATCH -p medium

#SBATCH --output=./slurm/eve_weights/eve_weights-%A_%3a-%x-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/eve_weights/eve_weights-%A_%3a-%x-%u.err

#SBATCH --job-name="eve_weights"
# #SBATCH --array=86,87,92,95,99,100,110 #85-195 # Test
#SBATCH --array=86,95

# Fail on first error
set -eo pipefail # -euo pipefail
# Make prints more stable (from Milad)
export PYTHONUNBUFFERED=1

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"

# EVE example
export MSA_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_test'
export MSA_list='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVCouplings_runs/msa_dedup_2023_08_10.csv'
export MSA_weights_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_v2/substitutions_MSAs'
# export VAE_checkpoint_location='/n/groups/marks/users/lood/EVE/results/VAE_parameters_v5_20220227/'
# export model_name_suffix='2022_04_26_DeepSeq_reproduce'  # Essential for skip_existing to work # Copied from O2
# export model_parameters_location='./EVE/deepseq_model_params.json'
export training_logs_location='./logs/'
export protein_index=${SLURM_ARRAY_TASK_ID}

/n/groups/marks/users/lood/mambaforge/envs/eve/bin/python /n/groups/marks/users/lood/EVE/calc_weights.py \
    --MSA_data_folder ${MSA_data_folder} \
    --MSA_list ${MSA_list} \
    --protein_index "${protein_index}" \
    --MSA_weights_location ${MSA_weights_location} \
    --num_cpus -1 \
    --calc_method evcouplings \
    --threshold_focus_cols_frac_gaps 1
    # --skip_existing

echo "Done"