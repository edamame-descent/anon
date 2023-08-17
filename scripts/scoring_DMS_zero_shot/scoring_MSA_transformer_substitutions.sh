#!/bin/bash 
#SBATCH --cpus-per-task=10
#SBATCH -t 2-00:00  # time (D-HH:MM)
#SBATCH --mem=90G

# Request minimum GPU memory of 24GB
#SBATCH --gres=gpu:1,vram:23G
# Note: gpu_requeue has a time limit of 1 day (sinfo --Node -p gpu_requeue --Format CPUsState,Gres,GresUsed:.40,Features:.80,StateLong,Time)
#SBATCH -p gpu_quad,gpu,gpu_marks
#SBATCH --qos=gpuquad_qos


#SBATCH --output=./slurm/msa_transformer/msa_transformer-%A_%3a-%x-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/msa_transformer/msa_transformer-%A_%3a-%x-%u.err

#SBATCH --job-name="msa_transformer_pg_v2"
# #SBATCH --array=0-82 # PG v2: 83 new datasets
# #SBATCH --array=82
#SBATCH --array=1,2,8,11,16

# Fail on first error
set -e # uo pipefail 

echo "USER: $USER"
echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"
echo "GPU available: $(nvidia-smi)"

# module load conda2/4.2.13
# module load miniconda3/4.10.3
# module load gcc/6.2.0
# module load cuda/10.2

#module load conda3/latest
module load gcc/9.2.0
module load cuda/11.7  # New CUDA: hopefully not the A100 errors

#conda env update --file /home/pn73/protein_transformer/protein_transformer_env_O2.yml
#conda env update --file /home/pn73/proteingym_dev/proteingym_env.yml
# source activate /home/pn73/.conda/envs/protein_transformer_env
# source activate /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel

# Check that pandas is installed in python3
srun /n/groups/marks/users/lood/mambaforge/envs/tranception_a100_fix/bin/python -c "import pandas"
echo "Pandas imported correctly"

# Monitor GPU usage in background (store outputs in ./logs/gpu_logs/)
echo "Starting GPU memory monitor"
set +e
/n/groups/marks/users/lood/scripts/job_gpu_monitor.sh --interval 1m ./logs/gpu_logs &
set -e
echo "GPU job monitor started"

#export PYTHONPATH=$PYTHONPATH:$(pwd)/../baselines/esm
#export PYTHONPATH=$PYTHONPATH:$(pwd)/baselines/traception/tranception
# export PYTHONPATH=$PYTHONPATH:$(pwd)/../..

# export dms_index=$(($SLURM_ARRAY_TASK_ID%100))

# ESM-1v: Get ensemble index as the hundreds digit of the array index
# export ensemble_idx=$(($SLURM_ARRAY_TASK_ID/100))  # ensemble is 1-indexed
# export model_checkpoint="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_${ensemble_idx}.pt"

# ESM1b:
# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt

# MSA transformer 
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/MSA_transformer/esm_msa1b_t12_100M_UR50S.pt
export dms_index=$SLURM_ARRAY_TASK_ID

echo "Debug: SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "Debug: dms_index: $dms_index"
# echo "Debug: ensemble_idx: $ensemble_idx"
echo "Debug: model_checkpoint: $model_checkpoint"

export dms_mapping=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_10_2023_full_83.csv
export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new
export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/v2_scores/MSA_transformer/"
export MSA_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_test'
export MSA_weights_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_v2/substitutions_MSAs'

export scoring_strategy=masked-marginals # MSA transformer only supports "masked-marginals" #"wt-marginals"
export scoring_window="overlapping"
# export model_type="ESM1b"
# export model_type="ESM1v"
export model_type=MSA_transformer

srun /n/groups/marks/users/lood/mambaforge/envs/tranception_a100_fix/bin/python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index "${dms_index}" \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window} \
    --msa-path ${MSA_data_folder} \
    --msa-weights-folder ${MSA_weights_folder}

echo "Done"
