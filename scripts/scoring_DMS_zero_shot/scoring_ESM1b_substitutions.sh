#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-23:59  # time (D-HH:MM)
#SBATCH --mem=40G

#SBATCH --gres=gpu:1
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad
#SBATCH --qos=gpuquad_qos

#SBATCH --output=./slurm/esm1b/esm1b-%A_%3a-%x-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/esm1b/esm1b-%A_%3a-%x-%u.err

#SBATCH --job-name="esm1b_pg"
## SBATCH --array=0-82 # Lood test first # PG v2: 83 new datasets

# ESM-1v: Set off 5 sets of arrays, 100 apart
# #SBATCH --array=100-182,200-282,300-382,400-482,500-582  # Ensemble is 1-indexed
#SBATCH --array=101,102,103,104,107,108,109,114,115,116,117,118,121,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143
# Fail on first error
set -e # uo pipefail 

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"
echo "GPU available: $(nvidia-smi)"

# module load conda2/4.2.13
module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2

#module load conda3/latest
#module load gcc/9.2.0
#module load cuda/11.7

#conda env update --file /home/pn73/protein_transformer/protein_transformer_env_O2.yml
#conda env update --file /home/pn73/proteingym_dev/proteingym_env.yml
# source activate /home/pn73/.conda/envs/protein_transformer_env
source activate /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel

# Check that pandas is installed in python3
srun /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel/bin/python3 -c "import pandas"
echo "Pandas imported correctly"

#export PYTHONPATH=$PYTHONPATH:$(pwd)/../baselines/esm
#export PYTHONPATH=$PYTHONPATH:$(pwd)/baselines/traception/tranception
# export PYTHONPATH=$PYTHONPATH:$(pwd)/../..

# export dms_index=$(($SLURM_ARRAY_TASK_ID%100))
export dms_index=$SLURM_ARRAY_TASK_ID
# ESM-1v: Get ensemble index as the hundreds digit of the array index
# export ensemble_idx=$(($SLURM_ARRAY_TASK_ID/100))  # ensemble is 1-indexed
# export model_checkpoint="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_${ensemble_idx}.pt"
export model_checkpoint="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt"
echo "Debug: SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "Debug: dms_index: $dms_index"
# echo "Debug: ensemble_idx: $ensemble_idx"
echo "Debug: model_checkpoint: $model_checkpoint"

# ESM1b:
# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt

export dms_mapping=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/DMS_substitutions_reference_file_reduced_2023_08_16.csv
export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new
# export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/ESM1v/ensemble${ensemble_idx}/"
export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/ESM1b/"
export scoring_strategy="wt-marginals"
# export scoring_window="overlapping"
export scoring_window="optimal"
export model_type="ESM1b"
# export model_type="ESM1v"

srun /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel/bin/python3 ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index ${dms_index} \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window}
echo "Done"