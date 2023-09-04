#!/bin/bash 

source activate proteingym_env

export DMS_assays_location=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels
export model_scores_location=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels
export merged_scores_dir='merged_scores_20230613'
export mutation_type='indels'

python ../../proteingym/merge.py \
            --DMS_assays_location ${DMS_assays_location} \
            --model_scores_location ${model_scores_location} \
            --merged_scores_dir ${merged_scores_dir} \
            --mutation_type ${mutation_type}