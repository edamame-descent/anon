#!/bin/bash

# indices="103,104,107,108,109,114,115,116,117,118,121,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143"
indices="119"

# For loop over indices to score ESM1b on each of them 
for index in $(echo $indices | sed "s/,/ /g")
do
    echo $index
    /n/groups/marks/software/anaconda_o2/envs/tranception_env_daniel/bin/python3 ../../proteingym/baselines/esm/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --model_type ${model_type} \
    --dms_index ${index} \
    --dms_mapping ${dms_mapping} \
    --dms-input ${dms_input_folder} \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --scoring-window ${scoring_window}
done