#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -p short
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH --output=./slurm/hmm/HMM-%A_%3a-%x.out
#SBATCH --error=./slurm/hmm/HMM-%A_%3a-%x.err
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="HMM"
#SBATCH --array=0-2

module load miniconda3/4.10.3
module load gcc/6.2.0
module load cuda/11.2

source ../zero_shot_config.sh
source activate proteingym_env

export TEMP_FOLDER="../HMM_temp"
export output_score_folder="${DMS_output_score_folder_indels}/HMM/"
export HMMER_PATH="/n/groups/marks/software/jackhmmer/hmmer-3.3.1"
export DMS_index=$SLURM_ARRAY_TASK_ID

python ../../proteingym/baselines/HMM/score_hmm.py \
--DMS_reference_file=$DMS_reference_file_path_indels --DMS_folder=$DMS_data_folder_indels \
--DMS_index=$DMS_index \
--hmmer_path=$HMMER_PATH \
--MSA_folder=$DMS_MSA_data_folder \
--output_scores_folder=$output_score_folder --intermediate_outputs_folder=$TEMP_FOLDER
echo "Done"
