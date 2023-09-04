#!/bin/bash 

#Note: GEMME requires python, java and R as dependencies, to run JET2 and the seqinr package. See http://www.lcqb.upmc.fr/GEMME/download.html for more details and a docker 
#image containing all dependencies

# source activate proteingym_env 

DMS_reference_file="../../reference_files/DMS_substitutions.csv"
DMS_DATA_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/substitutions_merged"
MSA_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_merged/DMS_substitutions_MSAs"
protein_index=0
OUTPUT_SCORES_FOLDER="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions/GEMME"
GEMME_LOCATION="/n/groups/marks/software/GEMME/GEMME"
JET2_LOCATION="/n/groups/marks/software/JET2/JET2"

python ../../proteingym/baselines/gemme/compute_fitness.py --DMS_index=$protein_index --DMS_reference_file_path=$DMS_reference_file \
--DMS_data_folder=$DMS_DATA_FOLDER --MSA_folder=$MSA_FOLDER --output_scores_folder=$OUTPUT_SCORES_FOLDER \
--GEMME_path=$GEMME_LOCATION --JET_path=$JET2_LOCATION