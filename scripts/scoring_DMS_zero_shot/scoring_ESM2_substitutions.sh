#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-18:00  # time (D-HH:MM)
#SBATCH --mem=200G
#SBATCH --gres=gpu:1,vram:80G
#SBATCH -p gpu_quad,gpu_requeue,gpu,gpu_marks
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/esm2/%x-%A_%3a-%u.out
#SBATCH --error=./slurm/esm2/%x-%A_%3a-%u.err
#SBATCH --job-name="ESM2-15B"
#SBATCH --array=0-2

module load miniconda3/4.10.3
module load gcc/9.2.0
module load cuda/11.2

source ../zero_shot_config.sh
source activate proteingym_env

# Run whichever size of ESM2 by uncommenting the appropriate pair of lines below

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t6_8M_UR50D.pt
export dms_output_folder=${DMS_output_score_folder_subs}/ESM2/8M 

# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t12_35M_UR50D.pt
# export dms_output_folder=${DMS_output_score_folder_subs}/ESM2/35M

# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t30_150M_UR50D.pt
# export dms_output_folder=${DMS_output_score_folder_subs}/ESM2/150M

# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t33_650M_UR50D.pt
# export dms_output_folder=${DMS_output_score_folder_subs}/ESM2/650M

# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t36_3B_UR50D.pt
# export dms_output_folder=${DMS_output_score_folder_subs}/ESM2/3B

# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t48_15B_UR50D.pt
# export dms_output_folder=${DMS_output_score_folder_subs}/ESM2/15B

## Regression weights are at: https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt
#https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt

#############################################################################################################################

export model_type="ESM2"
export scoring_strategy="masked-marginals"

srun python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --dms_index $SLURM_ARRAY_TASK_ID \
    --dms_mapping ${DMS_reference_file_path_subs} \
    --dms-input ${DMS_data_folder_subs} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --model_type ${model_type} 