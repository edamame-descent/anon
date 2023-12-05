#!/bin/bash
#SBATCH --cpus-per-task 1
#SBATCH -t 0-02:00                      # Runtime in D-HH:MM format
#SBATCH -p gpu_quad,gpu,gpu_marks,gpu_requeue
#SBATCH --gres=gpu:1,vram:48G
#SBATCH --qos=gpuquad_qos
#SBATCH --mem=48G                          # Memory total in MB (for all cores)
#SBATCH --mail-type=TIME_LIMIT_80,TIME_LIMIT,FAIL,ARRAY_TASKS
#SBATCH --mail-user="daniel_ritter@hms.harvard.edu"
#SBATCH --output=./slurm/%x-%A_%3a-%u.out  # Nice tip: using %3a to pad to 3 characters (23 -> 023) so that filenames sort properly
#SBATCH --error=./slurm/%x-%A_%3a-%u.err
#SBATCH --job-name="vespa"

module load miniconda3/4.10.3
module load gcc/9.2.0
module load cuda/11.2

source activate trancepteve
# vespa baselines/vespa/BLATECOLX.fasta --prott5_weights_cache /scratch/pastin/protein/baselines/VESPA --vespa --h5_output /scratch/pastin/protein/baselines/VESPA/model_scores
vespa ./hsp82.fasta --prott5_weights_cache /n/groups/marks/users/daniel_r/VESPA_cache --vespa
