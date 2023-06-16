#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_requeue
#SBATCH -t 60:00:00
#SBATCH --mem=110G
#SBATCH --output=/home/pn73/proteingym_dev/slurm/progen2-%j.out
#SBATCH --error=/home/pn73/proteingym_dev/slurm/progen2-%j.err
#SBATCH --job-name="Progen2"
#SBATCH --array=90

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate tranception_env

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/small"
#export performance_file="/home/pn73/ProteinGym/archives/progen2_performance_files/progen2_small.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/medium"
#export performance_file="/home/pn73/ProteinGym/archives/progen2_performance_files/progen2_medium.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/base"
#export performance_file="/home/pn73/ProteinGym/archives/progen2_performance_files/progen2_base.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/large"
#export performance_file="/home/pn73/ProteinGym/archives/progen2_performance_files/progen2_large.csv"

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/Progen2/xlarge"
export performance_file="/home/pn73/ProteinGym/archives/progen2_performance_files/progen2_xlarge.csv"

export DMS_reference_file_path='/home/pn73/ProteinGym/ProteinGym_reference_file_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions'

srun python3 /home/pn73/proteingym_dev/proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file}