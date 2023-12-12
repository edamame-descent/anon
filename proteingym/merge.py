import pandas as pd
import numpy as np
import os
import json
import argparse
from tqdm import tqdm

def standardization(x):
    """Assumes input is numpy array or pandas series"""
    return (x - x.mean()) / x.std()

proteingym_folder_path = os.path.dirname(os.path.realpath(__file__))

def main():
    parser = argparse.ArgumentParser(description='ProteinGym score merging')
    parser.add_argument('--DMS_assays_location', type=str, default='~/.cache/ProteinGym/ProteinGym/DMS_assays/substitutions', help='Path to folder containing all model scores')
    parser.add_argument('--model_scores_location', type=str, default='~/.cache/ProteinGym/model_scores/zero_shot_substitutions', help='Path to folder containing all model scores')
    parser.add_argument('--merged_scores_dir', type=str, default="merged_scores", help='Name of folder where all merged scores should be stored (in model_scores_location)')
    parser.add_argument('--mutation_type', default='substitutions', type=str, help='Type of mutations (substitutions | indels)')
    parser.add_argument('--dataset', default='DMS', type=str, help='Dataset to merge (DMS | clinical)')
    parser.add_argument('--DMS_reference_file', default=f'{os.path.dirname(proteingym_folder_path)}/reference_files/DMS_substitutions.csv', type=str, help='Path to reference file containing DMS assay information')
    parser.add_argument('--config_file', default=f'{os.path.dirname(proteingym_folder_path)}/config.json', type=str, help='Path to config file containing model information')
    args = parser.parse_args()

    reference_file = pd.read_csv(args.DMS_reference_file)
    list_DMS = reference_file["DMS_id"]

    with open(args.config_file) as f:
        config = json.load(f)
    if args.dataset=="DMS":
        reference_field = "model_list_zero_shot_substitutions_DMS" if args.mutation_type=="substitutions" else "model_list_zero_shot_indels_DMS"
    elif args.dataset=="clinical":
        reference_field = "model_list_zero_shot_substitutions_clinical" if args.mutation_type=="substitutions" else "model_list_zero_shot_indels_clinical"

    list_models = config[reference_field].keys()
    pbar = tqdm(enumerate(list_DMS), total=len(list_DMS)) 
    for DMS_index, DMS_id in pbar:
        target_seq = reference_file["target_seq"][reference_file["DMS_id"]==DMS_id].values[0]
        pbar.set_description("Processing DMS assay {}".format(DMS_id))
        DMS_filename = reference_file["DMS_filename"][reference_file["DMS_id"]==DMS_id].values[0]
        full_DMS_path = os.path.join(args.DMS_assays_location,DMS_filename)
        if os.path.exists(full_DMS_path):
            DMS_file = pd.read_csv(os.path.join(args.DMS_assays_location,DMS_filename))
        else:
            print("Could not find DMS file {}. Skipping.".format(full_DMS_path))
            continue

        # print("Length DMS: {}".format(len(DMS_file)))
        if "mutated_sequence" not in DMS_file: DMS_file["mutated_sequence"]=DMS_file["mutant"]

        score_files={}
        all_model_scores = DMS_file
        orig_DMS_length = len(all_model_scores)
        for model in list_models:
            mutant_merge_key = config[reference_field][model]["key"]
            input_score_name = config[reference_field][model]["input_score_name"]
            # try:
            score_files[model] = pd.read_csv(os.path.join(args.model_scores_location,config[reference_field][model]["location"],DMS_id+".csv"))
            if "sequence" in score_files[model]: score_files[model]["mutated_sequence"]=score_files[model]["sequence"]
            score_files[model][model] = config[reference_field][model]["directionality"] * score_files[model][input_score_name]
            score_files[model] = score_files[model][[mutant_merge_key,model]]
            score_files[model].drop_duplicates(inplace=True)
            score_files[model] = score_files[model].groupby(mutant_merge_key).mean().reset_index()
            # check that score_files[model][mutant_merge_key] and all_model_scores[mutant_merge_key] are the same
            if set(score_files[model][mutant_merge_key]) < set(all_model_scores[mutant_merge_key]):
                # print difference between two key sets 
                print("WARNING: {} and {} do not have the same keys. Skipping.".format(model, DMS_id))
                continue
            all_model_scores = pd.merge(all_model_scores, score_files[model], on = mutant_merge_key, how = 'left')
            if len(all_model_scores) != orig_DMS_length:
                print("WARNING: Merge on {} for {} changed length. mutant_merge_keys are likely different between them.".format(model, DMS_id))
                print("Length DMS: {}".format(orig_DMS_length))
                print("Length {}: {}".format(model, len(score_files[model])))
                print("Length all_model_score unique keys: {}".format(len(all_model_scores[mutant_merge_key].unique())))
                print("Length DMS unique keys: {}".format(len(score_files[model][mutant_merge_key].unique())))
                print("Length merged file: {}".format(len(all_model_scores)))
                continue
            # except:
                # print("Could not load model {} for assay {}".format(model,DMS_id))
        # if all([name in all_model_scores.columns for name in ['RITA_s','RITA_m','RITA_l','RITA_xl']]): 
            # all_model_scores['RITA_ensemble'] = (standardization(all_model_scores['RITA_s'])+standardization(all_model_scores['RITA_m'])+standardization(all_model_scores['RITA_l'])+standardization(all_model_scores['RITA_xl']))/4.0
        # if all([name in all_model_scores.columns for name in ['Progen2_small','Progen2_medium','Progen2_base','Progen2_large','Progen2_xlarge']]):
            # all_model_scores['Progen2_ensemble'] = (standardization(all_model_scores['Progen2_small'])+standardization(all_model_scores['Progen2_medium'])+standardization(all_model_scores['Progen2_base'])+standardization(all_model_scores['Progen2_large'])+standardization(all_model_scores['Progen2_xlarge']))/5.0
        if not os.path.isdir(os.path.join(args.model_scores_location,args.merged_scores_dir)): os.mkdir(os.path.join(args.model_scores_location,args.merged_scores_dir))
        all_model_scores.to_csv(os.path.join(args.model_scores_location,args.merged_scores_dir,f"{DMS_id}.csv"), index=False)
        print("Length merged file: {}".format(len(all_model_scores)))

if __name__ == '__main__':
    main()