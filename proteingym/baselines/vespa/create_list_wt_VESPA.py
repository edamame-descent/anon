import os
import pandas as pd 
MSA_folder = "/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/DMS"
reference_file = "../../../reference_files/DMS_substitutions.csv"
# reference_file = "/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/reference_files/nan_rerun_ref_file_2023_10_09.csv"
all_WT_sequences_fasta = "./hsp82.fasta"
ref_df = pd.read_csv(reference_file)
# ref_df = ref_df[ref_df["ProteinGym_version"] == 1]
# ref_df = pd.concat([ref_df[ref_df["DMS_id"].str.contains("PAI1")],ref_df[199:]])
ref_df = ref_df[35:36]
print(len(os.listdir(MSA_folder)))
for filename in ref_df["MSA_filename"].unique():
    f = os.path.join(MSA_folder, filename)
    target_seq=""
    with open(f, 'r') as msa_data:
        for i, line in enumerate(msa_data):
            line = line.rstrip()
            if line.startswith(">") and i==0:
                with open(all_WT_sequences_fasta,'a+') as seq_wt_file:
                    seq_wt_file.write(line+"\n")
            elif line.startswith(">"):
                break
            else:
                with open(all_WT_sequences_fasta,'a+') as seq_wt_file:
                    seq_wt_file.write(line+"\n")