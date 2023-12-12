#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-12:00  # time (D-HH:MM)
#SBATCH --mem=40G

#SBATCH --gres=gpu:1,vram:24G
#SBATCH -p gpu_quad,gpu_marks,gpu,gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/esm1b/%x-%A_%3a-%u.out  
#SBATCH --error=./slurm/esm1b/%x-%A_%3a-%u.err
#SBATCH --job-name="esm1b"
#SBATCH --array=0-2

# This script runs both ESM1b and ESM1v, just have to uncomment and comment the appropriate lines below
# Fail on first error
set -e # uo pipefail 

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2

source ../zero_shot_config.sh
source activate proteingym_env

# ESM-1v parameters 
# Five checkpoints for ESM-1v
# export model_checkpoint1="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_1.pt"
# export model_checkpoint2="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_2.pt"
# export model_checkpoint3="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_3.pt"
# export model_checkpoint4="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_4.pt"
# export model_checkpoint5="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_5.pt"
# combine all five into one string 
# export model_checkpoint="${model_checkpoint1} ${model_checkpoint2} ${model_checkpoint3} ${model_checkpoint4} ${model_checkpoint5}"

# export dms_output_folder="${DMS_output_score_folder_subs}/ESM1v/"

# export model_type="ESM1v"
# export scoring_strategy="masked-marginals"  # MSATransformer only uses masked-marginals
# export scoring_window="optimal"

# ESM1b parameters
# checkpoint for ESM1b 
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt

export dms_output_folder="${DMS_output_score_folder_subs}/ESM1b/"

export model_type="ESM1b"
export scoring_strategy="wt-marginals"
export scoring_window="overlapping"

export dms_index=$SLURM_ARRAY_TASK_ID

srun python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index ${dms_index} \
    --dms_mapping ${DMS_reference_file_path_subs} \
    --dms-input ${DMS_data_folder_subs} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window}
echo "Done"
