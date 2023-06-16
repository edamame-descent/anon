import os
import pandas as pd
import numpy as np
from scipy.stats import spearmanr
import tqdm

mapping_location = "/users/pastin/projects/TranceptEVE/proteingym/ProteinGym_reference_file_substitutions.csv"
mapping_protein_seq_DMS = pd.read_csv(mapping_location)
DMS_data_folder = "/scratch/pastin/protein/ProteinGym/ProteinGym_substitutions"
VESPA_mapping_location = "/users/pastin/projects/TranceptEVE/baselines/vespa/VESPA_mapping.csv"
VESPA_mapping = pd.read_csv(VESPA_mapping_location) #DMS_id,DMS_filename,UniProt_ID,MSA_filename,VESPA_scoring_file_index,VESPA_scoring_file_name
VESPA_scores_folder = "/scratch/pastin/protein/baselines/VESPA/model_scores/vespa_run_directory/output"
VESPA_final_scores_folder = "/scratch/pastin/protein/baselines/VESPA/model_scores/ProteinGym"
spearman_values = "/users/pastin/projects/TranceptEVE/baselines/vespa/spearman.csv"

mapping_protein_seq_DMS = pd.merge(mapping_protein_seq_DMS,VESPA_mapping[['DMS_id','VESPA_scoring_file_index','VESPA_scoring_file_name']],how='left',on='DMS_id')

list_DMS = mapping_protein_seq_DMS["DMS_id"]

multiples=['A4_HUMAN_Seuma_2021','CAPSD_AAV2S_Sinai_substitutions_2021','DLG4_HUMAN_Faure_2021','F7YBW8_MESOW_Aakre_2015','GCN4_YEAST_Staller_induction_2018','GFP_AEQVI_Sarkisyan_2016',\
            'GRB2_HUMAN_Faure_2021','HIS7_YEAST_Pokusaeva_2019','PABP_YEAST_Melamed_2013','SPG1_STRSG_Olson_2014','YAP1_HUMAN_Araya_2012']

for DMS_id in list_DMS:
#for DMS_id in multiples:
    print(DMS_id)
    DMS_filename = mapping_protein_seq_DMS["DMS_filename"][mapping_protein_seq_DMS["DMS_id"]==DMS_id].values[0]
    VESPA_scores_filename = mapping_protein_seq_DMS["VESPA_scoring_file_index"][mapping_protein_seq_DMS["DMS_id"]==DMS_id].values[0]
    VESPA_scores_filename = str(VESPA_scores_filename) + '.csv'
    DMS_file = pd.read_csv(DMS_data_folder+os.sep+DMS_filename) #mutant,mutated_sequence,DMS_score,DMS_score_bin
    VESPA_scores = pd.read_csv(VESPA_scores_folder+os.sep+VESPA_scores_filename, sep=";")
    MSA_start = mapping_protein_seq_DMS["MSA_start"][mapping_protein_seq_DMS["DMS_id"]==DMS_id].values[0]
    VESPA_scores['mutant'] = VESPA_scores['Mutant'].apply(lambda x: x[0] + str(int(x[1:-1])+MSA_start) + x[-1])
    VESPA_scores['VESPA'] = np.log(1 - VESPA_scores['VESPA']) #log proba of being functional (raw score is proba that mutation has an "effect")
    VESPA_scores['VESPAl'] = np.log(1 - VESPA_scores['VESPAl'])
    #final_file = pd.merge(DMS_file,VESPA_scores[['mutant','VESPAl','VESPA']], how='left',on='mutant')
    mapping_mutant_VESPA={}
    mapping_mutant_VESPAl={}
    for mutant in tqdm.tqdm(DMS_file['mutant']):
        VESPA_score_singles_sum = 0
        VESPAl_score_singles_sum = 0
        #Proba of multiple mutants to be benign is the product that each mutant is benign
        for single in mutant.split(":"):
            VESPA_score_singles_sum += VESPA_scores['VESPA'][VESPA_scores['mutant']==single].values[0]
            VESPAl_score_singles_sum += VESPA_scores['VESPAl'][VESPA_scores['mutant']==single].values[0]
        assert VESPA_score_singles_sum!=0, "Missing VESPA scores"
        mapping_mutant_VESPA[mutant] = VESPA_score_singles_sum
        mapping_mutant_VESPAl[mutant] = VESPAl_score_singles_sum
    mapping_mutant_VESPA = pd.DataFrame.from_dict(mapping_mutant_VESPA, orient='index').reset_index()
    mapping_mutant_VESPA.columns = ['mutant','VESPA']
    mapping_mutant_VESPAl = pd.DataFrame.from_dict(mapping_mutant_VESPAl, orient='index').reset_index()
    mapping_mutant_VESPAl.columns = ['mutant','VESPAl']
    final_scores_VESPA = pd.merge(DMS_file,mapping_mutant_VESPA, how='left',on='mutant')
    final_scores_VESPA = pd.merge(final_scores_VESPA,mapping_mutant_VESPAl, how='left',on='mutant')
    final_scores_VESPA.to_csv(VESPA_final_scores_folder+os.sep+DMS_id+'.csv', index=False)
    spearman_VESPA = spearmanr(final_scores_VESPA['DMS_score'], final_scores_VESPA['VESPA'])[0]
    spearman_VESPAl = spearmanr(final_scores_VESPA['DMS_score'], final_scores_VESPA['VESPAl'])[0]
    with open(spearman_values,'a+') as spearman_files_w:
        spearman_files_w.write(",".join([str(x) for x in [DMS_id,spearman_VESPA,spearman_VESPAl]])+"\n")





