#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 48:00:00
#SBATCH --mem=90G
#SBATCH --output=../../slurm_stdout/slurm-%j.out
#SBATCH --error=../../slurm_stdout/slurm-%j.err
#SBATCH --job-name="ProBFD_base"
#SBATCH --array=0-2,4-6,12-21

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_transformer_env

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-small"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/small"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_small_substitutions.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-medium"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/medium"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_medium_substitutions.csv"

export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-base"
export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/base"
export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_base_substitutions2.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-large"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/large"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_large_substitutions.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-xlarge"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/xlarge"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_xlarge_substitutions.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-oas"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/oas"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_oas_substitutions.csv"

#export Progen2_model_name_or_path="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/progen2/progen2-BFD90"
#export output_scores_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions/Progen2/bfd90"
#export performance_file="/home/pn73/protein_transformer/outputs/performance_proteingym/progen2/progen2_BFD90_substitutions.csv"

export DMS_reference_file_path='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/clinical_substitutions.csv'
export DMS_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/substitutions'

srun python3 ../../proteingym/baselines/progen2/compute_fitness.py \
            --Progen2_model_name_or_path ${Progen2_model_name_or_path} \
            --DMS_reference_file_path ${DMS_reference_file_path} \
            --DMS_data_folder ${DMS_data_folder} \
            --DMS_index $SLURM_ARRAY_TASK_ID \
            --output_scores_folder ${output_scores_folder} \
            --performance_file ${performance_file} \