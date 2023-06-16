import os
MSA_folder = "/scratch/pastin/protein/ProteinGym/MSA_files"
all_WT_sequences_fasta = "baselines/vespa/all_WT_sequences.fasta"

for filename in os.listdir(MSA_folder):
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