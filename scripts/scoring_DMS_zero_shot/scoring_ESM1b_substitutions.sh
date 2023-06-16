#!/bin/bash 
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu:1
#SBATCH -p gpu_marks
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=/home/pn73/proteingym_dev/slurm/esm1b-%j.out
#SBATCH --error=/home/pn73/proteingym_dev/slurm/esm1b-%j.err
#SBATCH --job-name="esm1b"
#SBATCH --array=0-86

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.2

#module load conda3/latest
#module load gcc/9.2.0
#module load cuda/11.7

#conda env update --file /home/pn73/protein_transformer/protein_transformer_env_O2.yml
#conda env update --file /home/pn73/proteingym_dev/proteingym_env.yml
source activate protein_transformer_env

#export PYTHONPATH=$PYTHONPATH:$(pwd)/../baselines/esm
#export PYTHONPATH=$PYTHONPATH:$(pwd)/baselines/traception/tranception
export PYTHONPATH=$PYTHONPATH:$(pwd)/../..

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt

export dms_mapping=/home/pn73/ProteinGym/ProteinGym_reference_file_substitutions.csv
#export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/DMS/DMS_Benchmarking_Dataset_v5_20220227
export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions
export dms_output_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/ESM1b

export scoring_strategy="wt-marginals"
export scoring_window="overlapping"
export model_type="ESM1b"

srun python3 ~/proteingym_dev/proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index $SLURM_ARRAY_TASK_ID \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window}