# This file has all general filepaths and directories used in the scoring pipeline. The individual scripts may have 
# additional parameters specific to each method 

# DMS zero-shot parameters

# Folders containing the csvs with the variants for each DMS assay
export DMS_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions
export DMS_data_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/indels

# Folders containing multiple sequence alignments and MSA weights for all DMS assays
export DMS_MSA_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/DMS
export DMS_MSA_weights_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/DMS

# Reference files for substitution and indel assays
export DMS_reference_file_path_subs=../../reference_files/DMS_substitutions.csv
export DMS_reference_file_path_indels=../../reference_files/DMS_indels.csv

# Folders where fitness predictions for baseline models are saved 
export DMS_output_score_folder_subs="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions"
export DMS_output_score_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels"

# Folder containing EVE models for each DMS assay
export DMS_EVE_model_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVE_models/DMS"

# Folders containing merged score files for each DMS assay
export DMS_merged_score_folder_subs="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/merged_scores/zero_shot_substitutions"
export DMS_merged_score_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/merged_scores/zero_shot_indels"

# Folders containing predicted structures for the DMSs 
export DMS_structure_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs"


# Clinical parameters 

# Folder containing variant csvs 
export clinical_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/substitutions
export clinical_data_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/Clinical_datasets/indels

# Folders containing multiple sequence alignments and MSA weights for all clinical datasets
export clinical_MSA_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/clinical_subs
export clinical_MSA_data_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/clinical_indels

# Folder containing MSA weights for all clinical datasets
export clinical_MSA_weights_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/clinical_subs
export clinical_MSA_weights_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/clinical_indels

# reference files for substitution and indel clinical variants 
export clinical_reference_file_path_subs=../../reference_files/clinical_substitutions.csv
export clinical_reference_file_path_indels=../../reference_files/clinical_indels.csv

# Folder where clinical benchmark fitness predictions for baseline models are saved
export clinical_output_score_folder_subs="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_substitutions"
export clinical_output_score_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_clinical_indels"

# Folder containing EVE models for each clinical variant
export clinical_EVE_model_folder="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/EVE_models/clinical_subs"

# Folder containing merged score files for each clinical variant
export clinical_merged_score_folder_subs="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/merged_scores/zero_shot_clinical_substitutions"
export clinical_merged_score_folder_indels="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/merged_scores/zero_shot_clinical_indels"
