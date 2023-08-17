#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-11:59  # time (D-HH:MM)
#SBATCH --mem=64G

#SBATCH --gres=gpu:1
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
# #SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH -p gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/tranception_no_retrieval/trn-large-%A_%3a-%x-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/tranception_no_retrieval/trn-large-%A_%3a-%x-%u.err

#SBATCH --job-name="tranception_L_no_retrieval_DMS_scoring"
# #SBATCH --array=0-82
# #SBATCH --array=2-82  # 9 Aug: Lood launching all jobs
# #SBATCH --array=15
# #SBATCH --array=3,12,82
#SBATCH --array=3

# Fail on first error
set -e #uo pipefail

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"
echo "GPU available: $(nvidia-smi)"


module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.1

# export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Small
# export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Tranception_no_retrieval/Tranception_S

# export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Medium
# export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Tranception_no_retrieval/Tranception_M

export PATH_TO_MODEL_CHECKPOINT=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/Tranception_open_source/model_checkpoint/Tranception_Large
export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/Tranception_no_retrieval/Tranception_L

export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new
export INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE=$SLURM_ARRAY_TASK_ID

source activate /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel

echo "Debug: Activated environment"
# Print conda list of packages
conda list

which python3
which python
# Check that pandas is installed in python3
srun /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel/bin/python3 -c "import pandas"
echo "Pandas imported correctly"

# Monitor GPU usage in background (store outputs in ./logs/gpu_logs/)
echo "Starting GPU memory monitor"
set +e
/n/groups/marks/users/lood/scripts/job_gpu_monitor.sh --interval 1m ./logs/gpu_logs &
set -e
echo "GPU job monitor started"

# Replace the following paths based on where you store models and data
export checkpoint=$PATH_TO_MODEL_CHECKPOINT
export DMS_data_folder=$PATH_TO_DMS_SUBSTITUTIONS
export DMS_index=$INDEX_OF_DMS_TO_BE_SCORED_IN_REFERENCE_FILE
export output_scores_folder=$PATH_TO_OUTPUT_SCORES

export DMS_reference_file_path="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv"

srun /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel/bin/python3 ../../proteingym/baselines/tranception/score_tranception_proteingym.py \
                --checkpoint ${checkpoint} \
                --DMS_reference_file_path ${DMS_reference_file_path} \
                --DMS_data_folder ${DMS_data_folder} \
                --DMS_index ${DMS_index} \
                --output_scores_folder ${output_scores_folder} 
echo "Done"