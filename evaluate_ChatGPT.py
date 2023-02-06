import os
import re
import shutil
import sys
import numpy as np
import json
import time
from collections import defaultdict


def make_plan(tf_path):
    os.system(f'terraform -chdir={tf_path} init')
    os.system(f'terraform -chdir={tf_path} plan -out=binary')
    os.system(f'terraform -chdir={tf_path} show -json binary > {tf_path}/plan.json') 
    try:
        shutil.rmtree(f'{tf_path}/.terraform')
    except:
        print('----------------------------------')
        print(f"Can't delete {tf_path}/.terraform")

def remove_identifiers(txt_file):
    with open(txt_file, 'r', encoding='utf-8', errors='ignore') as file:
        identifiers = {}
        reference = {}
        i = 0
        for line in file:
            words = line.split(' ')
            if words[0] == 'resource' and len(words)>=3:
                reference[words[1][1:-1]+'.'+words[2][1:-1]] = words[1][1:-1]+'.name_'+str(i)
                identifiers[words[1]+' '+words[2]] = words[1]+' "name_'+str(i)+'"'
                i+=1
            if words[0]=='data' and len(words)>=3:
                reference['data.'+words[1][1:-1]+'.'+words[2][1:-1]] = 'data.'+words[1][1:-1]+'.name_'+str(i)
                identifiers[words[1]+' '+words[2]] = words[1]+' "name_'+str(i)+'"'
                i+=1
            if words[0]=='variable' and len(words)>=2:
                reference['var.'+words[1][1:-1]] = 'var.name_'+str(i)
                identifiers['variable '+words[1]] = 'variable "name_'+str(i)+'"'
                i+=1
            if words[0]=='output' and len(words)>=2:
                reference['output.'+words[1][1:-1]] = 'output.name_'+str(i)
                identifiers['output '+words[1]] = 'output "name_'+str(i)+'"'
                i+=1
        file.seek(0)
        text = file.read()

    for k in sorted(identifiers.keys(), reverse=True):
        text = text.replace(k, identifiers[k])
    for k in sorted(reference.keys(), reverse=True):
        text = text.replace(k, reference[k])
    return text


def pass1(basepath, n_samples):
    out_txt = open(f'{basepath}/FunctionalityTestChatGPT.txt', 'w+', encoding='utf-8', errors='ignore')
    out_txt.write('Task | Success rate | Errors | Distribution\n')
    total_success_rate = []
    task_names = []
    for task in sorted(os.listdir(f'{basepath}/human-tf')):
        task_names.append(task)
        #n_samples = len(os.listdir(f'data/{provider}/{model}-tf/{task}'))
        # find the number of duplicates
        i = 0
        sample_to_int = {}
        distr = [0]*n_samples
        for sample in sorted(os.listdir(f'{basepath}/ChatGPT-tf/{task}')):
            sample_to_int[sample]=i
            if not os.path.exists(f'{basepath}/ChatGPT-tf/{task}/{sample}/plan.json'):
                try:
                    duplicate = os.listdir(f'{basepath}/ChatGPT-tf/{task}/{sample}')[0]
                    distr[sample_to_int[duplicate[:-4]]]+=1
                except:
                    print(f'{basepath}/ChatGPT-tf/{task}/{sample}')
                    shutil.rmtree(f'{basepath}/ChatGPT-tf/{task}/{sample}')
                    sys.exit(f'{basepath}/ChatGPT-tf/{task}/{sample}')
            else:
                distr[i] +=1
            i+=1
            if i == n_samples:
                break
        # calculate success rate on tasks
        i == 0
        errors = []
        human_file = open(f'{basepath}/human-tf/{task}/plan.json', 'r', encoding='utf-8', errors='ignore')
        human_json = human_file.read()
        human_json = clean_json(human_json)
        success_rate=[0]*n_samples
        for sample in sorted(os.listdir(f'{basepath}/ChatGPT-tf/{task}')):
            if os.path.exists(f'{basepath}/ChatGPT-tf/{task}/{sample}/plan.json'):
                model_file = open(f'{basepath}/ChatGPT-tf/{task}/{sample}/plan.json', 'r', encoding='utf-8', errors='ignore')
                model_json = model_file.read()
                model_json = clean_json(model_json)
                if model_json == human_json:
                    success_rate[sample_to_int[sample]] = distr[sample_to_int[sample]]
                else: 
                    errors.append(int(sample[7:]))
            i += 1
            if i == n_samples:
                break

        total_success_rate.append(np.mean(success_rate))
        out_txt.write(f'{task} | {np.mean(success_rate)*100}% | {sorted(errors)} | {distr}\n')
    out_txt.write(f'Average success rate {np.mean(total_success_rate)*100}%\n')

def clean_json(input):
    input = re.sub('"(tags|tags_all)":.+?},','', input)
    input = re.sub('"constant_value":(true|false)', '', input)
    input = re.sub('"(description|name|constant_value|terraform_version|resource_group_name|id|bucket_name|network|instance)":".+?"','', input)
    input = re.sub('"(description|name|constant_value|terraform_version|resource_group_name|id|bucket_name|network)":null','', input)
    input = re.sub('"(name|description)":{.*?}','', input)
    input = re.sub('"(profile)":{.*?}','', input)
    # "profile":{"constant_value":"default"}
    input = re.sub('({|}|,|\[|\]|"|:)','', input)
    return  re.sub('\n','', input)

def make_json_model(basepath):
    print(f'------------------------------------\nChatGPT')
    for task in sorted(os.listdir(f"{basepath}/ChatGPT-txt")):
        if task == "instance":
            print(task)
            hash_to_sample = {}
            
            tf_path = f'{basepath}/ChatGPT-tf/{task}'
            if not os.path.exists(tf_path): 
                os.makedirs(tf_path)

            for sample_txt in sorted(os.listdir(f'{basepath}/ChatGPT-txt/{task}')):
                sample = sample_txt[:-4]
                if not os.path.exists(f'{tf_path}/{sample}'):
                    os.makedirs(f'{tf_path}/{sample}')
                    clean_txt = remove_identifiers(f'{basepath}/ChatGPT-txt/{task}/{sample_txt}',)
                    
                    if hash(clean_txt) not in hash_to_sample:
                        hash_to_sample[hash(clean_txt)] = sample
                        tf_file = open( f'{tf_path}/{sample}/main.tf', 'w', encoding='utf-8', errors='ignore')
                        tf_file.write(clean_txt)
                        tf_file.close()
                        make_plan(f'{tf_path}/{sample}')
                    else:
                        duplicate = hash_to_sample[hash(clean_txt)]
                        tf_file = open(f'{tf_path}/{sample}/{duplicate}.txt', 'w', encoding='utf-8', errors='ignore')
                        tf_file.close()

def make_json_human(basepath):
    print('------------------------------------\nhuman')
    for task in sorted(os.listdir(f'{basepath}/human-txt')):
        print(task)
        tf_path = f'{basepath}/human-tf/{task[:-4]}'
        if not os.path.exists(tf_path):
            os.makedirs(tf_path)
            clean_txt = remove_identifiers(f'{basepath}/human-txt/{task}')
            tf_file = open(tf_path+'/main.tf', 'w', encoding='utf-8', errors='ignore')
            if task[:-4] == 'provider':
                clean_txt = add_resource(clean_txt, "aws")
                print("clean_txt", clean_txt)
            tf_file.write(clean_txt)
            tf_file.close()
            make_plan(tf_path)

def add_resource(txt_file, provider):
    re_file = open(f'data/resource/{provider}_resource.txt', 'r', encoding='utf-8', errors='ignore')
    resource = re_file.read()
    return txt_file+'\n'+resource


if __name__ == "__main__":
    basepath = "C:/Users/flexl/Documents/Uni/PraktikumHyper/TerraformSecurity-Analysis"
    n_samples = 10
    #make_json_model(basepath)
    #make_json_human(basepath)
    pass1(basepath, n_samples)