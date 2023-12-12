#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -t 0-01:00  # time (D-HH:MM)
#SBATCH --mem=32G

#SBATCH --gres=gpu:1,vram:24G
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu_marks,gpu,gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --output=./slurm/msa_transformer/%x-%A_%3a.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/msa_transformer/%x-%A_%3a.err
#SBATCH --job-name="msa_transformer"  # TODO temp
#SBATCH --array=0-2


echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/10.2

source ../zero_shot_config.sh
source activate proteingym_env

# MSA transformer checkpoint 
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/MSA_transformer/esm_msa1b_t12_100M_UR50S.pt
export DMS_index=$SLURM_ARRAY_TASK_ID
export dms_output_folder="${DMS_output_score_folder_subs}/MSA_Transformer/"
export scoring_strategy=masked-marginals # MSA transformer only supports "masked-marginals" #"wt-marginals"
export scoring_window="overlapping"
export model_type=MSA_transformer
export random_seeds="1 2 3 4 5"

srun python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index ${DMS_index} \
    --dms_mapping ${DMS_reference_file_path_subs} \
    --dms-input ${DMS_data_folder_subs} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window} \
    --msa-path ${DMS_MSA_data_folder} \
    --msa-weights-folder ${DMS_MSA_weights_folder} \
    --seeds ${random_seeds}

echo "Done"
