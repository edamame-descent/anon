#!/bin/bash 

# .yml file for this environment is in ../../proteingym/baselines/unirep
conda activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=1

export seqspath=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Unirep_MSA_Evotuning
export savedir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/evotuning/substitutions
export initial_weights_dir=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/1900_weights
export mapping_path=../../reference_files/DMS_substitutions.csv
export steps=13000 #Same as Unirep paper
export protein_index=0

python ../../proteingym/baselines/unirep/unirep_evotune.py \
    --seqs_fasta_path $seqspath \
    --save_weights_dir $savedir \
	--initial_weights_dir $initial_weights_dir \
	--num_steps $steps \
    --batch_size 128 \
    --mapping_path $mapping_path \
    --DMS_index $protein_index \
    --max_seq_len 500