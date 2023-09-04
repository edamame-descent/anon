#!/bin/bash 

source activate proteingym_env

# MSA transformer 
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/MSA_transformer/esm_msa1b_t12_100M_UR50S.pt
export dms_index=0

export dms_mapping=../../reference_files/DMS_substitutions.csv
export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged
export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/MSA_Transformer/"
export MSA_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs'
export MSA_weights_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_merged/DMS_substitutions_MSAs'

export scoring_strategy=masked-marginals # MSA transformer only supports "masked-marginals" #"wt-marginals"
export scoring_window="overlapping"
export model_type=MSA_transformer

python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index "${dms_index}" \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window} \
    --msa-path ${MSA_data_folder} \
    --msa-weights-folder ${MSA_weights_folder}

echo "Done"
