#!/bin/bash 
#SBATCH --cpus-per-task=5
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad
#SBATCH -t 96:00:00
#SBATCH --mem=120G
#SBATCH --output=/home/pn73/protein_transformer/slurm_stdout/slurm-%j.out
#SBATCH --error=/home/pn73/protein_transformer/slurm_stdout/slurm-%j.err
#SBATCH --job-name="Uni"
#SBATCH --array=1,5,6,16,19,24,25,27,28,31,36,37,43,53,55,59,70,71,83
#67

module load conda2/4.2.13
module load gcc/6.2.0
module load cuda/10.1

source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export seqspath=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/MSA/MSA_Unirep_Evotuning
export savedir=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/evotuning/substitutions
export initial_weights_dir=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/1900_weights
export mapping_path=/home/pn73/Tranception/proteingym/ProteinGym_reference_file_substitutions.csv
export steps=13000 #Same as Unirep paper

srun python unirep_evotune.py \
    --seqs_fasta_path $seqspath \
    --save_weights_dir $savedir \
	--initial_weights_dir $initial_weights_dir \
	--num_steps $steps \
    --batch_size 128 \
    --mapping_path $mapping_path \
    --DMS_index $SLURM_ARRAY_TASK_ID \
    --max_seq_len 500