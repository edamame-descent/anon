#!/bin/bash 

# source activate proteingym_env

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t6_8M_UR50D.pt
#export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t12_35M_UR50D.pt
#export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t30_150M_UR50D.pt
#export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t33_650M_UR50D.pt
#export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t36_3B_UR50D.pt
# export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t48_15B_UR50D.pt

## Regression weights are at: https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt
#https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt

export PATH_TO_DMS_MAPPING=../../reference_files/DMS_substitutions.csv
export PATH_TO_DMS_SUBSTITUTIONS=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged
export PATH_TO_OUTPUT_SCORES=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/ESM2
#############################################################################################################################


export dms_mapping=$PATH_TO_DMS_MAPPING
export dms_input_folder=$PATH_TO_DMS_SUBSTITUTIONS
export dms_output_folder=$PATH_TO_OUTPUT_SCORES

export scoring_strategy="masked-marginals"
export model_type="ESM2"
export protein_index=0
python ../../proteingym/baselines/esm/compute_fitness.py \
    --model_type ${model_type} \
    --model-location ${model_checkpoint} \
    --dms_index $protein_index \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \