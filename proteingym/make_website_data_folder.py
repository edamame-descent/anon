# This script just combines and renames the csv files in a folder to easily move over to the proteingym website 
import os 
import shutil 

if __name__ == "__main__":
    metrics = ["Spearman","MCC","AUC","NDCG","MSE"]
    output_folder = "../benchmarks/website_data/"
    input_folder = "../benchmarks/"
    for metric in metrics:
        if not os.path.isdir(f"{output_folder}/{metric}"):
            os.mkdir(f"{output_folder}/{metric}")
    for dataset in ["clinical","DMS"]:
        for model_type in ["supervised","zero_shot"]:
            for mutation_type in ["indels","substitutions"]:
                for metric in metrics:
                    if metric == "MSE" and model_type != "supervised":
                        continue 
                    if not os.path.exists(input_folder + os.sep + f"{dataset}_{model_type}" + os.sep + mutation_type + os.sep + metric):
                        print(f"Missing {dataset}_{model_type}" + os.sep + mutation_type + os.sep + metric + ". Skipping")
                    else:
                        metric_folder = input_folder + os.sep + f"{dataset}_{model_type}" + os.sep + mutation_type + os.sep + metric
                        if os.path.exists(metric_folder + os.sep + f"Summary_performance_{dataset}_{mutation_type}_{metric}.csv"):
                            shutil.copy(metric_folder + os.sep + f"Summary_performance_{dataset}_{mutation_type}_{metric}.csv",f"{output_folder}/{metric}/aggregate_{model_type}_{dataset}_{mutation_type}_data.csv")
                        else:
                            print(f"Missing {metric_folder + os.sep + f'Summary_performance_{dataset}_{mutation_type}_{metric}.csv'}")
                        if os.path.exists(metric_folder + os.sep + f"{dataset}_{mutation_type}_{metric}_DMS_level.csv"):
                            shutil.copy(metric_folder + os.sep + f"{dataset}_{mutation_type}_{metric}_DMS_level.csv",f"{output_folder}/{metric}/{model_type}_{dataset}_{mutation_type}_data.csv")
                        else:
                            print(f"Missing {metric_folder + os.sep + f'{dataset}_{mutation_type}_{metric}_DMS_level.csv'}")
