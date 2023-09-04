#!/bin/bash 

# source activate proteingym_env

# Five checkpoints for ESM-1v
# export model_checkpoint1="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_1.pt"
# export model_checkpoint2="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_2.pt"
# export model_checkpoint3="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_3.pt"
# export model_checkpoint4="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_4.pt"
# export model_checkpoint5="/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1v/esm1v_t33_650M_UR90S_5.pt"
# combine all five into one string 
# export model_checkpoint="${model_checkpoint1} ${model_checkpoint2} ${model_checkpoint3} ${model_checkpoint4} ${model_checkpoint5}"

#checkpoint for ESM1b 
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/ESM1b/esm1b_t33_650M_UR50S.pt

export dms_mapping=../../reference_files/DMS_substitutions.csv
export dms_input_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged
# export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/ESM1v/"
export dms_output_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/ESM1b/"
export scoring_strategy="wt-marginals"
export scoring_window="overlapping"
# export scoring_window="optimal"
export model_type="ESM1b"
# export model_type="ESM1v"
export protein_index=0


python ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index $protein_index \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window}
echo "Done"