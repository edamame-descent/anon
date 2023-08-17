#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 08:00:00
#SBATCH --mem=90G
#SBATCH --output=./slurm/evotuning_unirep/slurm-%j.out
#SBATCH --error=./slurm/evotuning_unirep/slurm-%j.err
#SBATCH --job-name="evotuning_unirep"
# #SBATCH --array=0-82
#SBATCH --array=0

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate /n/groups/marks/software/anaconda_o2/envs/protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export seqspath=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Unirep_MSA_Evotuning
export savedir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/evotuning/substitutions
export initial_weights_dir=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/1900_weights
export mapping_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/new_DMS_08_08_2023_full_83.csv
export steps=13000 #Same as Unirep paper

srun python ../../proteingym/baselines/unirep/unirep_evotune.py \
    --seqs_fasta_path $seqspath \
    --save_weights_dir $savedir \
	--initial_weights_dir $initial_weights_dir \
	--num_steps $steps \
    --batch_size 128 \
    --mapping_path $mapping_path \
    --DMS_index $SLURM_ARRAY_TASK_ID \
    --max_seq_len 500