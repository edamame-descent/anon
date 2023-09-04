#!/bin/bash
# source activate proteingym_env

export MSA_data_folder='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs'
export DMS_reference_file='../../reference_files/DMS_substitutions.csv'
export MSA_weights_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights_merged/DMS_substitutions_MSAs'
export VAE_checkpoint_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVE_runs/results/VAE_parameters'
export model_name_suffix='proteingym_20230828'  # Essential for skip_existing to work
export model_parameters_location='/n/groups/marks/users/lood/EVE/EVE/default_model_params.json'
export protein_index=178

# DMS-specific args
export computation_mode='DMS'
export mutations_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_new'  # Javier new DMS folder
# export output_evol_indices_location='/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/EVE'  # Custom output location
export output_evol_indices_location="/n/groups/marks/users/daniel_r/test"
export output_evol_indices_filename_suffix=$model_name_suffix
export num_samples_compute_evol_indices=20000
export batch_size=1024  # Pushing batch size to limit of GPU memory


python ../../proteingym/baselines/EVE/compute_evol_indices_DMS.py \
    --MSA_data_folder ${MSA_data_folder} \
    --MSA_list ${DMS_reference_file} \
    --protein_index ${protein_index} \
    --VAE_checkpoint_location ${VAE_checkpoint_location} \
    --model_name_suffix ${model_name_suffix} \
    --model_parameters_location ${model_parameters_location} \
    --computation_mode ${computation_mode} \
    --mutations_location ${mutations_location} \
    --output_evol_indices_location ${output_evol_indices_location} \
    --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
    --batch_size ${batch_size} \
    --aggregation_method "full" \
    --threshold_focus_cols_frac_gaps 1 \
    --MSA_weights_location ${MSA_weights_location}

