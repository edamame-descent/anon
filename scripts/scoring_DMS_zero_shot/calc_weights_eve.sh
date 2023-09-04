#!/bin/bash 

# EVE example
export MSA_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs'
export MSA_list='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVCouplings_runs/msa_dedup_2023_08_28.csv'
export MSA_weights_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_merged/DMS_substitutions_MSAs'
export training_logs_location='./logs/'
export protein_index=0

conda activate proteingym_env

python ../../proteingym/baselines/EVE/calc_weights.py \
    --MSA_data_folder ${MSA_data_folder} \
    --MSA_list ${MSA_list} \
    --protein_index "${protein_index}" \
    --MSA_weights_location ${MSA_weights_location} \
    --num_cpus -1 \
    --calc_method evcouplings \
    --threshold_focus_cols_frac_gaps 1 \
    --skip_existing

echo "Done"
