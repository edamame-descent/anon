import pandas as pd
import numpy as np
import os
import json
import argparse

def standardization(x):
    """Assumes input is numpy array or pandas series"""
    return (x - x.mean()) / x.std()

proteingym_folder_path = os.path.dirname(os.path.realpath(__file__))
reference_files_location = os.path.join(os.path.dirname(proteingym_folder_path),'reference_files')

#"/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/model_scores/all_mutants_20230319"
#/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions
# wavenet indels -- sequence (not mutant)
def main():
    parser = argparse.ArgumentParser(description='ProteinGym score merging')
    parser.add_argument('--DMS_assays_location', type=str, default='~/.cache/ProteinGym/ProteinGym/DMS_assays/substitutions', help='Path to folder containing all model scores')
    parser.add_argument('--model_scores_location', type=str, default='~/.cache/ProteinGym/model_scores/zero_shot_substitutions', help='Path to folder containing all model scores')
    parser.add_argument('--merged_scores_dir', type=str, default="merged_scores", help='Name of folder where all merged scores should be stored (in model_scores_location)')
    parser.add_argument('--mutation_type', default='substitutions', type=str, help='Type of mutations (substitutions | indels)')
    args = parser.parse_args()

    reference_file = pd.read_csv(os.path.join(reference_files_location,"DMS_"+args.mutation_type+".csv"))
    list_DMS = reference_file["DMS_id"]

    with open('/home/pn73/proteingym_dev/config.json', 'r') as f:
        config = json.load(f)
    reference_field = "model_list_zero_shot_substitutions_DMS" if args.mutation_type=="substitutions" else "model_list_zero_shot_indels_DMS"
    list_models = config[reference_field].keys()
    
    for DMS_index, DMS_id in enumerate(list_DMS[:87]):
        print(DMS_id)
        DMS_filename = reference_file["DMS_filename"][reference_file["DMS_id"]==DMS_id].values[0]
        DMS_file = pd.read_csv(os.path.join(args.DMS_assays_location,DMS_filename))
        print("Length DMS: {}".format(len(DMS_file)))
        #if "mutant" not in DMS_file: DMS_file["mutant"]=DMS_file["mutated_sequence"]
        if "mutated_sequence" not in DMS_file: DMS_file["mutated_sequence"]=DMS_file["mutant"]
        #mutant_key="mutant"
        #if mutation_type=="substitutions": mutant_key="mutant"
        score_files={}
        all_model_scores = DMS_file
        for model in list_models:
            mutant_merge_key = config[reference_field][model]["key"]
            input_score_name = config[reference_field][model]["input_score_name"]
            try:
            #if True:
                score_files[model] = pd.read_csv(os.path.join(args.model_scores_location,config[reference_field][model]["location"],DMS_filename))
                if "sequence" in score_files[model]: score_files[model]["mutated_sequence"]=score_files[model]["sequence"]
                #if "RITA" in model: 
                #    score_files[model]["mutant"] = DMS_file["mutant"]
                #    score_files[model].to_csv(os.path.join(args.model_scores_location,config["model_list_zero_shot_substitutions_DMS"][model]["location"],DMS_filename),index=False)
                #if model=="ESM1v_single":
                #    score_files[model]['Ensemble_ESM1v'] = (score_files[model]['esm1v_t33_650M_UR90S_1']+score_files[model]['esm1v_t33_650M_UR90S_2']+score_files[model]['esm1v_t33_650M_UR90S_3']+score_files[model]['esm1v_t33_650M_UR90S_4']+score_files[model]['esm1v_t33_650M_UR90S_5'])/5.0
                #    score_files[model].to_csv(os.path.join(args.model_scores_location,config["model_list_zero_shot_substitutions_DMS"][model]["location"],DMS_filename),index=False)
                score_files[model][model] = config[reference_field][model]["directionality"] * score_files[model][input_score_name]
                score_files[model] = score_files[model][[mutant_merge_key,model]]
                score_files[model].drop_duplicates(inplace=True)
                score_files[model] = score_files[model].groupby(mutant_merge_key).mean().reset_index()
                score_files[model] = score_files[model][score_files[model][mutant_merge_key]!='wt'] #remove wild type from scoring files (eg., EVE)
                all_model_scores = pd.merge(all_model_scores, score_files[model], on = mutant_merge_key, how = 'inner')
            except:
            #else:
                print("Could not load model {} for assay {}".format(model,DMS_id))
                        
        all_model_scores['RITA_ensemble'] = (standardization(all_model_scores['RITA_s'])+standardization(all_model_scores['RITA_m'])+standardization(all_model_scores['RITA_l'])+standardization(all_model_scores['RITA_xl']))/4.0
        all_model_scores['Progen2_ensemble'] = (standardization(all_model_scores['Progen2_small'])+standardization(all_model_scores['Progen2_medium'])+standardization(all_model_scores['Progen2_base'])+standardization(all_model_scores['Progen2_large'])+standardization(all_model_scores['Progen2_xlarge']))/5.0
        
        if not os.path.isdir(os.path.join(args.model_scores_location,args.merged_scores_dir)): os.mkdir(os.path.join(args.model_scores_location,args.merged_scores_dir))
        all_model_scores.to_csv(os.path.join(args.model_scores_location,args.merged_scores_dir,DMS_filename), index=False)
        print("Length merged file: {}".format(len(all_model_scores)))

if __name__ == '__main__':
    main()