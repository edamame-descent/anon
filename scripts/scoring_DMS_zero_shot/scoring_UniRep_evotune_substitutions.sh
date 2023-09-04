#!/bin/bash 

source activate protein_fitness_prediction_hsu

export OMP_NUM_THREADS=1

export model_path=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/Unirep/evotuning/substitutions
export data_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged
export output_dir=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/UniRep_evotuned
export mapping_path=../../reference_files/DMS_substitutions.csv
export protein_index=0
python ../../proteingym/baselines/unirep_inference.py \
            --model_path $model_path \
            --data_path $data_path \
            --output_dir $output_dir \
            --mapping_path $mapping_path \
            --DMS_index $protein_index \
            --batch_size 32 \
            --evotune