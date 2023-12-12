#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH -t 0-02:59  # time (D-HH:MM)
#SBATCH --mem=40G

#SBATCH --gres=gpu:1 #,vram:24G
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu_marks,gpu,gpu_requeue
#SBATCH --requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
# #SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --mail-user="Lood_vanNiekerk@hms.harvard.edu"
#SBATCH --output=./slurm/esm1b/%x-%A_%3a-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/esm1b/%x-%A_%3a-%u.err

#SBATCH --job-name="esm1b_clinvar"
#SBATCH --array=0-100   # Take CSV line numbers minus 2 (they're 1-based and ignore header row)

# ESM-1v: Set off 5 sets of arrays, 100 apart
# #SBATCH --array=100-182,200-282,300-382,400-482,500-582  # Ensemble is 1-indexed
##SBATCH --array=101-114,201-214,301-314,401-414,501-514  # Ensemble is 1-indexed
# #SBATCH --array=100,200,300,400,500
# Fail on first error
# set -e # uo pipefail 

# ==========================================================================
# Using ESM-variants precomputed scores: https://github.com/ntranoslab/esm-variants/

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2

source ../zero_shot_config.sh 
source activate proteingym_env

export dms_index=$SLURM_ARRAY_TASK_ID
# ESM-1v: Get ensemble index as the hundreds digit of the array index
# export ensemble_idx=$(($SLURM_ARRAY_TASK_ID/100))  # ensemble is 1-indexed
# export model_checkpoint="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_${ensemble_idx}.pt"
# export model_checkpoint="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt"

# ESM1b:
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt

echo "Debug: model_checkpoint: $model_checkpoint"

# export dms_mapping=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/DMS_substitutions_reference_file_reduced_2023_08_16.csv
# export dms_mapping=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/clinical_substitutions_mapping_by_refseq.csv
# export dms_mapping="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/missing_esm1b_brandes_mapping.csv"
# export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/substitutions_filter_isoform/
# export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/ESM1v/ensemble${ensemble_idx}/"
export dms_output_folder="${clinical_output_score_folder_subs}/ESM1b/"

# Another option: Inputting the entire file at once
# export dms_input=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/clinvar_proteingym_20230611.GRCh38_clean.csv

export scoring_strategy="wt-marginals"
export scoring_window="overlapping"  # For long proteins
# export scoring_window="optimal"
export model_type="ESM1b"
# export model_type="ESM1v"

# Monitor GPU usage in background (store outputs in ./logs/gpu_logs/)
echo "Starting GPU memory monitor"
set +e
/n/groups/marks/users/lood/scripts/job_gpu_monitor.sh --interval 1m ./logs/gpu_logs &
set -e
echo "GPU job monitor started"

# Monitor CPU/mem usage in background (store outputs in ./logs/mem_logs/)
echo "Starting CPU/memory monitor"
set +e
/n/groups/marks/users/lood/scripts/job_mem_cpu_monitor.sh --interval 1m ./logs/mem_logs &
set -e
echo "CPU/memory job monitor started"

srun /n/groups/marks/software/anaconda_o2/envs/proteingym_env/bin/python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms-input ${clinical_data_folder_subs} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window} \
    --dms_mapping ${clinical_reference_file_path_subs} \
    --dms_index ${dms_index}
echo "Done"
