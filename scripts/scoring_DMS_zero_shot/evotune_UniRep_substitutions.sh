#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1,vram:24G
#SBATCH -p gpu_quad,gpu,gpu_marks
#SBATCH --qos=gpuquad_qos
#SBATCH -t 4-00:00
#SBATCH --mem=80G
#SBATCH --output=./slurm/evotuning_unirep/evotuning-%A_%3a-%x.out
#SBATCH --error=./slurm/evotuning_unirep/evotuning-%A_%3a-%x.err 
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="Daniel_Ritter@hms.harvard.edu"
#SBATCH --job-name="evotuning_unirep"
#SBATCH --array=0-2

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source ../zero_shot_config.sh
source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export savedir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/UniRep/evotuning/DMS_substitutions
# export savedir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/UniRep/evotuning/DMS_indels
export initial_weights_dir=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/1900_weights
export DMS_reference_file_path=$DMS_reference_file_path_subs
# uncomment below to run for indels 
# export DMS_reference_file_path=$DMS_reference_file_path_indels
export steps=13000 #Same as Unirep paper

srun python ../../proteingym/baselines/unirep/unirep_evotune.py \
    --seqs_fasta_path $DMS_MSA_data_folder \
    --save_weights_dir $savedir \
	--initial_weights_dir $initial_weights_dir \
	--num_steps $steps \
    --batch_size 128 \
    --mapping_path $DMS_reference_file_path \
    --DMS_index $SLURM_ARRAY_TASK_ID \
    --max_seq_len 500