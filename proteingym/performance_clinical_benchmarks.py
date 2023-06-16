import pandas as pd
import numpy as np
import os
import argparse
from scipy.stats import spearmanr
from sklearn.metrics import roc_auc_score, matthews_corrcoef
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

def standardization(x):
    """Assumes input is numpy array or pandas series"""
    return (x - x.mean()) / x.std()

def main():
    parser = argparse.ArgumentParser(description='Tranception performance analysis')
    parser.add_argument('--TranceptEVE_scoring_files_folder', type=str, help='Name of folder where all input scores are present (expects one scoring file per DMS)')
    parser.add_argument('--output_performance_filename', default='./outputs/tranception_performance', type=str, help='Name of folder where to save performance analysis files')
    parser.add_argument('--ClinVar_reference_file_path', type=str, help='Reference file with list of DMSs to consider')
    args = parser.parse_args()
    
    mapping_protein_seq_DMS = pd.read_csv(args.ClinVar_reference_file_path)
    num_DMS=len(mapping_protein_seq_DMS)
    print("There are {} proteins in reference file".format(num_DMS))
    
    if os.path.exists(args.output_performance_filename):
        os.system('rm -rf '+args.output_performance_filename)

    score_variables = ['TranceptEVE_score','EVE_scores_ASM','EVE_scores_ASM_std','ESM1b_score'] #EVE_scores_BPU
    with open(args.output_performance_filename,"a") as perf_file:
        list_models=",".join(score_variables)
        perf_file.write("Uniprot_ID,"+list_models+"\n")
    list_proteins = mapping_protein_seq_DMS["DMS_id"]

    all_scores = []
    for protein in list_proteins:
        print(protein)   
        score_file_name =  protein + '.csv'
        try:
            scores = pd.read_csv(args.TranceptEVE_scoring_files_folder+os.sep+score_file_name)
        except:
            with open("missing_TranceptEVE_scoring_files_20221130.csv","a") as missing_files:
                missing_files.write(protein+"\n")
            continue
        
        if len(scores)>0:
            scores = scores[scores.EVE_scores_ASM.notnull()]
            scores['TranceptEVE_score'] = - scores['avg_score']
            scores['ESM1b_score'] = - scores['ESM1b_score']
            AUC={}
            try:
                for model in score_variables:
                    AUC[model] = roc_auc_score(y_true=scores['ClinVar_binary_target'], y_score=scores[model])
                with open(args.output_performance_filename,"a") as perf_file:
                    AUC_perf = ",".join([str(AUC[x]) for x in score_variables])
                    perf_log = ",".join([str(x) for x in [protein,AUC_perf]])
                    perf_file.write(perf_log+"\n")
            except:
                print("AUC computation issue with {}".format(protein))
                continue
            scores['Uniprot_ID'] = [protein] * len(scores)
            all_scores.append(scores)
        else:
            print("Scoring file is empty (no BP mutation) {}".format(protein))
        
    perf_data = pd.read_csv(args.output_performance_filename)
    perf_data.set_index('Uniprot_ID', inplace=True)
    perf_data_average = perf_data.mean(axis=0)
    perf_data.loc['Average'] = perf_data_average
    perf_data.to_csv(args.output_performance_filename)

    all_scores = pd.concat(all_scores,axis=0)
    overall_AUC={}
    overall_AUC_log=['Overall_AUC']
    all_scores.dropna(inplace=True)
    for model in score_variables:
        overall_AUC[model] = roc_auc_score(y_true=all_scores['ClinVar_binary_target'], y_score=all_scores[model])
        overall_AUC_log.append(overall_AUC[model])
    with open(args.output_performance_filename,"a") as perf_log:
        perf_log.write(",".join([str(x) for x in overall_AUC_log])+"\n")
        perf_log.write("Number of total labels included: {} (Pathogenic: {}; Benign: {})".format(len(all_scores),len(all_scores[all_scores['ClinVar_binary_target']==1]),len(all_scores[all_scores['ClinVar_binary_target']==0])))
        
if __name__ == '__main__':
    main()