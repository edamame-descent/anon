# ProteinGym

## Overview

ProteinGym is an extensive set of Deep Mutational Scanning (DMS) assays curated to enable thorough comparisons of various mutation effect predictors indifferent regimes. It is comprised of two benchmarks: 1) a substitution benchmark which currently consists of the experimental characterisation of ∼3.3M missense variants across 192 DMS assays 2) an indel benchmark that includes ∼300k mutants across 74 DMS assays.

Each processed file in each benchmark corresponds to a single DMS assay, and contains the following variables:
- mutant (str): describes the set of substitutions to apply on the reference sequence to obtain the mutated sequence (eg., A1P:D2N implies the amino acid 'A' at position 1 should be replaced by 'P', and 'D' at position 2 should be replaced by 'N'). Present in the the ProteinGym substitution assays only (not indels).
- mutated_sequence (str): represents the full amino acid sequence for the mutated protein.
- DMS_score (float): corresponds to the experimental measurement in the DMS assay. Across all assays, the higher the DMS_score value, the higher the fitness of the mutated protein
- DMS_score_bin (int): indicates whether the DMS_score is above the fitness cutoff (1 is fit, 0 is not fit)

Additionally, we provide two reference files for each benharmk that give further details on each assay and contain in particular:
- The UniProt_ID of the corresponding protein, along with taxon and MSA depth category
- The target sequence (target_seq) used in the assay
- Details on how the DMS_score was created from the raw files and how it was binarized 

To download the substitution benchmark (~1.3G unzipped):
```
curl -o ProteinGym_substitutions.zip https://marks.hms.harvard.edu/proteingym/ProteinGym_substitutions.zip 
unzip ProteinGym_substitutions.zip
rm ProteinGym_substitutions.zip
```

Similarly, to download the indel benchmark (~212M unzipped):
```
curl -o ProteinGym_indels.zip https://marks.hms.harvard.edu/proteingym/ProteinGym_indels.zip
unzip ProteinGym_indels.zip
rm ProteinGym_indels.zip
```

The ProteinGym benchmarks are also available on the [Hugging Face Hub](https://huggingface.co/datasets/OATML-Markslab/ProteinGym).

## Fitness prediction performance

The [Detailed_performance_files](https://github.com/OATML-Markslab/ProteinGym/tree/main/Detailed_performance_files) folder provides detailed performance files for all baselines on the two ProteinGym benchmarks, for the 3 focus performance metrics (Spearman's rank, AUC, MCC) as introduced in the original [Tranception paper](https://proceedings.mlr.press/v162/notin22a.html).

We recommand to aggregate fitness prediction performance at the Uniprot ID level to avoid biasing results towards proteins for which several DMS assays are available in ProteinGym. The corresponding aggregated files are suffixed with "_Uniprot_level", while the non aggregated performance files are suffixed with "_DMS_level". Note that there is at most one DMS per Uniprot_ID for the ProteinGym indel benchmark (ie., no difference between "_Uniprot_level" and "_DMS_level"). We thus only provide one set of performance metrics for that benchmark.

### ProteinGym benchmarks - Leaderboard

The full ProteinGym benchmarks performance files are also accessible via our dedicated website: https://www.proteingym.org/.
It includes leaderboards for the substitution and indel benchmarks, as well as detailed DMS-level performance files for all baselines.
The current version of the substitution benchmark includes the following baselines:

Model name | Model type | Reference
--- | --- | --- |
Site Independent | Alignment-based model | [Hopf, T.A., Ingraham, J., Poelwijk, F.J., Schärfe, C.P., Springer, M., Sander, C., & Marks, D.S. (2017). Mutation effects predicted from sequence co-variation. Nature Biotechnology, 35, 128-135.](https://www.nature.com/articles/nbt.3769)
EVmutation | Alignment-based model | [Hopf, T.A., Ingraham, J., Poelwijk, F.J., Schärfe, C.P., Springer, M., Sander, C., & Marks, D.S. (2017). Mutation effects predicted from sequence co-variation. Nature Biotechnology, 35, 128-135.](https://www.nature.com/articles/nbt.3769)
Wavenet | Alignment-based model | [Shin, J., Riesselman, A.J., Kollasch, A.W., McMahon, C., Simon, E., Sander, C., Manglik, A., Kruse, A.C., & Marks, D.S. (2021). Protein design and variant prediction using autoregressive generative models. Nature Communications, 12.](https://www.nature.com/articles/s41467-021-22732-w)
DeepSequence | Alignment-based model | [Riesselman, A.J., Ingraham, J., & Marks, D.S. (2018). Deep generative models of genetic variation capture the effects of mutations. Nature Methods, 15, 816-822.](https://www.nature.com/articles/s41592-018-0138-4)
GEMME | Alignment-based model | [Laine, É., Karami, Y., & Carbone, A. (2019). GEMME: A Simple and Fast Global Epistatic Model Predicting Mutational Effects. Molecular Biology and Evolution, 36, 2604 - 2619.](https://pubmed.ncbi.nlm.nih.gov/31406981/)
EVE | Alignment-based model | [Frazer, J., Notin, P., Dias, M., Gomez, A.N., Min, J.K., Brock, K.P., Gal, Y., & Marks, D.S. (2021). Disease variant prediction with deep generative models of evolutionary data. Nature.](https://www.nature.com/articles/s41586-021-04043-8)
Unirep | Protein language model | [Alley, E.C., Khimulya, G., Biswas, S., AlQuraishi, M., & Church, G.M. (2019). Unified rational protein engineering with sequence-based deep representation learning. Nature Methods, 1-8](https://www.nature.com/articles/s41592-019-0598-1)
ESM-1b | Protein language model | Original model: [Rives, A., Goyal, S., Meier, J., Guo, D., Ott, M., Zitnick, C.L., Ma, J., & Fergus, R. (2019). Biological structure and function emerge from scaling unsupervised learning to 250 million protein sequences. Proceedings of the National Academy of Sciences of the United States of America, 118](https://www.biorxiv.org/content/10.1101/622803v4); Extensions: [Brandes, N., Goldman, G., Wang, C.H., Ye, C.J., & Ntranos, V. (2022). Genome-wide prediction of disease variants with a deep protein language model. bioRxiv.]('https://www.biorxiv.org/content/10.1101/2022.08.25.505311v1)
ESM-1v | Protein language model | [Meier, J., Rao, R., Verkuil, R., Liu, J., Sercu, T., & Rives, A. (2021). Language models enable zero-shot prediction of the effects of mutations on protein function. NeurIPS.](https://proceedings.neurips.cc/paper/2021/hash/f51338d736f95dd42427296047067694-Abstract.html)
VESPA | Protein language model | [Marquet, C., Heinzinger, M., Olenyi, T., Dallago, C., Bernhofer, M., Erckert, K., & Rost, B. (2021). Embeddings from protein language models predict conservation and variant effects. Human Genetics, 141, 1629 - 1647.](https://link.springer.com/article/10.1007/s00439-021-02411-y)
RITA | Protein language model | [Hesslow, D., Zanichelli, N., Notin, P., Poli, I., & Marks, D.S. (2022). RITA: a Study on Scaling Up Generative Protein Sequence Models. ArXiv, abs/2205.05789.](https://arxiv.org/abs/2205.05789)
ProtGPT2 | Protein language model | [Ferruz, N., Schmidt, S., & Höcker, B. (2022). ProtGPT2 is a deep unsupervised language model for protein design. Nature Communications, 13.](https://www.nature.com/articles/s41467-022-32007-7)
Progen2 | Protein language model | [Nijkamp, E., Ruffolo, J.A., Weinstein, E.N., Naik, N., & Madani, A. (2022). ProGen2: Exploring the Boundaries of Protein Language Models. ArXiv, abs/2206.13517.](https://arxiv.org/abs/2206.13517)
MSA Transformer | Hybrid |[Rao, R., Liu, J., Verkuil, R., Meier, J., Canny, J.F., Abbeel, P., Sercu, T., & Rives, A. (2021). MSA Transformer. ICML.](http://proceedings.mlr.press/v139/rao21a.html)
Tranception | Hybrid | [Notin, P., Dias, M., Frazer, J., Marchena-Hurtado, J., Gomez, A.N., Marks, D.S., & Gal, Y. (2022). Tranception: protein fitness prediction with autoregressive transformers and inference-time retrieval. ICML.](https://proceedings.mlr.press/v162/notin22a.html)
TranceptEVE | Hybrid | [Notin, P., Van Niekerk, L., Kollasch, A., Ritter, D., Gal, Y. & Marks, D.S. &  (2022). TranceptEVE: Combining Family-specific and Family-agnostic Models of Protein Sequences for Improved Fitness Prediction. NeurIPS, LMRL workshop.](https://www.biorxiv.org/content/10.1101/2022.12.07.519495v1?rss=1)

Except for the Wavenet model (which only uses alignments to recover a set of homologous protein sequences to train on, but then trains on non-aligned sequences), all alignment-based methods are unable to score indels given the fixed coordinate system they are trained on. Similarly, the masking procedure to generate the masked-marginals for ESM-1v and MSA Transformer requires the position to exist in the wild-type sequence. All the other model architectures listed above (eg., Tranception, RITA, Progen2) are included in the indel benchmark.

## Aggregated model scoring files
The scores for all DMS assays in the ProteinGym substitution benchmark for all baselines (eg., Tranception, EVE, Wavenet, ESM-1v, MSA Transformer) may be downloaded as follows;
```
curl -o scores_all_models_proteingym_substitutions.zip https://marks.hms.harvard.edu/proteingym/scores_all_models_proteingym_substitutions.zip
unzip scores_all_models_proteingym_substitutions.zip
rm scores_all_models_proteingym_substitutions.zip
```
Similarly for the indel benchmark, all scoring files may be downloaded as follows:
```
curl -o scores_all_models_proteingym_indels.zip https://marks.hms.harvard.edu/proteingym/scores_all_models_proteingym_indels.zip
unzip scores_all_models_proteingym_indels.zip
rm scores_all_models_proteingym_indels.zip
```

## Multiple Sequence Alignments (MSAs)

The MSAs used to train alignment-based methods or used at inference in Tranception with retrieval and MSA Transformer may be downloaded as follows (~4.3GB unzipped):
```
curl -o MSA_ProteinGym.zip https://marks.hms.harvard.edu/proteingym/MSA_ProteinGym.zip
unzip MSA_ProteinGym.zip
rm MSA_ProteinGym.zip
```

## How to contribute?

### New assays
If you would like to suggest new assays to be part of ProteinGym, please raise an issue on this repository with a `new_assay' label. The criteria we typically consider for inclusion are as follows:
1. The corresponding raw dataset needs to be publicly available
2. The assay needs to be protein-related (ie., exclude UTR, tRNA, promoter, etc.)
3. The dataset needs to have insufficient number of measurements
4. The assay needs to have a sufficiently high dynamic range
5. The assay has to be relevant to fitness prediction

### New baselines
If you would like new baselines to be included in ProteinGym (ie., website, performance files, detailed scoring files), please raise an issue on this repository with a 'new_model' label. At this point we are only considering models satisfying the following conditions:
1. The approach is unsupervised (the DMS measurements should not be used to train the model);
2. The model is able to score all mutants across all the assays (to ensure all models are compared exactly on the same set of mutants everywhere);
3. The corresponding code is open source (we should be able to reproduce scores if needed).
At this stage, we are only considering requests for which all model scores for all mutants in a given benchmark (substitution or indel) are provided by the requester; but we are planning on regularly scoring new baselines ourselves for methods with wide adoption by the community and/or suggestions with many upvotes.

## License
This project is available under the MIT license.

## Reference
If you use ProteinGym in your work, please cite the following paper:
```
TBD
```

## Links
<!-- - Original paper: https://proceedings.mlr.press/v162/notin22a.html -->
- Website: https://www.proteingym.org/
- HuggingFace: https://huggingface.co/datasets/OATML-Markslab/ProteinGym